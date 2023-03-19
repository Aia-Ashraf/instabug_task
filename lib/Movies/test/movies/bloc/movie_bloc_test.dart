import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:instabug_task/Movies/data/remote/movies_api_provider.dart';
import 'package:instabug_task/Movies/domain/models/models.dart';
import 'package:mocktail/mocktail.dart';

import '../../../bloc/movie_bloc.dart';
import '../../../bloc/movie_event.dart';
import '../../../bloc/movie_state.dart';

class MockClient extends Mock implements http.Client {}

Uri _moviesUrl({required int start}) {
  return   Uri.https(
      'api.themoviedb.org',
      '/3/discover/movie',{
    'api_key':'66318345e625439a18db0447a6dab6a9',
  });
}

void main() {
  group('MovieBloc', () {
    var mockMovies = [MovieItem(id: 1, title: 'movies title')];
    var extraMockMovies = [
      MovieItem(id: 2, title: 'movies title')
    ];

    late http.Client httpClient;
    late MoviesApiProvider moviesApiProvider;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockClient();
      moviesApiProvider = MoviesApiProvider(httpClient: httpClient);
    });

    test('initial state is MovieState()', () {
      expect(MovieBloc(apiProvider: moviesApiProvider).state,  MovieState());
    });

    group('MovieFetched', () {
      blocTest<MovieBloc, MovieState>(
        'emits nothing when moviess has reached maximum amount',
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        seed: () =>  MovieState(hasReachedMax: true),
        act: (bloc) => bloc.add(MovieFetched()),
        expect: () => <MovieState>[],
      );

      blocTest<MovieBloc, MovieState>(
        'emits successful status when http fetches initial moviess',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '{"page":1,"results":[{"adult":false,"backdrop_path":"/2Eewgp7o5AU1xCataDmiIL2nYxd.jpg","genre_ids":[18,36],"id":943822,"original_language":"en","original_title":"Prizefighter: The Life of Jem Belcher","overview":"At the turn of the 19th century, Pugilism was the sport of kings and a gifted young boxer fought his way to becoming champion of England.","popularity":2533.482,"movieer_path":"/x3PIk93PTbxT88ohfeb26L1VpZw.jpg","release_date":"2022-06-30","title":"Prizefighter: The Life of Jem Belcher","video":false,"vote_average":7.1,"vote_count":44},]',
              200,
            );
          });
        },
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        act: (bloc) => bloc.add(MovieFetched()),
        expect: () => <MovieState>[
          MovieState(status: MovieStatus.success, movies: mockMovies)
        ],
        verify: (_) {
          verify(() => httpClient.get(_moviesUrl(start: 0))).called(1);
        },
      );

      blocTest<MovieBloc, MovieState>(
        'drops new events when processing current event',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "movies title", "body": "movies body" }]',
              200,
            );
          });
        },
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        act: (bloc) => bloc
          ..add(MovieFetched())
          ..add(MovieFetched()),
        expect: () => <MovieState>[
          MovieState(status: MovieStatus.success, movies: mockMovies)
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MovieBloc, MovieState>(
        'throttles events',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "movies title", "body": "movies body" }]',
              200,
            );
          });
        },
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        act: (bloc) async {
          bloc.add(MovieFetched());
          await Future<void>.delayed(Duration.zero);
          bloc.add(MovieFetched());
        },
        expect: () => <MovieState>[
          MovieState(status: MovieStatus.success, movies: mockMovies)
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<MovieBloc, MovieState>(
        'emits failure status when http fetches moviess and throw exception',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('', 500),
          );
        },
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        act: (bloc) => bloc.add(MovieFetched()),
        expect: () => <MovieState>[ MovieState(status: MovieStatus.failure)],
        verify: (_) {
          verify(() => httpClient.get(_moviesUrl(start: 0))).called(1);
        },
      );

      blocTest<MovieBloc, MovieState>(
        'emits successful status and reaches max moviess when '
        '0 additional moviess are fetched',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('[]', 200),
          );
        },
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        seed: () =>  MovieState(
          status: MovieStatus.success,
          movies: mockMovies,
        ),
        act: (bloc) => bloc.add(MovieFetched()),
        expect: () =>  <MovieState>[
          MovieState(
            status: MovieStatus.success,
            movies: mockMovies,
            hasReachedMax: true,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_moviesUrl(start: 1))).called(1);
        },
      );

      blocTest<MovieBloc, MovieState>(
        'emits successful status and does not reach max moviess '
        'when additional moviess are fetched',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 2, "title": "movies title", "body": "movies body" }]',
              200,
            );
          });
        },
        build: () => MovieBloc(apiProvider: moviesApiProvider),
        seed: () =>  MovieState(
          status: MovieStatus.success,
          movies: mockMovies,
        ),
        act: (bloc) => bloc.add(MovieFetched()),
        expect: () =>  <MovieState>[
          MovieState(
            status: MovieStatus.success,
            movies: [...mockMovies, ...extraMockMovies],
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_moviesUrl(start: 1))).called(1);
        },
      );
    });
  });
}
