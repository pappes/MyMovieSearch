import 'package:flutter/material.dart';

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestions.dart';
import 'package:my_movie_search/search_providers/search_omdb_movies.dart';

class MovieSearchResultsPage extends StatefulWidget {
  MovieSearchResultsPage({Key key, SearchCriteriaDTO criteria})
      : _criteria = criteria,
        super(key: key);

  final title = "Movie Search Results";
  final _criteria;

  @override
  _MovieSearchResultsPageState createState() =>
      _MovieSearchResultsPageState(criteria: _criteria);
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsPage> {
  _MovieSearchResultsPageState({SearchCriteriaDTO criteria}) {
    //_fetchedResults = QueryIMDBSuggestions.executeQuery(criteria);
    _criteria = criteria;
  }
  var _criteria = SearchCriteriaDTO();
  var _fetchedResults = <MovieResultDTO>[];
  StreamController<MovieResultDTO> resultsStreamController;

  /* TODO: save and restore scroll position int _scrolledToPosition = 0;
  void _reloadResults() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.

      //scroll page down to _scrolledToPosition
    });
  }
  */

  @override
  void dispose() {
    super.dispose();
    resultsStreamController?.close();
    resultsStreamController = null;
  }

  @override
  void initState() {
    super.initState();
    resultsStreamController = StreamController.broadcast();

    resultsStreamController.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));

    //QueryIMDBSuggestions().executeQuery(resultsStreamController, _criteria);
    QueryOMDBMovies().executeQuery(resultsStreamController, _criteria);
  }

  void addDto(MovieResultDTO searchResult) {
    _fetchedResults.add(searchResult);
    _fetchedResults.sort((a, b) => a.title.compareTo(b.title));
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: _buildMovieResults(),
        )
        //ListView.builder(
        //itemBuilder: (BuildContext context, int index) => _buildMovieResults(),
        //body: _buildMovieResults(),
/*      body: _MovieSearchResultsBody(this),
      floatingActionButton: FloatingActionButton(
        onPressed: _reloadResults,
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),*/
        );
  }

  Widget _buildMovieResults() {
    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      //itemCount: _fetchedResults.length,
      itemBuilder: _movieListBuilder,
    );
  }

  Widget _movieListBuilder(context, listIndex) {
    if (listIndex >= _fetchedResults.length) {
      return null;
    }
    MovieResultDTO fetchedResult = _fetchedResults[listIndex];
    return _MovieTileBuilder._buildRow(fetchedResult);
  }
}

class _MovieTileBuilder {
  static final _biggerFont = TextStyle(fontSize: 18.0);
  static Widget _buildRow(MovieResultDTO movie) {
    return ListTile(
      title: Text(
        movie.title,
        style: _biggerFont,
        textScaleFactor: 1.0,
      ),
      /*trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),*/
      /*onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(resultData);
          } else {
            _saved.add(resultData);
          }
        });
      },*/
    );
  }
}
