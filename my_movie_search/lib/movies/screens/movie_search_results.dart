import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/providers/search/google.dart';
import 'package:my_movie_search/movies/providers/search/imdb_suggestions.dart';
import 'package:my_movie_search/movies/providers/search/omdb.dart';
import 'package:my_movie_search/movies/providers/search/tmdb.dart';

import 'movie_search_details.dart';

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
    QueryIMDBSuggestions().populate(imdbStreamController!, _criteria);

    omdbStreamController = StreamController.broadcast();
    omdbStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryOMDBMovies().populate(omdbStreamController!, _criteria);

    tmdbStreamController = StreamController.broadcast();
    tmdbStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryTMDBMovies().populate(tmdbStreamController!, _criteria);

    googleStreamController = StreamController.broadcast();
    googleStreamController!.stream.listen(// Lambda 1
        (searchResult) => setState(// Lambda2
            () => addDto(searchResult)));
    QueryGoogleMovies().populate(googleStreamController!, _criteria);
  }

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
    return _MovieTileBuilder._buildRow(context, fetchedResult);
  }
}

class _MovieTileBuilder {
  static String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static final _biggerFont = TextStyle(fontSize: 18.0);
  static Widget _buildRow(BuildContext context, MovieResultDTO movie) {
    return ListTile(
      leading: movie.imageUrl == ''
          ? CircularProgressIndicator()
          : Image(
              image: NetworkImage(movie.imageUrl),
            ),
      title: SelectableText(
        "${movie.title}(${movie.yearRange == '' ? movie.year : movie.yearRange}, ${describeEnum(movie.source)})",
        style: _biggerFont,
        textScaleFactor: 1.0,
      ),
      subtitle: Text(
        " ${describeEnum(movie.type)}   ${_printDuration(movie.runTime)} - ${movie.userRating} (${movie.userRatingCount})",
        style: _biggerFont,
        textScaleFactor: 1.0,
      ),
      onTap: () {
        if (movie.uniqueId != '-1') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailsPage(movie: movie)),
          );
        }
      },
    );
  }
}
