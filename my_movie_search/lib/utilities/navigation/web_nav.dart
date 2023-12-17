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
import 'package:my_movie_search/movies/screens/movie_search_criteria.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/person_details.dart';
import 'package:my_movie_search/movies/screens/popup.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';
import 'package:my_movie_search/persistence/nav_log.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

const webAddressPrefix = 'http';

const routeHome = '';
const routeSearchCriteria = 'search';
const routeSearchResults = 'searchresults';
const routePersonDetails = 'persondetails';
const routeMovieDetails = 'moviedetails';
const routeErrorDetails = 'errordetails';

class RouteInfo {
  RouteInfo(this.routePath, this.params, this.reference);

  final String routePath;
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
  void viewWebPage(String url) => canvas.viewWebPage(url);

  /// Construct route to Material user interface page
  /// as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  RouteInfo getDetailsPage(
    MovieResultDTO movie,
  ) {
    if (movie.uniqueId.startsWith(imdbPersonPrefix) ||
        movie.type == MovieContentType.person) {
      // Open person details.
      return RouteInfo(routePersonDetails, movie, movie.uniqueId);
    } else if (movie.uniqueId.startsWith(imdbTitlePrefix) ||
        movie.type == MovieContentType.movie ||
        movie.type == MovieContentType.series ||
        movie.type == MovieContentType.miniseries ||
        movie.type == MovieContentType.short ||
        movie.type == MovieContentType.series ||
        movie.type == MovieContentType.episode ||
        movie.type == MovieContentType.title) {
      // Open Movie details.
      return RouteInfo(routeMovieDetails, movie, movie.uniqueId);
    } else {
      // Open error details.
      return RouteInfo(
        routeErrorDetails,
        movie,
        MovieContentType.error.toString(),
      );
    }
  }

  /// Navigates to a search results page populated with a movie list.
  ///
  Future<Object?> showResultsPage(SearchCriteriaDTO criteria) =>
      canvas.viewFlutterPage(
        RouteInfo(
          routeSearchResults,
          criteria,
          criteria.toUniqueReference(),
        ),
      );

  /// Navigates to a search results page
  /// populated with a predefined list of dtos.
  ///
  void searchForRelated(String description, List<MovieResultDTO> movies) {
    if (movies.length == 1) {
      // Only one result so open details screen.
      resultDrillDown(movies[0]);
    } else {
      // Multiple results so show them as individual cards.
      unawaited(
        showResultsPage(
          SearchCriteriaDTO().init(
            SearchCriteriaType.movieDTOList,
            title: description,
            list: movies,
          ),
        ),
      );
    }
  }

  /// Navigates to a search results page populated with movie for the keyword.
  ///
  void getMoviesForKeyword(String keyword) =>
      // Fetch first batch of movies that match the keyword.
      unawaited(
        showResultsPage(
          SearchCriteriaDTO().init(
            SearchCriteriaType.moviesForKeyword,
            title: keyword,
          ),
        ),
      );

  /// Navigates to a search results page populated with keywords for the movie.
  ///
  void getMoreKeywords(MovieResultDTO movie) =>
      // Fetch first batch of movies that match the keyword.
      unawaited(
        showResultsPage(
          SearchCriteriaDTO().init(
            SearchCriteriaType.moreKeywords,
            title: movie.uniqueId,
            list: [movie],
          ),
        ),
      );

  /// Navigates to a search results page populated with downloads for the movie.
  ///
  void getDownloads(String text, MovieResultDTO dto) {
    // replace space with . for more matches
    final criteria = text.replaceAll(' ', '.');
    // Fetch first batch of movies that match the keyword.
    unawaited(
      showResultsPage(
        SearchCriteriaDTO().init(
          SearchCriteriaType.downloadSimple,
          title: criteria,
          list: [dto],
        ),
      ),
    );
  }

  /// Display more details for the selected card.
  ///
  void resultDrillDown(MovieResultDTO movie) {
    switch (movie.type) {
      case MovieContentType.keyword:
        // Search for movies that match the keyword.
        getMoviesForKeyword(movie.title);

      case MovieContentType.barcode:
        // Search for movies based on the data fetched for the barcode.
        unawaited(
          showResultsPage(
            SearchCriteriaDTO().init(
              SearchCriteriaType.movieTitle,
              title: getSearchTitle(movie),
            ),
          ),
        );

      case MovieContentType.navigation:
        if (movie.uniqueId.startsWith(webAddressPrefix)) {
          // Search for more movies that match the keyword.
          unawaited(
            showResultsPage(
              QueryIMDBMoviesForKeyword.convertMovieDtoToCriteriaDto(movie),
            ),
          );
        } else {
          // replace space with . for more specific searching
          final criteria = movie.uniqueId;
          // Fetch first batch of movies that match the keyword.
          unawaited(
            showResultsPage(
              SearchCriteriaDTO().init(
                SearchCriteriaType.downloadAdvanced,
                title: criteria,
                list: [movie],
              ),
            ),
          );
        }

      case MovieContentType.download:
        // Open magnet link.
        canvas.viewWebPage(movie.imageUrl);

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
        unawaited(
          canvas
              .viewFlutterPage(getDetailsPage(movie))
              .then((_) => movie.setReadIndicator(ReadHistory.read.toString())),
        );
    }
  }

  static String getRestorationId(GoRouterState state) {
    final criteria = state.extra;
    String? id;
    if (criteria != null && criteria is SearchCriteriaDTO) {
      id = criteria.toUniqueReference();
    }
    return '_${state.fullPath}_${id ?? criteria}';
  }

  /// Defines known routes handled by MMSNav.
  ///
  static List<RouteBase> getRoutes() => [
        GoRoute(path: '/', pageBuilder: MovieSearchCriteriaPage.goRoute),
        GoRoute(
          name: routeSearchCriteria,
          path: '/$routeSearchCriteria',
          pageBuilder: MovieSearchCriteriaPage.goRoute,
        ),
        GoRoute(
          name: routeSearchResults,
          path: '/$routeSearchResults',
          pageBuilder: MovieSearchResultsNewPage.goRoute,
        ),
        GoRoute(
          name: routePersonDetails,
          path: '/$routePersonDetails',
          pageBuilder: PersonDetailsPage.goRoute,
        ),
        GoRoute(
          name: routeMovieDetails,
          path: '/$routeMovieDetails',
          pageBuilder: MovieDetailsPage.goRoute,
        ),
        GoRoute(
          name: routeErrorDetails,
          path: '/$routeErrorDetails',
          pageBuilder: (context, state) => MaterialPage(
            restorationId: state.fullPath,
            child: ErrorDetailsPage(
              errorDto: state.extra as MovieResultDTO? ?? MovieResultDTO(),
              restorationId: getRestorationId(state),
            ),
          ),
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
  void viewWebPage(String url) {
    if (null != context) {
      if (Platform.isAndroid && url.startsWith('http')) {
        _invokeChromeCustomTabs(url);
      } else {
        _openBrowser(url);
      }
    }
  }

  /// Construct route to Material user interface page
  /// as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  Future<Object?> viewFlutterPage(RouteInfo page) {
    if (null != context) {
      NavLog(context!).logPageOpen(page.routePath, page.reference);
      try {
        return context!.pushNamed(page.routePath, extra: page.params)
          ..then((val) {
            NavLog(context!)
                .logPageClose(page.routePath, page.reference, page.params);
          });
      } catch (e) {
        logger.t(e);
      }
    }
    return Future.value(null);
  }

  void _invokeChromeCustomTabs(String url) => unawaited(
        tabs
            .launch(
              url,
              customTabsOption: tabs.CustomTabsOption(
                toolbarColor: Theme.of(context!).primaryColor,
                enableDefaultShare: true,
                enableUrlBarHiding: true,
                showPageTitle: true,
              ),
            )
            .onError((error, stackTrace) => _customTabsError(error, url)),
      );

  void _customTabsError(Object? e, String url) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    unawaited(
      showPopup(
        context!,
        'Received error $e\nwhen opening $url',
        'Navigation error',
      ),
    );
  }

  void _openBrowser(String url) => unawaited(
        launcher.launchUrl(Uri.parse(url)).then(
              (success) => _browserError(success, url),
            ),
      );

  void _browserError(bool success, String url) {
    // An exception is thrown if browser app is not installed on Android device.
    if (!success) {
      unawaited(showPopup(context!, url, 'Browser error'));
    }
  }
}
