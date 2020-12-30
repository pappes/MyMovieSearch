import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestions.dart';

class MovieSearchResultsPage extends StatefulWidget {
  MovieSearchResultsPage({Key key, SearchCriteriaDTO criteria})
      : super(key: key) {
    _criteria = criteria;
  }

  final String title = "Movie Search Results";
  var _criteria = new SearchCriteriaDTO();

  @override
  _MovieSearchResultsPageState createState() =>
      _MovieSearchResultsPageState(criteria: _criteria);
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsPage> {
  _MovieSearchResultsPageState({SearchCriteriaDTO criteria}) {
    //_fetchedResults = QueryIMDBSuggestions.executeQuery(criteria);
    _criteria = criteria;
  }
  int _scrolledToPosition = 0;
  var _criteria = new SearchCriteriaDTO();
  var _fetchedResults = <MovieResultDTO>[];
  StreamController<MovieSuggestionConverter> resultsStreamController;

  void _reloadResults() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.

      //scroll page down to _scrolledToPosition
    });
  }

  @override
  void dispose() {
    super.dispose();
    resultsStreamController?.close();
    resultsStreamController = null;
  }

  @override
  void InitState() {
    super.initState();
    resultsStreamController = StreamController.broadcast();

    resultsStreamController.stream.listen(
        /*lambda*/ (searchResult) => setState(
                /*lambda*/ () {
              Map x = json.decode(searchResult.resultCollection);
              MovieResultDTO y = MovieResultConverter.fromJsonMap(x);
              _fetchedResults.add(y);
            }));

    QueryIMDBSuggestions.executeQuery(resultsStreamController, _criteria);
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
