import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

class MovieTile extends ListTile {
  MovieTile(this.context, this.movie, {super.key})
    : super(
        leading: _getImage(movie),
        title: _getTitle(movie),
        trailing: _getNavigateButtons(context, movie),
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
    final middle = <String>[];
    final end = <String>[];
    switch (movie.type) {
      case MovieContentType.download:
        middle.add(movie.bestSource.excludeNone);
      case MovieContentType.person:
      case MovieContentType.barcode:
      case MovieContentType.searchprompt:
        break;

      case MovieContentType.movie:
      case MovieContentType.none:
      case MovieContentType.title:
      case MovieContentType.episode:
      case MovieContentType.series:
      case MovieContentType.miniseries:
      case MovieContentType.short:
      case MovieContentType.custom:
      case MovieContentType.keyword:
      case MovieContentType.error:
      case MovieContentType.information:
      case MovieContentType.navigation:
        middle.add(movie.bestSource.excludeNone);
        end.add(movie.language.excludeNone);
    }
    final combined = [
      ...start,
      '-',
      ...middle,
      '-',
      ...end,
    ].trimJoin(' ', ' -').reduceWhitespace().replaceAll('- -', '-');

    return Text(combined, maxLines: 5);
  }

  static Widget _getDescription(MovieResultDTO movie) {
    final ratingCount = '(${formatter.format(movie.userRatingCount)})';
    final start = <String>[];
    final middle = <String>[];
    final end = <String>[];
    switch (movie.type) {
      case MovieContentType.download:
        final seeders = 'S:${movie.creditsOrder} L:${movie.userRatingCount}';
        start.add(seeders);
        middle.add(movie.characterName);
        end.add(movie.description);
      case MovieContentType.person:
        start.add(movie.characterName);
        end.add(ratingCount);
      case MovieContentType.barcode:
        start.add(movie.bestSource.excludeNone);
        end.add(movie.alternateTitle);
      case MovieContentType.searchprompt:
        end.add(movie.alternateTitle);
        final location =
            'Stacker:${movie.creditsOrder} Disk:${movie.userRatingCount}';
        end.add(location);

      case MovieContentType.movie:
      case MovieContentType.none:
      case MovieContentType.title:
      case MovieContentType.episode:
      case MovieContentType.series:
      case MovieContentType.miniseries:
      case MovieContentType.short:
      case MovieContentType.custom:
      case MovieContentType.keyword:
      case MovieContentType.error:
      case MovieContentType.information:
      case MovieContentType.navigation:
        start.add(movie.runTime.toFormattedTime());
        middle.add(movie.censorRating.excludeNone);
        middle.add(movie.type.name);
        middle.add(movie.userRating.toString());
        middle.add(ratingCount);
        end.add(movie.alternateTitle);
        end.add(movie.characterName);
    }
    final combined = [
      ...start,
      '-',
      ...middle,
      '-',
      ...end,
    ].trimJoin(' ', ' -').reduceWhitespace().replaceAll('- -', '-');
    return Text(combined, maxLines: 5);
  }

  static Widget _getIcon(MovieResultDTO movie) {
    switch (movie.type) {
      // See available icons at https://fonts.google.com/icons
      case MovieContentType.barcode:
        return const Icon(Icons.skip_next);
      case MovieContentType.searchprompt:
        return const Icon(Icons.manage_search);
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

      case MovieContentType.movie:
      case MovieContentType.none:
      case MovieContentType.title:
      case MovieContentType.episode:
      case MovieContentType.series:
      case MovieContentType.miniseries:
      case MovieContentType.short:
      case MovieContentType.custom:
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

  static Widget? _getNavigateButtons(
    BuildContext context,
    MovieResultDTO movie,
  ) {
    final widgets = <Widget>[];
    switch (movie.type) {
      case MovieContentType.navigation:
      case MovieContentType.keyword:
      case MovieContentType.barcode:
      case MovieContentType.searchprompt:
        widgets.add(_navigateButton(context, movie));
      case MovieContentType.download:
        if (movie.imageUrl.isNotEmpty) {
          widgets.add(_navigateButton(context, movie));
        }

      case MovieContentType.person:
      case MovieContentType.movie:
      case MovieContentType.none:
      case MovieContentType.title:
      case MovieContentType.episode:
      case MovieContentType.series:
      case MovieContentType.miniseries:
      case MovieContentType.short:
      case MovieContentType.custom:
      case MovieContentType.error:
      case MovieContentType.information:
        {
          getReadIcon(movie, widgets);
          getDVDIcon(movie, widgets);
        }
    }
    if (widgets.isEmpty) return null;
    return Row(mainAxisSize: MainAxisSize.min, children: widgets);
  }

  static void getReadIcon(MovieResultDTO movie, List<Widget> widgets) {
    final read = movie.getReadIndicator();
    try {
      final readHistory = getEnumValue<ReadHistory>(read, ReadHistory.values);
      logger.t('read indicator = ${movie.uniqueId} $read');
      switch (readHistory) {
        case ReadHistory.starred:
          widgets.add(const Icon(Icons.star));
        case ReadHistory.reading:
          widgets.add(const Icon(Icons.visibility, fill: 1));
        case ReadHistory.read:
          widgets.add(const Icon(Icons.visibility));
        case ReadHistory.none:
        case ReadHistory.custom:
          widgets.add(const Icon(Icons.question_mark));
        case null:
      }
      // ignore: avoid_catching_errors
    } on ArgumentError {
      logger.t('old inidcator = ${movie.uniqueId} $read');
      if (read != null && read.isNotEmpty) {
        widgets.add(const Icon(Icons.visibility_off, fill: 1));
      }
    }
  }

  static void getDVDIcon(MovieResultDTO movie, List<Widget> widgets) {
    if (MovieLocation().getLocationsForMovie(movie.uniqueId).isNotEmpty) {
      widgets.add(const Icon(Icons.album));
    }
  }

  static void _navigate(BuildContext context, MovieResultDTO movie) {
    unawaited(MMSNav(context).resultDrillDown(movie));
  }

  static ElevatedButton _navigateButton(
    BuildContext context,
    MovieResultDTO movie, {
    Widget? icon,
  }) => ElevatedButton(
    onPressed: () => _navigate(context, movie),
    child: icon ?? _getIcon(movie),
  );
}
