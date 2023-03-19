import 'package:flutter/material.dart';
import '../domain/models/movie_item.dart';


class MovieListItem extends StatelessWidget {
  const MovieListItem({super.key, required this.movie});

  final MovieItem movie;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Image.network("https://image.tmdb.org/t/p/w500"+ movie.backdropPath.toString(),height: 40,width: 40,),
        title: Text(movie.title??""),
        dense: true,
      ),
    );
  }
}