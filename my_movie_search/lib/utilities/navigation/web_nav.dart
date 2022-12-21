import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/movie_details.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/person_details.dart';
import 'package:my_movie_search/movies/screens/popup.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

Future<void> _invokeChromeCustomeTabs(String url, BuildContext context) async {
  try {
    await tabs.launch(
      url,
      customTabsOption: tabs.CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
    showPopup(context, url);
  }
}

Future<void> _openBrowser(String url, BuildContext context) async {
  if (!await launcher.launch(url)) {
    showPopup(context, url);
  }
}

/// Render web page [url] in a child page of the current screen.
///
/// For platforms that don't support CustomTabs, the URL is displayed to the user.
void viewWebPage(String url, BuildContext context) {
  if (Platform.isAndroid) {
    _invokeChromeCustomeTabs(url, context);
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
    return MaterialPageRoute(
      builder: (context) => PersonDetailsPage(person: movie),
    );
  } else {
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
    Navigator.push(context, getRoute(context, movies[0]));
  } else {
    final criteria = SearchCriteriaDTO();
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
