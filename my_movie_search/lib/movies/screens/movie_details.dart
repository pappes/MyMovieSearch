import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/screens/widgets/controls.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/thread.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  final MovieResultDTO movie;

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with RestorationMixin {
  late MovieResultDTO _movie;
  bool _redrawRequired = true;
  final _restorableMovie = RestorableMovie();
  var _mobileLayout = true;

  _MovieDetailsPageState();

  @override
  void initState() {
    super.initState();
    _movie = DtoCache.singleton().fetch(widget.movie);
    final detailCriteria = SearchCriteriaDTO();
    detailCriteria.criteriaTitle = _movie.uniqueId;
    _getDetails(detailCriteria);
  }

  /// Fetch full person details from imdb.
  void _getDetails(SearchCriteriaDTO criteria) {
    if (_movie.uniqueId.startsWith(imdbTitlePrefix)) {
      /// Fetch movie details
      QueryIMDBTitleDetails()
          .readList(
            criteria,
          )
          .then(_requestShowDetails);

      /// Fetch cast details from cache using a separate thread.
      QueryIMDBCastDetails()
          .readPrioritisedCachedList(
            criteria,
            priority: ThreadRunner.fast,
          )
          .then(_requestShowDetails);
    }
  }

  /// Fetch full person details from imdb.
  void _requestShowDetails(List<MovieResultDTO> castDetails) {
    if (castDetails.isNotEmpty) {
      _mergeDetails(castDetails);
    }
    _redrawRequired = true;
    EasyThrottle.throttle(
      'MovieDetails${_movie.uniqueId}',
      const Duration(milliseconds: 500), // limit refresh to 2 per second
      () => _showDetails(), // Initial screen draw
      onAfter: () => _showDetails(), // Process throttled updates
    );
  }

  /// Fetch full person details from imdb.
  void _showDetails() {
    // Check the user has not navigated away
    if (!mounted || !_redrawRequired) return;

    setState(() => _movie);
    _redrawRequired = false;
  }

  void _mergeDetails(List<MovieResultDTO> details) {
    for (final dto in details) {
      _movie.merge(dto);
    }
  }

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'MovieDetails${_movie.uniqueId}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, _movie.uniqueId);
  }

  @override
  void dispose() {
    // Restorable must be disposed when no longer used.
    _restorableMovie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _restorableMovie.value = _movie;
    _mobileLayout = useMobileLayout(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_movie.title),
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: bodySection(),
      ),
    );
  }

  ScrollView bodySection() {
    return ListView(
      children: <Widget>[
        SelectableText(_movie.title, style: hugeFont),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_movie.yearRange.isEmpty)
              Text('Year: ${_movie.year.toString()}')
            else
              Text('Year Range: ${_movie.yearRange}'),
            Align(
              alignment: Alignment.centerRight,
              child: Text('Run Time: ${_movie.runTime.toFormattedTime()}'),
            ),
          ],
        ),
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ExpandedColumn(children: <Widget>[leftColumn()]),

                  // Only show right column on tablet
                  if (!_mobileLayout)
                    ExpandedColumn(children: [posterSection()]),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget leftColumn() {
    return Wrap(
      children: [
        ...leftHeader(),
        // Only show poster in left column on mobile
        if (_mobileLayout) posterSection(),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...description(),
            ...suggestions(),
            ...cast(),
          ],
        ),
      ],
    );
  }

  Widget posterSection() {
    return Row(
      children: [
        Poster(
          url: _movie.imageUrl,
          onTap: () => viewWebPage(
            makeImdbUrl(_movie.uniqueId, photos: true),
            context,
          ),
        ),
      ],
    );
  }

  List<Widget> leftHeader() {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Type: ${_movie.type.name}'),
          Text(
            'User Rating: ${_movie.userRating.toString()} '
            '(${formatter.format(_movie.userRatingCount)})',
          ),
          Wrap(
            children: <Widget>[
              GestureDetector(
                child: Text(
                  'Censor Rating: ${_movie.censorRating.name}     ',
                ),
                onTap: () => viewWebPage(
                  makeImdbUrl(_movie.uniqueId, parentalGuide: true),
                  context,
                ),
              ),
              Text('Language: ${_movie.language.name}'),
            ],
          ),
        ],
      ),
      Wrap(
        children: <Widget>[
          Text('Source: ${_movie.bestSource.name}      '),
          Text('UniqueId: ${_movie.uniqueId}'),
          ElevatedButton(
            onPressed: () => viewWebPage(
              makeImdbUrl(_movie.uniqueId),
              context,
            ),
            child: const Text('IMDB'),
          ),
          ...externalSearch(),
        ],
      ),
    ];
  }

  List<Widget> description() {
    return [
      BoldLabel('Description:'),
      Text(
        _movie.description,
        style: biggerFont,
      ),
      Text('Languages: ${_movie.languages.toString()}'),
      Text('Genres: ${_movie.genres.toString()}'),
      Text('Keywords: ${_movie.keywords.toString()}'),
    ];
  }

  final caseInsensativeSuggestion =
      RegExp('[sS][uU][gG][gG][eE][sS][tT][iI][oO][nN]');

  List<Widget> suggestions() => related(caseInsensativeSuggestion);

  List<Widget> cast() => related(caseInsensativeSuggestion, invertFilter: true);

  List<Widget> related(RegExp filter, {bool invertFilter = false}) {
    bool testFilter(String text, RegExp filter, bool invertFilter) {
      if (invertFilter && !filter.hasMatch(text)) return true;
      if (!invertFilter && filter.hasMatch(text)) return true;
      return false;
    }

    final categories = <Widget>[];
    for (final category in _movie.related.entries) {
      if (testFilter(category.key, filter, invertFilter)) {
        final rolesMap = category.value;
        final rolesLabel = category.key;
        //inal map = category.value;
        final description = rolesMap.toShortString();
        categories.add(BoldLabel('$rolesLabel (${rolesMap.length})'));

        categories.add(
          Center(
            child: GestureDetector(
              onTap: () => searchForRelated(
                '$rolesLabel ${_movie.title}',
                rolesMap.values.toList(),
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
    }
    return categories;
  }

  List<Widget> externalSearch() {
    return <Widget>[
      ElevatedButton(
        onPressed: () => viewWebPage(
          'https://tpb.party/search/${_movie.title} ${_movie.year}',
          context,
        ),
        child: Text(_movie.title),
      ),
      if (_movie.alternateTitle.isNotEmpty)
        ElevatedButton(
          onPressed: () => viewWebPage(
            'https://tpb.party/search/${_movie.alternateTitle} ${_movie.year}',
            context,
          ),
          child: Text(_movie.alternateTitle),
        ),
    ];
  }
}
