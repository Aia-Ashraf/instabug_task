import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:instabug_task/Movies/bloc/movie_bloc.dart';
import 'package:instabug_task/Movies/bloc/movie_event.dart';
import 'package:instabug_task/Movies/data/remote/movies_api_provider.dart';
import 'movies_list.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: BlocProvider(
        create: (_) => MovieBloc(apiProvider: MoviesApiProvider(httpClient: http.Client()))..add(MovieFetched()),
        child: const MoviesList(),
      ),
    );
  }
}
