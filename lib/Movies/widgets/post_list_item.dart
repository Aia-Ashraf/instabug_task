import 'package:flutter/material.dart';
import 'package:instabug_task/Movies/models/models.dart';


class MovieListItem extends StatelessWidget {
  const MovieListItem({super.key, required this.movie});

  final MovieItem movie;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${movie.id}', style: textTheme.bodySmall),
        title: Text(movie.title??""),
        isThreeLine: true,
        subtitle: Text(movie.title??""),
        dense: true,
      ),
    );
  }
}
