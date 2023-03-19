

import 'package:equatable/equatable.dart';
import 'package:instabug_task/Movies/domain/models/models.dart';

enum MovieStatus { initial, success, failure }

class MovieState extends Equatable {
   MovieState({
    this.status = MovieStatus.initial,
    this.movies = const <MovieItem>[],
    this.hasReachedMax = false,
  });

  final MovieStatus status;
  final List<MovieItem> movies;
  final bool hasReachedMax;

  MovieState copyWith({
    MovieStatus? status,
    List<MovieItem>? movies,
    bool? hasReachedMax,
  }) {
    return MovieState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''MovieState { status: $status, hasReachedMax: $hasReachedMax, Movies: ${movies.length} }''';
  }

  @override
  List<Object> get props => [status, movies, hasReachedMax];
}
