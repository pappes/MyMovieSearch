import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/error_details.dart';
import 'package:my_movie_search/movies/screens/movie_details.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/person_details.dart';
import 'package:my_movie_search/movies/screens/popup.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class MMSNav {
  final BuildContext context;
  MMSNav(this.context);

  void _invokeChromeCustomTabs(String url) {
    tabs
        .launch(
          url,
          customTabsOption: tabs.CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
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
    showPopup(context, url);
  }

  void _openBrowser(String url) {
    launcher.launchUrl(Uri.parse(url)).then(
          (bool success) => _browserError(success, url),
        );
  }

  void _browserError(bool success, String url) {
    // An exception is thrown if browser app is not installed on Android device.
    if (!success) {
      showPopup(context, url);
    }
  }

  /// Render web page [url] in a child page of the current screen.
  ///
  /// For platforms that don't support CustomTabs, the URL is displayed to the user.
  void viewWebPage(String url) {
    if (Platform.isAndroid) {
      _invokeChromeCustomTabs(url);
    } else {
      _openBrowser(url);
    }
  }

  /// Construct route to Material user interface page as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  void showDetailsPage(
    MovieResultDTO movie,
  ) {
    if (movie.uniqueId.startsWith(imdbPersonPrefix)) {
      // Open person details.

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonDetailsPage(person: movie),
        ),
      );
    } else if (movie.uniqueId.startsWith(imdbTitlePrefix) ||
        movie.type == MovieContentType.movie ||
        movie.type == MovieContentType.series ||
        movie.type == MovieContentType.miniseries ||
        movie.type == MovieContentType.short ||
        movie.type == MovieContentType.episode ||
        movie.type == MovieContentType.title) {
      // Open Movie details.

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieDetailsPage(movie: movie),
        ),
      );
    } else {
      // Open error details.

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ErrorDetailsPage(errorDto: movie),
        ),
      );
    }
  }

  /// Navigates to a search results page populated with a movie list.
  ///
  void showResultsPage(SearchCriteriaDTO criteria) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieSearchResultsNewPage(criteria: criteria),
      ),
    );
  }

  /// Navigates to a search results page populated with a predefined list of dtos.
  ///
  void searchForRelated(String description, List<MovieResultDTO> movies) {
    if (movies.length == 1) {
      // Only one result so open details screen.
      showDetailsPage(movies[0]);
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

        break;
      case MovieContentType.navigation:
        if (movie.uniqueId.startsWith('http')) {
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

        break;
      case MovieContentType.download:
        // Open magnet link.
        _openBrowser(movie.imageUrl);

        break;
      default:
        // Show details screen (movie details or person details)
        showDetailsPage(movie);
    }
  }
}
