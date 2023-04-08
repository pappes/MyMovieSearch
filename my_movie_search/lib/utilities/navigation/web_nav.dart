import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/movie_details.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/person_details.dart';
import 'package:my_movie_search/movies/screens/popup.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

void _invokeChromeCustomTabs(String url, BuildContext context) {
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
      .onError((error, stackTrace) => _customTabsError(error, url, context));
}

void _customTabsError(
  Object? e,
  String url,
  BuildContext context,
) {
  // An exception is thrown if browser app is not installed on Android device.
  debugPrint(e.toString());
  showPopup(context, url);
}

void _openBrowser(String url, BuildContext context) {
  launcher.launchUrl(Uri.parse(url)).then(
        (bool success) => _browserError(success, url, context),
      );
}

void _browserError(
  bool success,
  String url,
  BuildContext context,
) {
  // An exception is thrown if browser app is not installed on Android device.
  if (!success) {
    showPopup(context, url);
  }
}

/// Render web page [url] in a child page of the current screen.
///
/// For platforms that don't support CustomTabs, the URL is displayed to the user.
void viewWebPage(String url, BuildContext context) {
  if (Platform.isAndroid) {
    _invokeChromeCustomTabs(url, context);
  } else {
    _openBrowser(url, context);
  }
}

/// Construct route to Material user interface page as appropriate for the dto.
///
/// Chooses a MovieDetailsPage or PersonDetailsPage based on the IMDB unique ID.
MaterialPageRoute<dynamic> getRoute(
  BuildContext context,
  MovieResultDTO movie,
) {
  if (movie.uniqueId.startsWith(imdbPersonPrefix)) {
    // Open person details.
    return MaterialPageRoute(
      builder: (context) => PersonDetailsPage(person: movie),
    );
  } else {
    // Open Movie details.
    return MaterialPageRoute(
      builder: (context) => MovieDetailsPage(movie: movie),
    );
  }
}

/// Navigates to a search results page populated with a predefined list of dtos.
///
void searchForRelated(
  String description,
  List<MovieResultDTO> movies,
  BuildContext context,
) {
  if (movies.length == 1) {
    // Only one result so open details screen.
    Navigator.push(context, getRoute(context, movies[0]));
  } else {
    // Multiple results so show them as individual cards.
    final criteria =
        SearchCriteriaDTO().init(SearchCriteriaSource.movieDTOList);
    criteria.criteriaList.addAll(movies);
    criteria.criteriaTitle = description;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieSearchResultsNewPage(criteria: criteria),
      ),
    );
  }
}

/// Navigates to a search results page populated with movie for the keyword.
///
void searchForKeyword(
  String keyword,
  BuildContext context,
) {
  // Fetch first batch of movies that match the keyword.
  final criteria =
      SearchCriteriaDTO().init(SearchCriteriaSource.moviesForKeyword);
  criteria.criteriaTitle = keyword;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieSearchResultsNewPage(criteria: criteria),
    ),
  );
}

/// Navigates to a search results page populated with keywords for the movie.
///
void getMoreKeywords(
  String uniqueId,
  BuildContext context,
) {
  // Fetch first batch of movies that match the keyword.
  final criteria = SearchCriteriaDTO().init(SearchCriteriaSource.moreKeywords);
  criteria.criteriaTitle = uniqueId;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MovieSearchResultsNewPage(criteria: criteria),
    ),
  );
}

/// Display more details for the selected card.
///
void resultDrillDown(
  MovieResultDTO movie,
  BuildContext context,
) {
  if (movie.sources.containsKey(DataSourceType.imdbKeywords) &&
      movie.uniqueId.startsWith('http')) {
    // Search for next batch of movies that match the keyword.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieSearchResultsNewPage(
          criteria:
              QueryIMDBMoviesForKeyword.convertMovieDtoToCriteriaDto(movie),
        ),
      ),
    );
  } else {
    // Show details screen (movie details or person details)
    Navigator.push(
      context,
      getRoute(context, movie),
    );
  }
}
