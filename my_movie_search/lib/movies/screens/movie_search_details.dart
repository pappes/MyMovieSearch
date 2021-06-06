import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart'
    show
        Widget,
        StatefulWidget,
        State,
        Key,
        BuildContext,
        Scaffold,
        AppBar,
        Text,
        SelectableText,
        Column,
        Row,
        Alignment,
        Align,
        Expanded,
        Image,
        NetworkImage,
        MainAxisAlignment,
        CrossAxisAlignment;

import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';

class MovieDetailsPage extends StatefulWidget {
  MovieDetailsPage({Key? key, required MovieResultDTO movie})
      : _movie = movie,
        super(key: key);

  final _movie;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState(_movie);
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  _MovieDetailsPageState(this._movie);
  final MovieResultDTO _movie;

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.

    return Scaffold(
      appBar: AppBar(
        // Get title from the StatefulWidget MovieDetailsPage.
        title: Text(widget._movie.title),
      ),
      body: Column(
        children: [
          SelectableText(_movie.title, style: biggerFont),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _movie.yearRange == ''
                  ? Text('Year: ${_movie.year.toString()}')
                  : Text('Year Range: ${_movie.yearRange}'),
              Align(
                  alignment: Alignment.centerRight,
                  child: Text('Run Time: ${_movie.runTime.toFormattedTime()}')),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${describeEnum(_movie.type)}'),
                    Text('User Rating: ${_movie.userRating.toString()} '
                        '(${formatter.format(_movie.userRatingCount)})'),
                    Text('Censor Rating: ${describeEnum(_movie.censorRating)}'),
                    Row(children: [
                      Text('Source: ${describeEnum(_movie.source)} '),
                      Text('UniqueId: ${_movie.uniqueId}'),
                    ]),
                    Row(children: [
                      Text('Description: ${_movie.description} '),
                    ]),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _movie.imageUrl == '' || !_movie.imageUrl.startsWith('http')
                        ? Text('NoImage')
                        : Expanded(
                            child: Image(
                                image: NetworkImage(_movie.imageUrl),
                                alignment: Alignment.centerRight),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}