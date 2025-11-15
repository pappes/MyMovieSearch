import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/screens/widgets/controls.dart';
import 'package:my_movie_search/movies/screens/widgets/snack_drawer.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_title.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/thread.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage({
    required this.restorationId,
    required this.movie,
    super.key,
  });

  final MovieResultDTO movie;
  final String restorationId;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) => MaterialPage(
        restorationId: RestorableMovie.getRestorationId(state),
        child: MovieDetailsPage(
          movie: RestorableMovie.getDto(state),
          restorationId: RestorableMovie.getRestorationId(state),
        ),
      );
}

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with RestorationMixin {
  _MovieDetailsPageState();

  bool _redrawRequired = true;
  final RestorableBool _descriptionExpanded = RestorableBool(false);
  final _restorableMovie = RestorableMovie();
  var _mobileLayout = true;

  @override
  void initState() {
    super.initState();
  }

  void _gotMovie(MovieResultDTO movie) {
    _restorableMovie.value = movie;
    _getDetails(
      SearchCriteriaDTO().init(
        SearchCriteriaType.movieTitle,
        title: _restorableMovie.value.uniqueId,
      ),
    );
  }

  /// Fetch full movie details from imdb.
  void _getDetails(SearchCriteriaDTO criteria) {
    if (_restorableMovie.value.uniqueId.startsWith(imdbTitlePrefix)) {
      /// Fetch movie details
      unawaited(
        QueryIMDBTitleDetails(criteria).readList().then(_requestShowDetails),
      );

      /// Fetch cast details from cache using a separate thread.
      unawaited(
        QueryIMDBCastDetails(criteria)
            .readPrioritisedCachedList(priority: ThreadRunner.fast)
            .then(_requestShowDetails),
      );

      /// Fetch full actor/director/writer/producer data
      /// from cache using a separate thread.
      unawaited(
        QueryIMDBJsonCastDetails(criteria)
            .readList()
            .then(_requestShowDetails),
      );
    }
  }

  /// Fetch full person details from imdb.
  void _requestShowDetails(List<MovieResultDTO> castDetails) {
    if (castDetails.isNotEmpty) {
      _mergeDetails(castDetails);
    }
    _redrawRequired = true;
    EasyThrottle.throttle(
      'MovieDetails${_restorableMovie.value.uniqueId}',
      const Duration(milliseconds: 500), // limit refresh to 2 per second
      _showDetails, // Initial screen draw
      onAfter: _showDetails, // Process throttled updates
    );
  }

  /// Fetch full person details from imdb.
  void _showDetails() {
    // Check the user has not navigated away
    if (!mounted || !_redrawRequired) return;

    setState(() => {});
    _redrawRequired = false;
  }

  void _mergeDetails(List<MovieResultDTO> details) =>
      details.forEach(_restorableMovie.value.merge);

  @override
  // The restoration bucket id for this page.
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restorableMovie.defaultVal = widget.movie;
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, 'movie');
    registerForRestoration(_descriptionExpanded, 'expanded');

    unawaited(
      DtoCache.singleton().fetch(_restorableMovie.value).then(_gotMovie),
    );
  }

  @override
  void dispose() {
    // Restorable must be disposed when no longer used.
    _restorableMovie.dispose();
    _descriptionExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mobileLayout = useMobileLayout(context);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_restorableMovie.value.title),
        ),
        endDrawer: getDrawer(context),
        body: Scrollbar(
          thumbVisibility: true,
          child: _bodySection(),
        ),
      ),
    );
  }

  ScrollView _bodySection() => ListView(
        primary: true, // Attach scrollbar controller to primary view.
        children: <Widget>[
          Text(_restorableMovie.value.title, style: hugeFont),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_restorableMovie.value.yearRange.isEmpty)
                Text('Year: ${_restorableMovie.value.year}')
              else
                Text('Year Range: ${_restorableMovie.value.yearRange}'),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Run Time: '
                  '${_restorableMovie.value.runTime.toFormattedTime()}',
                ),
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
                    LeftAligendColumn(children: <Widget>[_leftColumn()]),

                    // Only show right column on tablet.
                    if (!_mobileLayout)
                      LeftAligendColumn(children: [_posterSection()]),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  Widget _leftColumn() => Wrap(
        children: [
          ..._leftHeader(),
          ..._locations(),
          ..._description(),
          // Only show poster in left column on mobile.
          if (_mobileLayout) _posterSection(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._related(_caseInsensativeSuggestion),
              ..._cast(),
            ],
          ),
        ],
      );

  Widget _posterSection() => Row(
        children: [
          Poster(
            context,
            url: _restorableMovie.value.imageUrl,
            showImages: () async => MMSNav(context).viewWebPage(
              makeImdbUrl(
                _restorableMovie.value.uniqueId,
                photos: true,
              ),
            ),
          ),
        ],
      );

  Widget _movieFacts() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Type: ${_restorableMovie.value.type.name}'),
          Text(
            'User Rating: ${_restorableMovie.value.userRating} '
            '(${formatter.format(_restorableMovie.value.userRatingCount)})',
          ),
          Wrap(
            children: <Widget>[
              Text('Censor Rating: '
                  '${_restorableMovie.value.censorRating.name}     '),
              Text('Language: ${_restorableMovie.value.language.name}'),
            ],
          ),
        ],
      );

  List<Widget> _leftHeader() => [
        InkWell(
          child: _movieFacts(),
          onTap: () async => MMSNav(context).viewWebPage(
            makeImdbUrl(_restorableMovie.value.uniqueId, parentalGuide: true),
          ),
        ),
        Wrap(
          children: <Widget>[
            Text('Source: ${_restorableMovie.value.bestSource.name}      '),
            Text('UniqueId: ${_restorableMovie.value.uniqueId}'),
            Wrap(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async => MMSNav(context).viewWebPage(
                    makeImdbUrl(
                      _restorableMovie.value.uniqueId,
                    ),
                  ),
                  child: const Text('IMDB'),
                ),
                Wrap(children: _externalSearchButtons()),
              ],
            ),
          ],
        ),
      ];

  List<Widget> _description() => [
        Row(
          children: <Widget>[
            BoldLabel('Description:'),
          ],
        ),
        InkWell(
          onTap: _toggleDescription,
          child: Text(
            _restorableMovie.value.description,
            style: biggerFont,
            overflow: _descriptionExpanded.value ? null : TextOverflow.ellipsis,
            maxLines: _descriptionExpanded.value ? null : 8,
          ),
        ),
        Text('Languages: ${_restorableMovie.value.languages}'),
        Text('Genres: ${_restorableMovie.value.genres}'),
        _keywords(),
      ];

  void _toggleDescription() => setState(() {
        _descriptionExpanded.value = !_descriptionExpanded.value;
      });

  final _caseInsensativeSuggestion =
      RegExp('[sS][uU][gG][gG][eE][sS][tT][iI][oO][nN]');

  List<Widget> _locations() => movieLocationTable(
        locationsWithCustomTitle(_restorableMovie.value),
        onTap: _addLocations,
        ifEmpty: [
          ElevatedButton(
            onPressed: _addLocations,
            child: const Text('Tap to add location'),
          ),
        ],
      );
  Future<Object?> _addLocations() async => MMSNav(context).addLocation(
        _restorableMovie.value,
      );

  List<Widget> _cast() =>
      _related(_caseInsensativeSuggestion, invertFilter: true);

  Widget _keywords() {
    Widget makeHyperlink(String keyword) => InkWell(
          child: Text('  $keyword  '),
          onTap: () async => MMSNav(context).showMoviesForKeyword(keyword),
        );

    final hyperlinks = <Widget>[];
    for (final keyword in _restorableMovie.value.keywords) {
      hyperlinks.add(makeHyperlink(keyword));
    }

    final label = InkWell(
      child: const Text('Keywords: '),
      onTap: () async =>
          MMSNav(context).getMoreKeywords(_restorableMovie.value),
    );

    return Wrap(
      children: <Widget>[
        label,
        ...hyperlinks,
      ],
    );
  }

  List<Widget> _related(RegExp filter, {bool invertFilter = false}) {
    bool filterIncludes(String text) {
      if (invertFilter && !filter.hasMatch(text)) return true;
      if (!invertFilter && filter.hasMatch(text)) return true;
      return false;
    }

    final categories = <Widget>[];
    for (final category in _restorableMovie.value.related.entries) {
      if (filterIncludes(category.key)) {
        final rolesMap = category.value;
        final rolesLabel = category.key;
        final description = rolesMap.toShortString();
        categories
          ..add(BoldLabel('$rolesLabel (${rolesMap.length})'))
          ..add(
            Center(
              child: InkWell(
                onTap: () async => MMSNav(context).searchForRelated(
                  '$rolesLabel ${_restorableMovie.value.title}',
                  rolesMap.values.toList(),
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

  List<Widget> _externalSearchButtons() => <Widget>[
        _externalSearchButton(_restorableMovie.value.title),
        if (_restorableMovie.value.alternateTitle.isNotEmpty)
          _externalSearchButton(_restorableMovie.value.alternateTitle),
      ];

  Widget _externalSearchButton(String title) => ElevatedButton(
        onPressed: () async => MMSNav(context).showDownloads(
          '$title ${_restorableMovie.value.year}',
          _restorableMovie.value,
        ),
        child: Text(title),
      );
}
