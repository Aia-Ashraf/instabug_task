import 'movie_item.dart';

class Movies {
  Movies({
      this.page, 
      this.movies,
      this.totalPages, 
      this.totalResults,});

  Movies.fromJson(dynamic json) {
    page = json['page'];
    if (json['results'] != null) {
      movies = [];
      json['results'].forEach((v) {
        movies?.add(MovieItem.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }
  int? page;
  List<MovieItem>? movies;
  int? totalPages;
  int? totalResults;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    if (movies != null) {
      map['results'] = movies?.map((v) => v.toJson()).toList();
    }
    map['total_pages'] = totalPages;
    map['total_results'] = totalResults;
    return map;
  }

}