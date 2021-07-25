import 'dart:io';

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';

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

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with RestorationMixin {
  var _movie = MovieResultDTO();
  var _restorableMovie = RestorableMovie();

  _MovieDetailsPageState(MovieResultDTO movie) {
    this._movie = movie;
    var detailCriteria = SearchCriteriaDTO();
    detailCriteria.criteriaTitle = _movie.uniqueId;
    // Pull back details at this point because it is very slow and CPU intensive
    final imdbDetails = QueryIMDBCastDetails();
    imdbDetails.readList(detailCriteria).then((searchResults) {
      // Call setSetState to update page when data is ready.
      setState(() => mergeDetails(searchResults));
    });
  }

  mergeDetails(List<MovieResultDTO> details) {
    details.forEach((dto) => _movie.merge(dto));
  }

  void searchForRelated(String description, List<MovieResultDTO> movies) {
    var criteria = SearchCriteriaDTO();
    criteria.criteriaList.addAll(movies);
    criteria.criteriaTitle = description;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsNewPage(criteria: criteria)),
    );
  }

  @override
  // The restoration bucket id for this page.
  String get restorationId => runtimeType.toString() + _movie.uniqueId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, _movie.uniqueId);
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorableMovie.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    _restorableMovie.value = _movie;
    return Scaffold(
      appBar: AppBar(
        title: Text(_movie.title),
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
            _movie.yearRange != ''
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
                  image: NetworkImage(getBigImage(_movie.imageUrl)),
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
            new GestureDetector(
              onTap: () => _viewWebPage(
                makeImdbUrl(
                  _movie.uniqueId,
                  path: '/parentalguide',
                  mobile: true,
                ),
              ),
              child: Text(
                  'Censor Rating: ${describeEnum(_movie.censorRating)}     '),
            ),
            Text('Language: ${describeEnum(_movie.language)}'),
          ]),
          Wrap(children: [
            Text('Source: ${describeEnum(_movie.source)}      '),
            Text('UniqueId: ${_movie.uniqueId}'),
            ElevatedButton(
              onPressed: () =>
                  _viewWebPage('https://tpb.party/search/${_movie.title}'),
              child: Text('External'),
            ),
            ElevatedButton(
              onPressed: () => _viewWebPage(
                makeImdbUrl(
                  _movie.uniqueId,
                  mobile: true,
                ),
              ),
              child: Text('IMDB'),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Text(
                '\nDescription: \n${_movie.description} ',
                style: biggerFont,
              ),
            ),
          ]),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: related()),
          ),
        ],
      ),
    );
  }

  List<Widget> related() {
    List<Widget> categories = [];
    for (var category in _movie.related.entries) {
      var map = category.value;
      String description = map.toShortString();
      categories.add(Text('${category.key}'));
      categories.add(
        Center(
          child: GestureDetector(
            onTap: () => searchForRelated(
              '${category.key}: ${_movie.title}',
              category.value.values.toList(),
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return categories;
  }

  void _launchURL(/*BuildContext context*/ String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  void _viewWebPage(String url) {
    if (Platform.isAndroid) {
      _launchURL(url);
    }
  }
}
