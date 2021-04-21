import 'package:flutter/material.dart';

import 'dart:async';

import 'package:my_movie_search/data_model/search_criteria_dto.dart';
import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/search_providers/search_google_movies.dart';
import 'package:my_movie_search/search_providers/search_imdb_suggestions.dart';
import 'package:my_movie_search/search_providers/search_omdb_movies.dart';
import 'package:my_movie_search/search_providers/search_tmdb_movies.dart';

class MovieSearchResultsPage extends StatefulWidget {
  MovieSearchResultsPage({Key? key, required SearchCriteriaDTO criteria})
      : _criteria = criteria,
        super(key: key);

  final title = "Movie Search Results";
  final _criteria;

  @override
  _MovieSearchResultsPageState createState() =>
      _MovieSearchResultsPageState(_criteria);
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsPage> {
  _MovieSearchResultsPageState(this._criteria) {
    MovieResultDTO requestMore = MovieResultDTO();
    requestMore.title = "Click to load more!";
    _fetchedResultsMap[requestMore.uniqueId] = requestMore;
  }
  final SearchCriteriaDTO _criteria;
  var _sortedResults = <MovieResultDTO>[];
  Map<String, MovieResultDTO> _fetchedResultsMap = {};
  StreamController<MovieResultDTO>? omdbStreamController;
  StreamController<MovieResultDTO>? tmdbStreamController;
  StreamController<MovieResultDTO>? imdbStreamController;
  StreamController<MovieResultDTO>? googleStreamController;

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
    omdbStreamController?.close();
    tmdbStreamController?.close();
    imdbStreamController?.close();
    googleStreamController?.close();
    omdbStreamController = null;
    tmdbStreamController = null;
    imdbStreamController = null;
    googleStreamController = null;
  }

  @override
  void initState() {
    super.initState();

    imdbStreamController = StreamController.broadcast();
    imdbStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryIMDBSuggestions().executeQuery(imdbStreamController!, _criteria);

    omdbStreamController = StreamController.broadcast();
    omdbStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryOMDBMovies().executeQuery(omdbStreamController!, _criteria);

    tmdbStreamController = StreamController.broadcast();
    tmdbStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryTMDBMovies().executeQuery(tmdbStreamController!, _criteria);

    googleStreamController = StreamController.broadcast();
    googleStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryGoogleMovies().executeQuery(googleStreamController!, _criteria);
  }

  void addDto(MovieResultDTO searchResult) {
    if (!_fetchedResultsMap.containsKey(searchResult.uniqueId)) {
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
    return _MovieTileBuilder._buildRow(fetchedResult);
  }
}

class _MovieTileBuilder {
  static final _biggerFont = TextStyle(fontSize: 18.0);
  static Widget _buildRow(MovieResultDTO movie) {
    return ListTile(
      title: Text(
        "${movie.title}(${movie.year}, ${movie.source.toString()})",
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
