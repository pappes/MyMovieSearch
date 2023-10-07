import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:go_router/go_router.dart';
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
import 'package:url_launcher/url_launcher.dart' as launcher;

const webAddressPrefix = 'http';

const routeHome = '';
const routeSearchCriteria = 'search';
const routeSearchResults = 'searchresults';
const routePersonDetails = 'persondetails';
const routeMovieDetails = 'moviedetails';
const routeErrorDetails = 'errordetails';

class RouteInfo {
  final String routePath;
  final Object params;

  RouteInfo(this.routePath, this.params);
}

/// Performs page navigation
///
/// Headless testing can have a null context (no page navigation)
/// or an alternate canvas implementation using the _headless constructor.
class MMSNav {
  late MMSFlutterCanvas canvas;

  MMSNav([BuildContext? context]) {
    canvas = MMSFlutterCanvas(context);
  }

  MMSNav.headless(this.canvas);

  /// Render web page [url] in a child page of the current screen.
  ///
  /// For platforms that don't support CustomTabs, the URL is displayed to the user.
  void viewWebPage(String url) {
    canvas.viewWebPage(url);
  }

  /// Construct route to Material user interface page as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  RouteInfo getDetailsPage(
    MovieResultDTO movie,
  ) {
    if (movie.uniqueId.startsWith(imdbPersonPrefix) ||
        movie.type == MovieContentType.person) {
      // Open person details.
      return RouteInfo(routePersonDetails, movie);
    } else if (movie.uniqueId.startsWith(imdbTitlePrefix) ||
        movie.type == MovieContentType.movie ||
        movie.type == MovieContentType.series ||
        movie.type == MovieContentType.miniseries ||
        movie.type == MovieContentType.short ||
        movie.type == MovieContentType.series ||
        movie.type == MovieContentType.episode ||
        movie.type == MovieContentType.title) {
      // Open Movie details.
      return RouteInfo(routeMovieDetails, movie);
    } else {
      // Open error details.
      return RouteInfo(routeErrorDetails, movie);
    }
  }

  /// Navigates to a search results page populated with a movie list.
  ///
  void showResultsPage(SearchCriteriaDTO criteria) =>
      canvas.viewFlutterPage(RouteInfo(routeSearchResults, criteria));

  /// Navigates to a search results page populated with a predefined list of dtos.
  ///
  void searchForRelated(String description, List<MovieResultDTO> movies) {
    if (movies.length == 1) {
      // Only one result so open details screen.
      canvas.viewFlutterPage(getDetailsPage(movies[0]));
    } else {
      // Multiple results so show them as individual cards.
      showResultsPage(
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
  void getMoviesForKeyword(String keyword) {
    // Fetch first batch of movies that match the keyword.
    showResultsPage(
      SearchCriteriaDTO().init(
        SearchCriteriaType.moviesForKeyword,
        title: keyword,
      ),
    );
  }

  /// Navigates to a search results page populated with keywords for the movie.
  ///
  void getMoreKeywords(MovieResultDTO movie) {
    // Fetch first batch of movies that match the keyword.
    showResultsPage(
      SearchCriteriaDTO().init(
        SearchCriteriaType.moreKeywords,
        title: movie.uniqueId,
        list: [movie],
      ),
    );
  }

  /// Navigates to a search results page populated with downloads for the movie.
  ///
  void getDownloads(String text, MovieResultDTO dto) {
    // replace space with . for more matches
    final criteria = text.replaceAll(' ', '.');
    // Fetch first batch of movies that match the keyword.
    showResultsPage(
      SearchCriteriaDTO().init(
        SearchCriteriaType.downloadSimple,
        title: criteria,
        list: [dto],
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
        showResultsPage(
          SearchCriteriaDTO().init(
            SearchCriteriaType.movieTitle,
            title: getSearchTitle(movie),
          ),
        );

      case MovieContentType.navigation:
        if (movie.uniqueId.startsWith(webAddressPrefix)) {
          // Search for more movies that match the keyword.
          showResultsPage(
            QueryIMDBMoviesForKeyword.convertMovieDtoToCriteriaDto(movie),
          );
        } else {
          // replace space with . for more specific searching
          final criteria = movie.uniqueId;
          // Fetch first batch of movies that match the keyword.
          showResultsPage(
            SearchCriteriaDTO().init(
              SearchCriteriaType.downloadAdvanced,
              title: criteria,
              list: [movie],
            ),
          );
        }

      case MovieContentType.download:
        // Open magnet link.
        canvas.viewWebPage(movie.imageUrl);

      default:
        // Show details screen (movie details or person details)
        canvas.viewFlutterPage(getDetailsPage(movie));
    }
  }

  /// Defines known routes handled by MMSNav.
  ///
  List<RouteBase> getRoutes() => [
        GoRoute(
          path: '/',
          builder: (context, state) => const MovieSearchCriteriaPage(),
        ),
        GoRoute(
          name: routeSearchCriteria,
          path: '/$routeSearchCriteria',
          builder: (context, state) => const MovieSearchCriteriaPage(),
        ),
        GoRoute(
          name: routeSearchResults,
          path: '/$routeSearchResults',
          builder: (context, state) => MovieSearchResultsNewPage(
            criteria: state.extra! as SearchCriteriaDTO,
          ),
        ),
        GoRoute(
          name: routePersonDetails,
          path: '/$routePersonDetails',
          builder: (context, state) => PersonDetailsPage(
            person: state.extra! as MovieResultDTO,
          ),
        ),
        GoRoute(
          name: routeMovieDetails,
          path: '/$routeMovieDetails',
          builder: (context, state) => MovieDetailsPage(
            movie: state.extra! as MovieResultDTO,
          ),
        ),
        GoRoute(
          name: routeErrorDetails,
          path: '/$routeErrorDetails',
          builder: (context, state) => ErrorDetailsPage(
            errorDto: state.extra! as MovieResultDTO,
          ),
        ),
      ];
  /*
    GoRoute(
      path: 'sign-in',
      builder: (context, state) {
        return SignInScreen(
          actions: [
            ForgotPasswordAction((context, email) {
              final uri = Uri(
                path: '/sign-in/forgot-password',
                queryParameters: <String, String?>{
                  'email': email,
                },
              );
              context.push(uri.toString());
            }),
            AuthStateChangeAction((context, state) {
              final user = switch (state) {
                final SignedIn state => state.user,
                final UserCreated state => state.credential.user,
                _ => null
              };
              if (user == null) {
                return;
              }
              if (state is UserCreated) {
                user.updateDisplayName(user.email!.split('@')[0]);
              }
              if (!user.emailVerified) {
                user.sendEmailVerification();
                const snackBar = SnackBar(
                    content: Text(
                        'Please check your email to verify your email address'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              context.pushReplacement('/');
            }),
          ],
        );
      },
      routes: [
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) {
            final arguments = state.uri.queryParameters;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: 'profile',
      builder: (context, state) {
        return ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.pushReplacement('/');
            }),
          ],
        );
      },
    ),*/
}

class MMSFlutterCanvas {
  BuildContext? context;
  MMSFlutterCanvas(this.context);

  /// Render web page [url] in a child page of the current screen.
  ///
  /// For platforms that don't support CustomTabs, the URL is displayed to the user.
  void viewWebPage(String url) {
    if (null != context) {
      if (Platform.isAndroid) {
        _invokeChromeCustomTabs(url);
      } else {
        _openBrowser(url);
      }
    }
  }

  /// Construct route to Material user interface page as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  void viewFlutterPage(RouteInfo page) {
    if (null != context) {
      context!.pushNamed(page.routePath, extra: page.params);
    }
  }

  void _invokeChromeCustomTabs(String url) {
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
        .onError((error, stackTrace) => _customTabsError(error, url));
  }

  void _customTabsError(Object? e, String url) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    showPopup(context!, url);
  }

  void _openBrowser(String url) {
    launcher.launchUrl(Uri.parse(url)).then(
          (bool success) => _browserError(success, url),
        );
  }

  void _browserError(bool success, String url) {
    // An exception is thrown if browser app is not installed on Android device.
    if (!success) {
      showPopup(context!, url);
    }
  }
}
