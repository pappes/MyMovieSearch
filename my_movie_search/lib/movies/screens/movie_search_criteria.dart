import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';
import 'package:my_movie_search/movies/screens/styles.dart';

import 'movie_search_results.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({Key? key}) : super(key: key);

  final String title = "Movie Search Criteria";

  @override
  _MovieSearchCriteriaPageState createState() =>
      _MovieSearchCriteriaPageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MovieSearchCriteriaPage());
  }
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage> {
  final criteria = SearchCriteriaDTO();
  void searchForMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsNewPage(criteria: criteria)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
      appBar: AppBar(
        // Get title from the StatefulWidget MovieSearchCriteriaPage.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _CriteriaInput(this),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchForMovie,
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),
    );
  }
}

class _CriteriaInput extends Center {
  _CriteriaInput(_MovieSearchCriteriaPageState state)
      : super(
          child: TextField(
            textInputAction: TextInputAction.search,
            autofocus: true,
            autocorrect: true,
            autofillHints: [AutofillHints.sublocality],
            style: hugeFont,
            decoration: InputDecoration(
              labelText: "Movie",
              hintText: "Enter movie or tv series to search for",
            ),
            onChanged: (text) {
              state.criteria.criteriaTitle = text;
            },
            onSubmitted: (text) {
              state.criteria.criteriaTitle = text;
              state.searchForMovie();
            },
          ),
        );
}
