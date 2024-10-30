import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class Movie {
  final bool adult;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'genre_ids')
  final List<int> genreIds;
  final int id;
  @JsonKey(name: 'original_language')
  final String originalLanguage;
  @JsonKey(name: 'original_title')
  final String originalTitle;
  final String overview;
  final double popularity;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  @JsonKey(name: 'release_date')
  final String releaseDate;
  final String title;
  final bool video;
  @JsonKey(name: 'vote_average')
  final double voteAverage;
  @JsonKey(name: 'vote_count')
  final int voteCount;

  Movie({
    required this.adult,
    this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  // Deserialize JSON to Model
  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  // Serialize Model to JSON
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  static List<Movie> parseMovies(String responseBody) {
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    final List<dynamic> results = parsed['results'];

    return results.map<Movie>((json) => Movie.fromJson(json)).toList();
  }
}
