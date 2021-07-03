import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';

import 'movie_search_results.dart';

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
  void searchForRelated(MovieResultDTO movie) {
    var criteria = SearchCriteriaDTO();
    criteria.criteriaList = movie.related;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsNewPage(criteria: criteria)),
    );
  }

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
                  9000, //TODO: work out how to set the container to have variable height in a list view
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
          _movie.imageUrl.startsWith('http')
              ? Image(
                  image: NetworkImage(_movie.imageUrl),
                  alignment: Alignment.topCenter,
                )
              : Text('NoImage'),
          SelectableText(_movie.imageUrl, style: tinyFont),
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
          Wrap(children: [
            Text('Censor Rating: ${describeEnum(_movie.censorRating)}     '),
            Text('Language: ${describeEnum(_movie.language)}'),
          ]),
          Wrap(children: [
            Text('Source: ${describeEnum(_movie.source)}      '),
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
          Text('Related:'),
          GestureDetector(
            onTap: () => searchForRelated(_movie),
            child: Text(
              _movie.related.toShortString(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
