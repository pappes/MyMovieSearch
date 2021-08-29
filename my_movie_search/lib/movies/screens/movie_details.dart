import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/widgets/controls.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

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
  var _mobileLayout = true;

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
    _mobileLayout = useMobileLayout(context);
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
            children: leftColumn() +
                // Only show right column on tablet
                (_mobileLayout ? [] : posterSection()),
          ),
        ),
      ],
    );
  }

  List<Widget> leftColumn() {
    return [
      Expanded(
        child: Column(
          children: [
            Wrap(
              children: leftHeader() +
                  // Only show poster in left column on mobile
                  (_mobileLayout ? posterSection() : []) +
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BoldLabel('Description:'),
                        Text(
                          _movie.description,
                          style: biggerFont,
                        ),
                      ],
                    ),
                  ] +
                  related(),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> posterSection() {
    return [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: poster(
            _movie.imageUrl,
            onTap: () => viewWebPage(
              makeImdbUrl(_movie.uniqueId, photos: true, mobile: true),
              context,
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> leftHeader() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Type: ${describeEnum(_movie.type)}'),
          Text('User Rating: ${_movie.userRating.toString()} '
              '(${formatter.format(_movie.userRatingCount)})'),
          Wrap(
            children: [
              GestureDetector(
                child: Text(
                    'Censor Rating: ${describeEnum(_movie.censorRating)}     '),
                onTap: () => viewWebPage(
                  makeImdbUrl(
                    _movie.uniqueId,
                    parentalGuide: true,
                    mobile: true,
                  ),
                  context,
                ),
              ),
              Text('Language: ${describeEnum(_movie.language)}'),
            ],
          ),
        ],
      ),
      Wrap(children: [
        Text('Source: ${describeEnum(_movie.source)}      '),
        Text('UniqueId: ${_movie.uniqueId}'),
        ElevatedButton(
          onPressed: () => viewWebPage(
            'https://tpb.party/search/${_movie.title}',
            context,
          ),
          child: Text('External'),
        ),
        ElevatedButton(
          onPressed: () => viewWebPage(
            makeImdbUrl(
              _movie.uniqueId,
              mobile: true,
            ),
            context,
          ),
          child: Text('IMDB'),
        ),
      ]),
    ];
  }

  List<Widget> related() {
    List<Widget> categories = [];
    for (var category in _movie.related.entries) {
      var map = category.value;
      String description = map.toShortString();
      categories.add(BoldLabel(category.key));
      categories.add(
        Center(
          child: GestureDetector(
            onTap: () => searchForRelated(
              '${category.key}: ${_movie.title}',
              category.value.values.toList(),
              context,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return [
      Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: categories),
      )
    ];
  }
}
