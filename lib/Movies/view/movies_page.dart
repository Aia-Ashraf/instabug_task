import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../bloc/movie_bloc.dart';
import '../bloc/movie_event.dart';
import 'movies_list.dart';

class MoviesPage extends StatelessWidget {
  const MoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: BlocProvider(
        create: (_) => MovieBloc(httpClient: http.Client())..add(MovieFetched()),
        child: const MoviesList(),
      ),
    );
  }
}
