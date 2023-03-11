import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:instabug_task/Movies/models/models.dart';
import 'package:stream_transform/stream_transform.dart';

import 'movie_event.dart';
import 'movie_state.dart';

const _MovieLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc({required this.httpClient}) : super(const MovieState()) {
    on<MovieFetched>(
      _onMovieFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onMovieFetched(
    MovieFetched event,
    Emitter<MovieState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == MovieStatus.initial) {
        final Movies = await _fetchMovies();
        return emit(
          state.copyWith(
            status: MovieStatus.success,
            movies: Movies,
            hasReachedMax: false,
          ),
        );
      }
      final movies = await _fetchMovies(state.movies.length);
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

  Future<List<MovieItem>?> _fetchMovies([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
          'api.themoviedb.org',
          '/3/discover/movie',{
            'api_key':'66318345e625439a18db0447a6d'
                ''
                'ab6a9',
          }),
    );
    print("aia${response.request!.url}" ?? "");
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("aiaM${response.request!.url}" ?? "");
      }
      final body = json.decode(response.body) ;
      return Movies.fromJson(body).movies;
    }
    throw Exception('error fetching Movies${response.request!.url}');
  }
}
