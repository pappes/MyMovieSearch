import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/error_details.dart';
import 'package:my_movie_search/movies/screens/movie_details.dart';
import 'package:my_movie_search/movies/screens/movie_physical_location.dart';
import 'package:my_movie_search/movies/screens/movie_search_criteria.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/person_details.dart';
import 'package:my_movie_search/movies/screens/popup.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

const webAddressPrefix = 'http';

enum ScreenRoute {
  search,
  searchresults,
  persondetails,
  moviedetails,
  addlocation,
  errordetails,
}

class RouteInfo {
  RouteInfo(this.routePath, this.params, this.reference);

  final ScreenRoute routePath;
  final Object params;
  final String reference;

  @override
  String toString() => json.encode({
        'path': routePath,
        'params': params.toString(),
        'ref': reference,
      });
}

/// Performs page navigation
///
/// Headless testing can have a null context (no page navigation)
/// or an alternate canvas implementation using the _headless constructor.
class MMSNav {
  MMSNav([BuildContext? context]) {
    canvas = MMSFlutterCanvas(context);
  }
  MMSNav.headless(this.canvas);

  late MMSFlutterCanvas canvas;

  /// Render web page [url] in a child page of the current screen.
  ///
  /// For platforms that don't support CustomTabs
  /// the URL is displayed to the user.
  Future<void> viewWebPage(String url) async => canvas.viewWebPage(url);

  /// Navigates to a search results page populated with a movie list.
  ///
  Future<Object?> showResultsPage(SearchCriteriaDTO criteria) async =>
      canvas.viewFlutterPage(
        RouteInfo(
          ScreenRoute.searchresults,
          criteria,
          criteria.toUniqueReference(),
        ),
      );

  /// Navigates to a search results page
  /// populated with a predefined list of dtos.
  ///
  Future<Object?> searchForRelated(
    String description,
    List<MovieResultDTO> movies,
  ) async {
    if (movies.length == 1) {
      // Only one result so open details screen.
      return resultDrillDown(movies[0]);
    } else {
      // Multiple results so show them as individual cards.
      return showResultsPage(
        SearchCriteriaDTO().init(
          SearchCriteriaType.movieDTOList,
          title: description,
          list: movies,
        ),
      );
    }
  }

  /// Navigates to a search results page populated with movie for the keyword.
  ///
  Future<Object?> showMoviesForKeyword(String keyword) async =>
      // Fetch first batch of movies that match the keyword.

      showResultsPage(
        SearchCriteriaDTO().init(
          SearchCriteriaType.moviesForKeyword,
          title: keyword,
        ),
      );

  /// Navigates to a search results page populated with keywords for the movie.
  ///
  Future<Object?> getMoreKeywords(MovieResultDTO movie) async =>
      // Fetch first batch of movies that match the keyword.
      showResultsPage(
        SearchCriteriaDTO().init(
          SearchCriteriaType.moreKeywords,
          title: movie.uniqueId,
          list: [movie],
        ),
      );

  /// Navigates to a search results page populated with downloads for the movie.
  ///
  Future<Object?> showDownloads(String text, MovieResultDTO dto) async {
    // replace space with . for more matches
    final criteria = text.replaceAll(' ', '.');
    // Fetch first batch of movies that match the keyword.
    return showResultsPage(
      SearchCriteriaDTO().init(
        SearchCriteriaType.downloadSimple,
        title: criteria,
        list: [dto],
      ),
    );
  }

  /// Adds a physical location to a movie.
  ///
  Future<Object?> addLocation(MovieResultDTO movie) async =>
      canvas.viewFlutterPage(
        RouteInfo(ScreenRoute.addlocation, movie, movie.uniqueId),
      );

  /// Display more details for the selected card.
  ///
  Future<Object?> resultDrillDown(MovieResultDTO movie) async {
    switch (movie.type) {
      case MovieContentType.keyword:
        // Search for movies that match the keyword.
        return showMoviesForKeyword(movie.title);

      case MovieContentType.barcode:
        // Search for movies based on the data fetched for the barcode.

        return showResultsPage(
          SearchCriteriaDTO().init(
            SearchCriteriaType.movieTitle,
            title: getSearchTitle(movie),
          ),
        );

      case MovieContentType.navigation:
        if (movie.uniqueId.startsWith(webAddressPrefix)) {
          // Search for more movies that match the keyword.
          return showResultsPage(
            QueryIMDBMoviesForKeyword.convertMovieDtoToCriteriaDto(movie),
          );
        } else {
          // replace space with . for more specific searching
          final criteria = movie.uniqueId;
          // Fetch first batch of movies that match the keyword.
          return showResultsPage(
            SearchCriteriaDTO().init(
              SearchCriteriaType.downloadAdvanced,
              title: criteria,
              list: [movie],
            ),
          );
        }

      case MovieContentType.download:
        // Open magnet link.
        return canvas.viewWebPage(movie.imageUrl);

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
        movie.setReadIndicator(ReadHistory.reading.toString());
        // Show details screen (movie details or person details)
        return canvas.viewFlutterPage(movie.getDetailsPage()).then(
              (_) => movie.setReadIndicator(ReadHistory.read.toString()),
            );
    }
  }

  /// Defines known routes handled by MMSNav.
  ///
  static List<RouteBase> getRoutes() => [
        GoRoute(path: '/', pageBuilder: MovieSearchCriteriaPage.goRoute),
        GoRoute(
          name: ScreenRoute.search.name,
          path: '/$ScreenRoute.search.name',
          pageBuilder: MovieSearchCriteriaPage.goRoute,
        ),
        GoRoute(
          name: ScreenRoute.searchresults.name,
          path: '/$ScreenRoute.searchresults.name',
          pageBuilder: MovieSearchResultsNewPage.goRoute,
        ),
        GoRoute(
          name: ScreenRoute.persondetails.name,
          path: '/$ScreenRoute.persondetails.name',
          pageBuilder: PersonDetailsPage.goRoute,
        ),
        GoRoute(
          name: ScreenRoute.moviedetails.name,
          path: '/$ScreenRoute.moviedetails.name',
          pageBuilder: MovieDetailsPage.goRoute,
        ),
        GoRoute(
          name: ScreenRoute.addlocation.name,
          path: '/$ScreenRoute.addlocation.name',
          pageBuilder: MoviePhysicalLocationPage.goRoute,
        ),
        GoRoute(
          name: ScreenRoute.errordetails.name,
          path: '/$ScreenRoute.errordetails.name',
          pageBuilder: ErrorDetailsPage.goRoute,
        ),
      ];
}

class MMSFlutterCanvas {
  MMSFlutterCanvas(this.context);

  BuildContext? context;

  /// Render web page [url] in a child page of the current screen.
  ///
  /// For platforms that don't support CustomTabs
  /// the URL is displayed to the user.
  Future<Object?> viewWebPage(String url) async {
    if (null != context) {
      if (Platform.isAndroid && url.startsWith('http')) {
        return _invokeChromeCustomTabs(url);
      } else {
        return _openBrowser(url);
      }
    }
    return null;
  }

  /// Construct route to Material user interface page
  /// as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  Future<Object?> viewFlutterPage(RouteInfo page) {
    if (null != context) {
      NavLog(context!).logPageOpen(page.routePath.name, page.reference);
      try {
        return context!.pushNamed(page.routePath.name, extra: page.params)
          ..then((val) {
            NavLog(context!)
                .logPageClose(page.routePath.name, page.reference, page.params);
          });
      } catch (e) {
        logger.t(e);
      }
    }
    return Future.value(null);
  }

  Future<Object?> _invokeChromeCustomTabs(String url) async {
    Object? retval;
    await tabs
        .launch(
          url,
          customTabsOption: tabs.CustomTabsOption(
            toolbarColor: Theme.of(context!).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ),
        )
        .onError((error, stackTrace) => retval = _customTabsError(error, url));
    return retval;
  }

  Future<Object?> _customTabsError(Object? e, String url) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    return showPopup(
      context!,
      'Received error $e\nwhen opening $url',
      'Navigation error',
    );
  }

  Future<Object?> _openBrowser(String url) async {
    final success = await launcher.launchUrl(Uri.parse(url));
    // An exception is thrown if browser app is not installed on Android device.
    if (!success) {
      return showPopup(context!, url, 'Browser error');
    }
    return success;
  }
}
