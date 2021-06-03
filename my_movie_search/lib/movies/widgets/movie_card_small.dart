import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart'
    show
        Widget,
        Text,
        ListTile,
        BuildContext,
        Navigator,
        MaterialPageRoute,
        CircularProgressIndicator,
        Image,
        NetworkImage;

import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/movie_search_details.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';

class MovieTile extends ListTile {
  MovieTile(BuildContext context, MovieResultDTO movie)
      : super(
          leading: _getImage(movie.imageUrl),
          title: _getTitle(movie),
          subtitle: _getDescription(movie),
          onTap: () => _openDetails(context, movie),
        );

  static Widget _getTitle(MovieResultDTO movie) {
    return Text(
      '${movie.title}(${movie.yearRange == '' ? movie.year : movie.yearRange}, '
      '${describeEnum(movie.source)})',
      textScaleFactor: 1.0,
    );
  }

  static Widget _getDescription(MovieResultDTO movie) {
    return Text(
      ' ${describeEnum(movie.type)}   ${movie.runTime.toFormattedTime()} - '
      '${movie.userRating} (${formatter.format(movie.userRatingCount)})',
      textScaleFactor: 1.0,
    );
  }

  static _openDetails(BuildContext context, MovieResultDTO movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)),
    );
  }

  static Widget _getImage(String url) {
    if (url == '' || !url.startsWith('http'))
      return CircularProgressIndicator();
    return Image(image: NetworkImage(url));
  }
}
