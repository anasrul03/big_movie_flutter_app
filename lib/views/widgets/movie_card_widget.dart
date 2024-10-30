import 'package:big_movie_app/models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shimmer/shimmer.dart';

class MovieCardWidget extends StatelessWidget {
  const MovieCardWidget({super.key, this.movie});

  final Movie? movie;

  @override
  Widget build(BuildContext context) {
    final String imagePrefix = dotenv.env['IMAGE_PREFIX'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.4,
            blurRadius: 3,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: movie == null
          ? Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      )
          : CachedNetworkImage(
        imageUrl: imagePrefix + (movie!.posterPath ?? ''),
        fit: BoxFit.cover,
      ),
    );
  }
}