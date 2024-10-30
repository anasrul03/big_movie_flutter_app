import 'package:big_movie_app/models/movie_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shimmer/shimmer.dart';
import 'package:big_movie_app/keys/movie_card_keys.dart';

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
              key: movieCardLoadingKey,
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 250,
                color: Colors.white,
              ),
            )
          : CachedNetworkImage(
              key: imagePrefix.isEmpty
                  ? movieCardErrorIconKey
                  : movieCardKey(movie?.id.toString() ?? ''),
              imageUrl: imagePrefix.isEmpty
                  ? ''
                  : imagePrefix + (movie?.posterPath ?? ''),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
    );
  }
}
