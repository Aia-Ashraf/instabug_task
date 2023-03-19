import 'dart:convert';

import '../../domain/models/movie_item.dart';
import 'package:http/http.dart' as http;

import '../../domain/models/movies.dart';


class MoviesApiProvider {
  MoviesApiProvider({required this.httpClient}) ;

    final http.Client httpClient;

  Future<List<MovieItem>?> fetchMovies([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
          'api.themoviedb.org',
          '/3/discover/movie',{
        'api_key':'66318345e625439a18db0447a6dab6a9',
      }),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) ;
      return Movies.fromJson(body).movies;
    }
    throw Exception('error fetching Movies${response.request!.url}');
  }

}