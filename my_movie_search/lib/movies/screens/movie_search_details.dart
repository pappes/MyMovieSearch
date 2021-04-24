import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

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

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    final _biggerFont = TextStyle(fontSize: 18.0);
    final formatter = NumberFormat('#,###,###,###,##0');

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget._movie.title),
      ),
      body: Column(
        children: [
          SelectableText(_movie.title, style: _biggerFont),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _movie.yearRange == ''
                ? Text('Year: ${_movie.year.toString()}')
                : Text('Year Range: ${_movie.yearRange}'),
            Align(
                alignment: Alignment.centerRight,
                child: Text('Run Time: ${_printDuration(_movie.runTime)}')),
          ]),
          Expanded(
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Type: ${describeEnum(_movie.type)}'),
                    Text(
                        'User Rating: ${_movie.userRating.toString()} (${formatter.format(_movie.userRatingCount)})'),
                    Text('Censor Rating: ${describeEnum(_movie.censorRating)}'),
                    Row(children: [
                      Text('Source: ${describeEnum(_movie.source)} '),
                      Text('UniqueId: ${_movie.uniqueId}'),
                    ]),
                  ],
                ),
                _movie.imageUrl == ''
                    ? Text('NoImage')
                    : Expanded(
                        child: Image(
                            image: NetworkImage(_movie.imageUrl),
                            alignment: Alignment.centerRight),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
