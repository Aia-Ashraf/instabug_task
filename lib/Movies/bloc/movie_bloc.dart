import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:instabug_task/Movies/data/remote/movies_api_provider.dart';
import 'package:stream_transform/stream_transform.dart';

import 'movie_event.dart';
import 'movie_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({required this.apiProvider}) : super(MovieState()) {
    on<MovieFetched>(
      _onMovieFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final MoviesApiProvider apiProvider;


  Future<void> _onMovieFetched(
    MovieFetched event,
    Emitter<MovieState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MovieStatus.initial) {
        final Movies = await apiProvider.fetchMovies();
        return emit(
          state.copyWith(
            status: MovieStatus.success,
            movies: Movies,
            hasReachedMax: false,
          ),
        );
      }
      final movies = await apiProvider.fetchMovies(state.movies.length);
      movies!.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: MovieStatus.success,
                movies: List.of(state.movies)..addAll(movies),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: MovieStatus.failure));
    }
  }
}
