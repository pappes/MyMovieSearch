import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        restorationId: state.fullPath,
        child: MovieDetailsPage(
            movie: state.extra as MovieResultDTO? ?? MovieResultDTO(),
            restorationId: RestorableMovie.getRestorationId(state)),
      );
}

class _MovieDetailsPageState extends State<MovieDetailsPage>
    with RestorationMixin {
  late MovieResultDTO _movie;
  bool _redrawRequired = true;
  final RestorableBool _descriptionExpanded = RestorableBool(false);
  final _restorableMovie = RestorableMovie();
  var _mobileLayout = true;

  _MovieDetailsPageState();

  @override
  void initState() {
    super.initState();
    _movie = DtoCache.singleton().fetch(widget.movie);
    _getDetails(SearchCriteriaDTO().init(
      SearchCriteriaType.movieTitle,
      title: _movie.uniqueId,
    ));
  }

  /// Fetch full person details from imdb.
  void _getDetails(SearchCriteriaDTO criteria) {
    if (_movie.uniqueId.startsWith(imdbTitlePrefix)) {
      /// Fetch movie details
      QueryIMDBTitleDetails(criteria).readList().then(_requestShowDetails);

      /// Fetch cast details from cache using a separate thread.
      QueryIMDBCastDetails(criteria)
          .readPrioritisedCachedList(priority: ThreadRunner.fast)
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
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, 'movie');
    registerForRestoration(_descriptionExpanded, 'expanded');
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
    _restorableMovie.value = _movie;
    _mobileLayout = useMobileLayout(context);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_movie.title),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          child: _bodySection(),
        ),
      ),
    );
  }

  ScrollView _bodySection() => ListView(
        primary: true, //attach scrollbar controller to primary view
        children: <Widget>[
          Text(_movie.title, style: hugeFont),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_movie.yearRange.isEmpty)
                Text('Year: ${_movie.year}')
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
                    ExpandedColumn(children: <Widget>[_leftColumn()]),

                    // Only show right column on tablet
                    if (!_mobileLayout)
                      ExpandedColumn(children: [_posterSection()]),
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
          ..._description(),
          // Only show poster in left column on mobile
          if (_mobileLayout) _posterSection(),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._suggestions(),
              ..._cast(),
            ],
          ),
        ],
      );

  Widget _posterSection() => Row(
        children: [
          Poster(
            context,
            url: _movie.imageUrl,
            showImages: () => MMSNav(context)
                .viewWebPage(makeImdbUrl(_movie.uniqueId, photos: true)),
          ),
        ],
      );

  Widget _movieFacts() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Type: ${_movie.type.name}'),
          Text(
            'User Rating: ${_movie.userRating} '
            '(${formatter.format(_movie.userRatingCount)})',
          ),
          Wrap(
            children: <Widget>[
              Text('Censor Rating: ${_movie.censorRating.name}     '),
              Text('Language: ${_movie.language.name}'),
            ],
          ),
        ],
      );

  List<Widget> _leftHeader() => [
        InkWell(
          child: _movieFacts(),
          onTap: () => MMSNav(context).viewWebPage(
            makeImdbUrl(_movie.uniqueId, parentalGuide: true),
          ),
        ),
        Wrap(
          children: <Widget>[
            Text('Source: ${_movie.bestSource.name}      '),
            Text('UniqueId: ${_movie.uniqueId}'),
            ElevatedButton(
              onPressed: () =>
                  MMSNav(context).viewWebPage(makeImdbUrl(_movie.uniqueId)),
              child: const Text('IMDB'),
            ),
            ..._externalSearchButtons(),
          ],
        ),
      ];

  List<Widget> _description() => [
        BoldLabel('Description:'),
        InkWell(
          onTap: _toggleDescription,
          child: Text(
            _movie.description,
            style: biggerFont,
            overflow: _descriptionExpanded.value ? null : TextOverflow.ellipsis,
            maxLines: _descriptionExpanded.value ? null : 8,
          ),
        ),
        Text('Languages: ${_movie.languages}'),
        Text('Genres: ${_movie.genres}'),
        _keywords(),
      ];

  void _toggleDescription() => setState(() {
        _descriptionExpanded.value = !_descriptionExpanded.value;
      });

  final caseInsensativeSuggestion =
      RegExp('[sS][uU][gG][gG][eE][sS][tT][iI][oO][nN]');

  List<Widget> _suggestions() => _related(caseInsensativeSuggestion);

  List<Widget> _cast() =>
      _related(caseInsensativeSuggestion, invertFilter: true);

  Widget _keywords() {
    Widget makeHyperlink(String keyword) => InkWell(
          child: Text('  $keyword  '),
          onTap: () => MMSNav(context).getMoviesForKeyword(keyword),
        );

    final hyperlinks = <Widget>[];
    for (final keyword in _movie.keywords) {
      hyperlinks.add(makeHyperlink(keyword));
    }

    final label = InkWell(
      child: const Text('Keywords: '),
      onTap: () => MMSNav(context).getMoreKeywords(_movie),
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
    for (final category in _movie.related.entries) {
      if (filterIncludes(category.key)) {
        final rolesMap = category.value;
        final rolesLabel = category.key;
        final description = rolesMap.toShortString();
        categories
          ..add(BoldLabel('$rolesLabel (${rolesMap.length})'))
          ..add(
            Center(
              child: InkWell(
                onTap: () => MMSNav(context).searchForRelated(
                  '$rolesLabel ${_movie.title}',
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
        _externalSearchButton(_movie.title),
        if (_movie.alternateTitle.isNotEmpty)
          _externalSearchButton(_movie.alternateTitle),
      ];

  Widget _externalSearchButton(String title) => ElevatedButton(
        onPressed: () => MMSNav(context).getDownloads(
          '$title ${_movie.year}',
          _movie,
        ),
        child: Text(title),
      );
}
