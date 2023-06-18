import 'package:flutter/material.dart'
    show
        BuildContext,
        Icon,
        IconData,
        Icons,
        Image,
        ListTile,
        NetworkImage,
        Text,
        Widget;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieTile extends ListTile {
  MovieTile(BuildContext context, MovieResultDTO movie)
      : super(
          leading: _getImage(movie),
          title: _getTitle(movie),
          subtitle: _getDescription(movie),
          onTap: () => MMSNav(context).resultDrillDown(movie),
        );

  static Widget _getTitle(MovieResultDTO movie) {
    var year = '';
    if (movie.yearRange != '') {
      year = '(${movie.yearRange})';
    } else if (movie.year != 0) {
      year = '(${movie.year})';
    }

    final start = [movie.title, year];
    final middle = [];
    final end = [];
    switch (movie.type) {
      case MovieContentType.download:
        middle.add(movie.bestSource.excludeNone);
        break;
      case MovieContentType.person:
        break;
      default:
        middle.add(movie.bestSource.excludeNone);
        end.add(movie.language.excludeNone);
    }
    final combined = [...start, '-', ...middle, '-', ...end]
        .trimJoin(' ', ' -')
        .replaceAll('  ', ' ')
        .replaceAll('- -', '-')
        .trim();

    return Text(
      combined,
      textScaleFactor: 1.0,
      maxLines: 5,
    );
  }

  static Widget _getDescription(MovieResultDTO movie) {
    final ratingCount = '(${formatter.format(movie.userRatingCount)})';
    final start = [];
    final middle = [];
    final end = [];
    switch (movie.type) {
      case MovieContentType.download:
        final seeders = 'S:${movie.creditsOrder} L:${movie.userRatingCount}';
        start.add(seeders);
        middle.add(movie.charactorName);
        end.add(movie.description);
        break;
      case MovieContentType.person:
        start.add(movie.charactorName);
        end.add(ratingCount);
        break;
      default:
        start.add(movie.runTime.toFormattedTime());
        middle.add(movie.censorRating.excludeNone);
        middle.add(movie.type.name);
        middle.add(movie.userRating);
        middle.add(ratingCount);
        end.add(movie.alternateTitle);
        end.add(movie.charactorName);
    }
    final combined = [...start, '-', ...middle, '-', ...end]
        .trimJoin(' ', ' -')
        .replaceAll('  ', ' ')
        .replaceAll('- -', '-')
        .trim();
    return Text(
      combined,
      textScaleFactor: 1.0,
      maxLines: 5,
    );
  }

  static Widget _getImage(MovieResultDTO movie) {
    switch (movie.type) {
      // See available icons at https://fonts.google.com/icons
      case MovieContentType.error:
        return const Icon(Icons.unfold_more);
      case MovieContentType.information:
        return const Icon(Icons.info);
      case MovieContentType.navigation:
        return const Icon(Icons.skip_next);
      case MovieContentType.person:
        return const Icon(Icons.person);
      case MovieContentType.download:
        return movie.imageUrl == ''
            ? const Icon(Icons.block)
            : const Icon(Icons.download);
      default:
        return movie.imageUrl == ''
            ? const Icon(Icons.question_mark)
            : Image(image: NetworkImage(movie.imageUrl));
    }
  }
}
