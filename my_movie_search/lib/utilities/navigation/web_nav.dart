import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/movie_details.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/person_details.dart';
import 'package:my_movie_search/movies/screens/popup.dart';

void _launchURL(String url, BuildContext context) async {
  try {
    await launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

void viewWebPage(String url, BuildContext context) {
  if (Platform.isAndroid) {
    _launchURL(
      url,
      context,
    );
  } else {
    showPopup(context, url);
  }
}

MaterialPageRoute<dynamic> getRoute(
  BuildContext context,
  MovieResultDTO movie,
) {
  if (movie.uniqueId.startsWith('nm')) {
    return MaterialPageRoute(
        builder: (context) => PersonDetailsPage(person: movie));
  } else {
    return MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie));
  }
}

void searchForRelated(
  String description,
  List<MovieResultDTO> movies,
  BuildContext context,
) {
  if (movies.length == 1) {
    Navigator.push(context, getRoute(context, movies[0]));
  } else {
    var criteria = SearchCriteriaDTO();
    criteria.criteriaList.addAll(movies);
    criteria.criteriaTitle = description;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsNewPage(criteria: criteria)),
    );
  }
}
