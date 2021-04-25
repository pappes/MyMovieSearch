import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/widgets/movie_card_small.dart';

class MovieSearchResultsNewPage extends StatefulWidget {
  MovieSearchResultsNewPage({Key? key, required SearchCriteriaDTO criteria})
      : _criteria = criteria,
        super(key: key);

  final title = "Movie Search Results";
  final _criteria;

  @override
  _MovieSearchResultsPageState createState() =>
      _MovieSearchResultsPageState(_criteria);
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsNewPage> {
  _MovieSearchResultsPageState(this._criteria) {
    MovieResultDTO requestMore = MovieResultDTO();
    requestMore.title = "Click to load more!";
    _fetchedResultsMap[requestMore.uniqueId] = requestMore;
  }
  final SearchCriteriaDTO _criteria;
  var _sortedResults = <MovieResultDTO>[];
  Map<String, MovieResultDTO> _fetchedResultsMap = {};

  void addDto(MovieResultDTO searchResult) {
    if (searchResult.uniqueId == '-1' ||
        !_fetchedResultsMap.containsKey(searchResult.uniqueId)) {
      _fetchedResultsMap[searchResult.uniqueId] = searchResult;
      _sortedResults = _fetchedResultsMap.values.toList();
      // Sort by relevence with recent year first
      _sortedResults.sort((a, b) => b.compareTo(a));
    }
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
        appBar: AppBar(
          // Use the search criteria to set our appbar title.
          title: Text('${widget.title} - ${widget._criteria.criteriaTitle}'),
        ),
        body: Center(
          child: _buildMovieResults(),
        ));
  }

  Widget _buildMovieResults() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: _sortedResults.length,
      itemBuilder: _movieListBuilder,
    );
  }

  Widget _movieListBuilder(context, listIndex) {
    if (listIndex >= _sortedResults.length) {
      return ListTile(
          title: Text("More widgets than available data to populate them!"));
    }
    MovieResultDTO fetchedResult = _sortedResults[listIndex];
    return MovieTile(context, fetchedResult);
  }
}
