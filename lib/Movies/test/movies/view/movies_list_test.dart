// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_task/Movies/bloc/movie_bloc.dart';
import 'package:instabug_task/Movies/bloc/movie_event.dart';
import 'package:instabug_task/Movies/bloc/movie_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../domain/models/movie_item.dart';
import '../../../presentation/view/movies_list.dart';
import '../../../widgets/bottom_loader.dart';
import '../../../widgets/movies_list_item.dart';

class MockMovieBloc extends MockBloc<MovieEvent, MovieState> implements MovieBloc {}

extension on WidgetTester {
  Future<void> pumpMoviesList(MovieBloc movieBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: movieBloc,
          child: MoviesList(),
        ),
      ),
    );
  }
}

void main() {
  final mockMovies = List.generate(
    5,
    (i) => MovieItem(id: i, title: 'movie title'),
  );

  late MovieBloc movieBloc;

  setUp(() {
    movieBloc = MockMovieBloc();
  });

  group('MoviesList', () {
    testWidgets(
        'renders CircularProgressIndicator '
        'when movie status is initial', (tester) async {
      when(() => movieBloc.state).thenReturn(MovieState());
      await tester.pumpMoviesList(movieBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renders no movies text '
        'when movie status is success but with 0 movies', (tester) async {
      when(() => movieBloc.state).thenReturn(
        MovieState(status: MovieStatus.success, hasReachedMax: true),
      );
      await tester.pumpMoviesList(movieBloc);
      expect(find.text('no movies'), findsOneWidget);
    });

    testWidgets(
        'renders 5 movies and a bottom loader when movie max is not reached yet',
        (tester) async {
      when(() => movieBloc.state).thenReturn(
        MovieState(
          status: MovieStatus.success,
          movies: mockMovies,
        ),
      );
      await tester.pumpMoviesList(movieBloc);
      expect(find.byType(MovieListItem), findsNWidgets(5));
      expect(find.byType(BottomLoader), findsOneWidget);
    });

    testWidgets('does not render bottom loader when movie max is reached',
        (tester) async {
      when(() => movieBloc.state).thenReturn(
        MovieState(
          status: MovieStatus.success,
          movies: mockMovies,
          hasReachedMax: true,
        ),
      );
      await tester.pumpMoviesList(movieBloc);
      expect(find.byType(BottomLoader), findsNothing);
    });

    testWidgets('fetches more movies when scrolled to the bottom',
        (tester) async {
      when(() => movieBloc.state).thenReturn(
        MovieState(
          status: MovieStatus.success,
          movies: List.generate(
            10,
            (i) => MovieItem(id: i, title: 'movie title'),
          ),
        ),
      );
      await tester.pumpMoviesList(movieBloc);
      await tester.drag(find.byType(MoviesList), const Offset(0, -500));
      verify(() => movieBloc.add(MovieFetched())).called(1);
    });
  });
}
