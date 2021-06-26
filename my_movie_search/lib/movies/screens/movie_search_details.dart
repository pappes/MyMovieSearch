import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        AppBar,
        BuildContext,
        Center,
        Column,
        Container,
        CrossAxisAlignment,
        Expanded,
        Image,
        Key,
        ListView,
        MainAxisAlignment,
        NetworkImage,
        Row,
        Scaffold,
        Scrollbar,
        SelectableText,
        State,
        StatefulWidget,
        Text,
        Widget,
        Wrap;

import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
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
      body: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          children: <Widget>[
            Container(
              height:
                  900, //TODO: work out how to cet the container to have variable heigh in a list view
              child: Center(child: bodySection()),
            )
          ],
        ),
      ),
    );
  }

  Column bodySection() {
    return Column(
      children: [
        SelectableText(_movie.title, style: hugeFont),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _movie.year == ''
                ? Text('Year Range: ${_movie.yearRange}')
                : Text('Year: ${_movie.year.toString()}'),
            Align(
                alignment: Alignment.centerRight,
                child: Text('Run Time: ${_movie.runTime.toFormattedTime()}')),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftColumn(),
              rightColumn(),
            ],
          ),
        ),
      ],
    );
  }

  Expanded rightColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getBigImage(_movie.imageUrl).startsWith('http')
              ? Image(
                  image: NetworkImage(getBigImage(_movie.imageUrl)),
                  alignment: Alignment.topCenter,
                )
              : Text('NoImage'),
          SelectableText(getBigImage(_movie.imageUrl), style: tinyFont),
        ],
      ),
    );
  }

  Expanded leftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${describeEnum(_movie.type)}'),
          Text('User Rating: ${_movie.userRating.toString()} '
              '(${formatter.format(_movie.userRatingCount)})'),
          Text('Censor Rating: ${describeEnum(_movie.censorRating)}'),
          Wrap(children: [
            Text('Source: ${describeEnum(_movie.source)} '),
            Text('UniqueId: ${_movie.uniqueId}'),
          ]),
          Row(children: [
            Expanded(
              child: Text(
                '\nDescription: \n${_movie.description} ',
                style: biggerFont,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
