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
import 'package:my_movie_search/movies/screens/person_details.dart';

import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/movie_details.dart';
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
      '${describeEnum(movie.source)}), ${describeEnum(movie.language)})',
      textScaleFactor: 1.0,
    );
  }

  static Widget _getDescription(MovieResultDTO movie) {
    var rating = (movie.censorRating != CensorRatingType.none)
        ? '${describeEnum(movie.censorRating)} '
        : '';
    var content = (movie.type != MovieContentType.none)
        ? '${describeEnum(movie.type)}    '
        : '';
    var ratingCount = (movie.userRatingCount > 0)
        ? '${movie.userRating} (${formatter.format(movie.userRatingCount)})'
        : '';
    var runtime =
        (movie.runTime > Duration()) ? movie.runTime.toFormattedTime() : '';
    var seperator =
        (runtime.length > 0 && ratingCount.length > 0) ? ' - ' : ' ';
    return Text(
      rating +
          content +
          '${movie.alternateTitle} ' +
          runtime +
          seperator +
          ratingCount,
      textScaleFactor: 1.0,
    );
  }

  static _openDetails(BuildContext context, MovieResultDTO movie) {
    if (movie.uniqueId.startsWith('nm')) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PersonDetailsPage(person: movie)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MovieDetailsPage(movie: movie)),
      );
    }
  }

  static Widget _getImage(String url) {
    if (url == '' || !url.startsWith('http'))
      return CircularProgressIndicator();
    return Image(image: NetworkImage(url));
  }
}
