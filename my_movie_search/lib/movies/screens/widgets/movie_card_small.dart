import 'package:flutter/material.dart'
    show
        BuildContext,
        ElevatedButton,
        Icon,
        Icons,
        Image,
        ListTile,
        NetworkImage,
        Text,
        Widget;
import 'package:my_movie_search/movies/models/metadata_dto.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieTile extends ListTile {
  MovieTile(this.context, this.movie)
      : super(
          leading: _getImage(movie),
          title: _getTitle(movie),
          trailing: _getButton(context, movie),
          subtitle: _getDescription(movie),
          onTap: () => _navigate(context, movie),
        );
  final BuildContext context;
  final MovieResultDTO movie;

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
      case MovieContentType.person:
      case MovieContentType.barcode:
        break;
      default:
        middle.add(movie.bestSource.excludeNone);
        end.add(movie.language.excludeNone);
    }
    final combined = [...start, '-', ...middle, '-', ...end]
        .trimJoin(' ', ' -')
        .reduceWhitespace()
        .replaceAll('- -', '-');

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
      case MovieContentType.person:
        start.add(movie.charactorName);
        end.add(ratingCount);
      case MovieContentType.barcode:
        start.add(movie.bestSource.excludeNone);
        end.add(movie.alternateTitle);
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
        .reduceWhitespace()
        .replaceAll('- -', '-');
    return Text(
      combined,
      textScaleFactor: 1.0,
      maxLines: 5,
    );
  }

  static Widget _getIcon(MovieResultDTO movie) {
    switch (movie.type) {
      // See available icons at https://fonts.google.com/icons
      case MovieContentType.barcode:
        return const Icon(Icons.skip_next);
      case MovieContentType.error:
        return const Icon(Icons.unfold_more);
      case MovieContentType.information:
        return const Icon(Icons.info);
      case MovieContentType.navigation:
        return const Icon(Icons.skip_next);
      case MovieContentType.person:
        return const Icon(Icons.person);
      case MovieContentType.keyword:
        return const Icon(Icons.manage_search);
      case MovieContentType.download:
        return movie.imageUrl == ''
            ? const Icon(Icons.block)
            : const Icon(Icons.download);
      default:
        return const Icon(Icons.theaters);
    }
  }

  static Widget _getImage(MovieResultDTO movie) {
    if (movie.type != MovieContentType.download &&
        movie.imageUrl.startsWith(webAddressPrefix)) {
      return Image(image: NetworkImage(movie.imageUrl));
    }
    return _getIcon(movie);
  }

  static Widget? _getButton(BuildContext context, MovieResultDTO movie) {
    switch (movie.type) {
      case MovieContentType.navigation:
        return _navigateButton(context, movie);
      case MovieContentType.keyword:
        return _navigateButton(context, movie);
      case MovieContentType.barcode:
        return _navigateButton(context, movie);
      case MovieContentType.download:
        return movie.imageUrl == '' ? null : _navigateButton(context, movie);

      default:
        return movie.sources.containsKey(DataSourceType.fbmmsnavlog)
            ? const Icon(Icons.visibility)
            : const Text('');
    }
  }

  static void _navigate(BuildContext context, MovieResultDTO movie) =>
      MMSNav(context).resultDrillDown(movie);

  static ElevatedButton _navigateButton(
    BuildContext context,
    MovieResultDTO movie, {
    Widget? icon,
  }) =>
      ElevatedButton(
        onPressed: () => _navigate(context, movie),
        child: icon ?? _getIcon(movie),
      );
}
