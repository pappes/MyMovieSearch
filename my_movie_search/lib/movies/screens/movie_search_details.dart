import 'dart:io';

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/web_page.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

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
  MovieResultDTO _movie;
  void searchForRelated(MovieResultDTO movie) {
    var criteria = SearchCriteriaDTO();
    criteria.criteriaList = [];
    for (var key in movie.related.keys) {
      criteria.criteriaList.addAll(movie.related[key]!);
    }
    criteria.criteriaTitle = 'Related to: ${movie.title}';
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
        SelectableText(widget._movie.title, style: hugeFont),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget._movie.year == ''
                ? Text('Year Range: ${widget._movie.yearRange}')
                : Text('Year: ${widget._movie.year.toString()}'),
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
          widget._movie.imageUrl.startsWith('http')
              ? Image(
                  image: NetworkImage(getBigImage(widget._movie.imageUrl)),
                  alignment: Alignment.topCenter,
                )
              : Text('NoImage'),
          SelectableText(widget._movie.imageUrl, style: tinyFont),
        ],
      ),
    );
  }

  Expanded leftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${describeEnum(widget._movie.type)}'),
          Text('User Rating: ${widget._movie.userRating.toString()} '
              '(${formatter.format(widget._movie.userRatingCount)})'),
          Wrap(children: [
            Text(
                'Censor Rating: ${describeEnum(widget._movie.censorRating)}     '),
            Text('Language: ${describeEnum(widget._movie.language)}'),
          ]),
          Wrap(children: [
            Text('Source: ${describeEnum(widget._movie.source)}      '),
            Text('UniqueId: ${widget._movie.uniqueId}'),
            Link(
              uri: Uri.parse('https://flutter.dev'),
              builder: makeLink,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _viewImdbPage(widget._movie.uniqueId),
                child: Text('webview'),
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Text(
                '\nDescription: \n${widget._movie.description} ',
                style: biggerFont,
              ),
            ),
          ]),
          Center(
            child: GestureDetector(
              onTap: () => searchForRelated(_movie),
              child: Text(
                _movie.related.toShortString(),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget makeLink(BuildContext, FollowLink? followLink) {
    //return Text('hyperlink');

    return ElevatedButton(
      onPressed: followLink,
      child: Text('Hyperlink'),
    );

    /*
    return ElevatedButton(
      onPressed: followLink, child: Text('hyperlink'),
      // ... other properties here ...
    );*/
  }

  void _launchURL() async => await canLaunch('https://flutter.dev')
      ? await launch('https://flutter.dev')
      : throw 'Could not launch https://flutter.dev';

  void _viewImdbPage(String pageRef) {
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebPage(url: makeImdbUrl(pageRef))),
      );
    }
  }
}
