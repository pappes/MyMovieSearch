import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/widgets/movie_card_small.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';

class MovieSearchResultsNewPage extends StatefulWidget {
  MovieSearchResultsNewPage({Key? key, required SearchCriteriaDTO criteria})
      : _criteria = criteria,
        super(key: key);
  final _criteria;

  @override
  _MovieSearchResultsPageState createState() => _MovieSearchResultsPageState();
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsNewPage> {
  _MovieSearchResultsPageState();

  SearchBloc? _searchBloc;
  final _title = "Movie Search Results";

  @override
  void initState() {
    super.initState();
    _searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchBloc!.add(SearchRequested(widget._criteria));
  }

  /*void addDto(MovieResultDTO searchResult) {
    if (searchResult.uniqueId == '-1' ||
        !_fetchedResultsMap.containsKey(searchResult.uniqueId)) {
      _fetchedResultsMap[searchResult.uniqueId] = searchResult;
      _sortedResults
        ..clear()
        ..addAll(_fetchedResultsMap.values);
      // Sort by relevence with recent year first
      _sortedResults.sort((a, b) => b.compareTo(a));
    }
  }*/

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
        appBar: AppBar(
          // Use the search criteria to set our appbar title.
          title: Text('$_title - ${widget._criteria.criteriaTitle}'),
        ),
        body: Center(
          child: _buildMovieResults(),
        ));
  }

  Widget _buildMovieResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state.status == SearchStatus.awaitingInput) {
          //TODO move this to the block code.
          MovieResultDTO requestMore = MovieResultDTO();
          requestMore.title = "Click to load more!";
          //_fetchedResultsMap.clear();
          //_fetchedResultsMap[requestMore.uniqueId] = requestMore;
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: _searchBloc!.sortedResults.length,
          itemBuilder: _movieListBuilder,
        );
      },
    );
  }

  Widget _movieListBuilder(context, listIndex) {
    if (listIndex >= _searchBloc!.sortedResults.length) {
      return ListTile(
          title: Text("More widgets than available data to populate them!"));
    }
    return MovieTile(context, _searchBloc!.sortedResults[listIndex]);
  }
}
