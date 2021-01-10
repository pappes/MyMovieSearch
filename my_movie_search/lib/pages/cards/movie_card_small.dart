import 'package:flutter/material.dart';

import 'package:my_movie_search/data_model/movie_result_dto.dart';
import 'package:my_movie_search/data_model/metadata_dto.dart';

typedef MovieResultDTO MovieFetcher(String id);

Map<String, MovieResultDTO> buffer;

class MovieCard extends StatefulWidget {
  MovieCard({Key key, this.uniqueId}) : super(key: key);

  final String uniqueId;

  MovieResultDTO getMovieData(String key) => buffer[key];

  @override
  _MovieCardState createState() => _MovieCardState(uniqueId, getMovieData);
}

class _MovieCardState extends State<MovieCard> {
  _MovieCardState(this.uniqueId, this.source);
  MovieFetcher source;
  String uniqueId;
  var _metadata = MetaDataDTO();

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return _MovieTileWidgetBuilder.buildCard(source(uniqueId));
  }
}

class _MovieTileWidgetBuilder {
  _MovieTileWidgetBuilder();

  static final _biggerFont = TextStyle(fontSize: 18.0);
  static Widget buildCard(MovieResultDTO movie) {
    return ListTile(
      title: Text(
        movie.title,
        style: _biggerFont,
        textScaleFactor: 1.0,
      ),
    );
  }
}
