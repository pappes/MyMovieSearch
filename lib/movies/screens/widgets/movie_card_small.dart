import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieTile extends ListTile {
  MovieTile(BuildContext context, MovieResultDTO movie, {super.key})
    : super(
        leading: _getImage(movie),
        title: _getTitle(movie),
        trailing: _getNavigateButtons(context, movie),
        subtitle: _getDescription(movie),
        onTap: () => _navigate(context, movie),
      );

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
      case .download:
        middle.add(movie.bestSource.excludeNone);
      case .person:
        break;
      case .barcode:
      case .searchprompt:
        start.add(movie.description);
      case .error:
      case .information:
      case .status:
        start.add(movie.description);
      case .movie:
      case .none:
      case .title:
      case .episode:
      case .series:
      case .miniseries:
      case .short:
      case .custom:
      case .keyword:
      case .navigation:
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
      case .download:
        final seeders = 'S:${movie.creditsOrder} L:${movie.userRatingCount}';
        start.add(seeders);
        middle.add(movie.characterName);
        end.add(movie.description);
      case .person:
        start.add(movie.characterName);
        end.add(ratingCount);
      case .barcode:
        start.add(movie.bestSource.excludeNone);
        end.add(movie.alternateTitle);
      case .searchprompt:
        end.add(movie.alternateTitle);
        final location =
            'Stacker:${movie.creditsOrder} Disk:${movie.userRatingCount}';
        end.add(location);

      case .error:
      case .information:
      case .status:
        end.add(movie.alternateTitle);

      case .movie:
      case .keyword:
      case .none:
      case .title:
      case .episode:
      case .series:
      case .miniseries:
      case .short:
      case .custom:
      case .navigation:
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
      case .barcode:
        return const Icon(Icons.skip_next);
      case .searchprompt:
        return const Icon(Icons.manage_search);
      case .error:
        return const Icon(Icons.unfold_more);
      case .information:
      case .status:
        return const Icon(Icons.info);
      case .navigation:
        return const Icon(Icons.skip_next);
      case .person:
        return const Icon(Icons.person);
      case .keyword:
        return const Icon(Icons.manage_search);
      case .download:
        return movie.imageUrl == ''
            ? const Icon(Icons.block)
            : const Icon(Icons.download);

      case .movie:
      case .none:
      case .title:
      case .episode:
      case .series:
      case .miniseries:
      case .short:
      case .custom:
        return const Icon(Icons.theaters);
    }
  }

  static Widget _getImage(MovieResultDTO movie) {
    if (movie.type != .download &&
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
      case .navigation:
      case .keyword:
      case .barcode:
      case .searchprompt:
        widgets.add(_navigateButton(context, movie));

      case .download:
        if (movie.imageUrl.isNotEmpty) {
          widgets
            ..add(_navigateButton(context, movie))
            ..add(
              _remoteMagnetLinkButton(
                context,
                movie,
                icon: const Icon(Icons.dynamic_form),
              ),
            );
        }

      case .person:
      case .movie:
      case .none:
      case .title:
      case .episode:
      case .series:
      case .miniseries:
      case .custom:
      case .short:
        {
          getReadIcon(movie, widgets);
          getDVDIcon(movie, widgets);
        }
      case .error:
      case .information:
      case .status:
    }
    if (widgets.isEmpty) return null;
    return Row(mainAxisSize: MainAxisSize.min, children: widgets);
  }

  static void getReadIcon(MovieResultDTO movie, List<Widget> widgets) {
    final read = movie.getReadIndicator();
    try {
      final readHistory = ReadHistory.values.byFullName(read);
      AppLogger.instance.trace('read indicator = ${movie.uniqueId} $read');
      switch (readHistory) {
        case .starred:
          widgets.add(const Icon(Icons.star));
        case .reading:
          widgets.add(const Icon(Icons.visibility, fill: 1));
        case .read:
          widgets.add(const Icon(Icons.visibility));
        case .none:
        case .custom:
          widgets.add(const Icon(Icons.question_mark));
        case null:
      }
      // Make deserialisation robust.
      // ignore: avoid_catching_errors
    } on ArgumentError {
      AppLogger.instance.trace('old inidcator = ${movie.uniqueId} $read');
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
    MMSNav(context).resultDrillDown(movie);
  }

  static ElevatedButton _navigateButton(
    BuildContext context,
    MovieResultDTO movie, {
    Widget? icon,
  }) => ElevatedButton(
    onPressed: () => _navigate(context, movie),
    child: icon ?? _getIcon(movie),
  );

  static ElevatedButton _remoteMagnetLinkButton(
    BuildContext context,
    MovieResultDTO movie, {
    Widget? icon,
  }) => ElevatedButton(
    onPressed: () => MMSNav(context).remoteMagnetLink(movie, context),
    child: icon ?? _getIcon(movie),
  );
}
