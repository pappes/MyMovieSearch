import 'package:flutter/material.dart'
    show Widget, Text, ListTile, BuildContext, Navigator, Image, NetworkImage;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieTile extends ListTile {
  MovieTile(BuildContext context, MovieResultDTO movie)
      : super(
          leading: _getImage(movie.imageUrl),
          title: _getTitle(movie),
          subtitle: _getDescription(movie),
          onTap: () => Navigator.push(
            context,
            getRoute(context, movie),
          ),
        );

  static Widget _getTitle(MovieResultDTO movie) {
    return Text(
      '${movie.title}(${movie.yearRange == '' ? movie.year : movie.yearRange}, '
      '${movie.bestSource.name}), ${movie.language.name})',
      textScaleFactor: 1.0,
    );
  }

  static Widget _getDescription(MovieResultDTO movie) {
    final rating = (movie.censorRating != CensorRatingType.none)
        ? '${movie.censorRating.name} '
        : '';
    final content =
        (movie.type != MovieContentType.none) ? '${movie.type.name}    ' : '';
    final alternateTitle =
        (movie.alternateTitle.isEmpty) ? '' : '${movie.alternateTitle} ';
    final charactorName =
        (movie.charactorName.isEmpty) ? '' : '${movie.charactorName} ';
    final ratingCount = (movie.userRatingCount > 0 || movie.userRating > 0)
        ? '${movie.userRating} (${formatter.format(movie.userRatingCount)})'
        : '';
    final runtime = (movie.runTime.inMinutes > 0)
        ? movie.runTime.toFormattedTime() + (ratingCount.isEmpty ? ' ' : ' - ')
        : '';
    return Text(
      '$rating$content$charactorName$alternateTitle$runtime$ratingCount',
      textScaleFactor: 1.0,
    );
  }

  static Widget _getImage(String url) {
    if (url == '' || !url.startsWith('http')) {
      return const Text('NoImage');
    }
    return Image(image: NetworkImage(url));
  }
}
