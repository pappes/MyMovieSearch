import 'dart:async';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/screens/widgets/controls.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_bibliography.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/thread.dart';

class PersonDetailsPage extends StatefulWidget {
  const PersonDetailsPage({
    required this.restorationId,
    required this.person,
    super.key,
  });

  final MovieResultDTO person;
  final String restorationId;

  @override
  State<PersonDetailsPage> createState() => _PersonDetailsPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) => MaterialPage(
        restorationId: state.fullPath,
        child: PersonDetailsPage(
          person: state.extra as MovieResultDTO? ?? MovieResultDTO(),
          restorationId: RestorableMovie.getRestorationId(state),
        ),
      );
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with RestorationMixin {
  _PersonDetailsPageState();

  late MovieResultDTO _person;
  final RestorableBool _descriptionExpanded = RestorableBool(false);
  bool _redrawRequired = true;
  final _restorablePerson = RestorableMovie();
  var _mobileLayout = true;

  @override
  void initState() {
    super.initState();
    _person = DtoCache.singleton().fetch(widget.person);
    _getDetails(
      SearchCriteriaDTO().init(
        SearchCriteriaType.movieTitle,
        title: _person.uniqueId,
      ),
    );
  }

  /// Fetch full person details from imdb.
  void _getDetails(SearchCriteriaDTO criteria) {
    if (MovieContentType.person == _person.type) {
      /// Fetch person details from cache using a separate thread.
      unawaited(
        QueryIMDBNameDetails(criteria)
            .readPrioritisedCachedList(priority: ThreadRunner.fast)
            .then(_requestShowDetails),
      );

      /// Fetch related movie from cache using a separate thread.
      unawaited(
        QueryIMDBBibliographyDetails(criteria)
            .readPrioritisedCachedList(priority: ThreadRunner.slow)
            .then(_requestShowDetails),
      );
    }
  }

  /// Fetch full person details from imdb.
  void _requestShowDetails(List<MovieResultDTO> personDetails) {
    if (personDetails.isNotEmpty) {
      _mergeDetails(personDetails);
    }
    _redrawRequired = true;
    EasyThrottle.throttle(
      'PersonDetails${_person.uniqueId}',
      const Duration(milliseconds: 500), // limit refresh to 2 per second
      _showDetails, // Initial screen draw
      onAfter: _showDetails, // Process throttled updates
    );
  }

  /// Fetch full person details from imdb.
  void _showDetails() {
    // Check the user has not navigated away
    if (!mounted || !_redrawRequired) return;

    setState(() => _person);
    _redrawRequired = false;
  }

  void _mergeDetails(List<MovieResultDTO> details) =>
      details.forEach(_person.merge);

  @override
  // The restoration bucket id for this page.
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorablePerson, 'person');
    registerForRestoration(_descriptionExpanded, 'expanded');
  }

  @override
  void dispose() {
    // Restorable must be disposed when no longer used.
    _restorablePerson.dispose();
    _descriptionExpanded.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _mobileLayout = useMobileLayout(context);
    _restorablePerson.value = _person;
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          // Get title from the StatefulWidget PersonDetailsPage.
          title: Text(_person.title),
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
          Text(_person.title, style: hugeFont),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (_person.yearRange.isEmpty)
                Text('Born: ${_person.year}')
              else
                Text('Lifespan: ${_person.yearRange}'),
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

                    // Only show right column on tablet
                    if (!_mobileLayout)
                      LeftAligendColumn(
                        children: [posterSection()],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );

  Widget _leftColumn() => Wrap(
        children: <Widget>[
          Text('Source: ${_person.bestSource.name}      '),
          Text('UniqueId: ${_person.uniqueId}      '),
          Text('Popularity: ${_person.userRatingCount}'),
          ElevatedButton(
            onPressed: () async =>
                MMSNav(context).viewWebPage(makeImdbUrl(_person.uniqueId)),
            child: const Text('IMDB'),
          ),

          // Only show poster in left column on mobile
          if (_mobileLayout) posterSection(),

          Align(
            alignment: Alignment.topLeft,
            child: BoldLabel('Description:'),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              onTap: _toggleDescription,
              child: Text(
                _person.description,
                style: biggerFont,
                overflow:
                    _descriptionExpanded.value ? null : TextOverflow.ellipsis,
                maxLines: _descriptionExpanded.value ? null : 8,
              ),
            ),
          ),
          ..._related(),
        ],
      );

  void _toggleDescription() =>
      setState(() => _descriptionExpanded.value = !_descriptionExpanded.value);

  Widget posterSection() => Row(
        children: [
          Poster(
            context,
            url: _person.imageUrl,
            showImages: () async => MMSNav(context).viewWebPage(
              makeImdbUrl(_person.uniqueId, photos: true),
            ),
          ),
        ],
      );

  List<Widget> _related() {
    final categories = <Widget>[];
    for (final category in _person.related.entries) {
      final rolesMap = category.value;
      final rolesLabel = category.key;
      final description = rolesMap.toShortString(); // Get a list of movie roles
      categories
        ..add(BoldLabel('$rolesLabel: (${rolesMap.length})'))
        ..add(
          Center(
            child: InkWell(
              onTap: () async => MMSNav(context).searchForRelated(
                // Open search details when tapped.
                '$rolesLabel: ${_person.title}',
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
    return categories;
  }
}
