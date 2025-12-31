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
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
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
    restorationId: RestorableMovie.getRestorationId(state),
    child: PersonDetailsPage(
      person: RestorableMovie.getDto(state),
      restorationId: RestorableMovie.getRestorationId(state),
    ),
  );
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with RestorationMixin {
  _PersonDetailsPageState();

  final RestorableBool _descriptionExpanded = RestorableBool(false);
  bool _redrawRequired = true;
  final _restorablePerson = RestorableMovie();
  var _mobileLayout = true;

  bool get isTabletLayout => !_mobileLayout;
  bool get isMobileLayout => _mobileLayout;

  @override
  void initState() {
    super.initState();
  }

  void _gotPerson(MovieResultDTO person) {
    _restorablePerson.value = person;
    _getDetails(
      SearchCriteriaDTO().init(
        SearchCriteriaType.movieTitle,
        title: _restorablePerson.value.uniqueId,
      ),
    );
  }

  /// Fetch full person details from imdb.
  void _getDetails(SearchCriteriaDTO criteria) {
    if (MovieContentType.person == _restorablePerson.value.type) {
      /// Fetch person details from cache using a separate thread.
      unawaited(
        QueryIMDBNameDetails(criteria)
            .readPrioritisedCachedList(priority: ThreadRunner.fast)
            .then(_requestShowDetails),
      );

      /// Fetch full actor/director/writer/producer data
      /// from cache using a separate thread.
        unawaited(
        QueryIMDBJsonPaginatedFilmographyDetails(criteria)
            //.readPrioritisedCachedList(priority: ThreadRunner.fast)
            .readList()
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
      'PersonDetails${_restorablePerson.value.uniqueId}',
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
      details.forEach(_restorablePerson.value.merge);

  @override
  // The restoration bucket id for this page.
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restorablePerson.defaultVal = widget.person;
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorablePerson, 'person');
    registerForRestoration(_descriptionExpanded, 'expanded');
    unawaited(
      DtoCache.singleton().fetch(_restorablePerson.value).then(_gotPerson),
    );
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
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          // Get title from the StatefulWidget PersonDetailsPage.
          title: Text(_restorablePerson.value.title),
        ),
        endDrawer: getDrawer(context),
        body: Scrollbar(
          thumbVisibility: true,
          child: ListView(
            primary: true, // attach scrollbar controller to primary view
            children: _bodySectionChildren(context),
          ),
        ),
      ),
    );
  }

  List<Widget> _bodySectionChildren(BuildContext context) => <Widget>[
    Text(_restorablePerson.value.title, style: hugeFont),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        if (_restorablePerson.value.yearRange.isEmpty)
          Text('Born: ${_restorablePerson.value.year}')
        else
          Text('Lifespan: ${_restorablePerson.value.yearRange}'),
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
              LeftAligendColumn(children: <Widget>[_leftColumn(context)]),
              if (isTabletLayout)
                LeftAligendColumn(children: [posterSection()]),
            ],
          ),
        ),
      ],
    ),
  ];

  Widget _leftColumn(BuildContext context) => Wrap(
    children: <Widget>[
      Text('Source: ${_restorablePerson.value.bestSource.name}      '),
      Text('UniqueId: ${_restorablePerson.value.uniqueId}      '),
      Text('Popularity: ${_restorablePerson.value.userRatingCount}'),
      ElevatedButton(
        onPressed:
            () => MMSNav(
              context,
            ).viewWebPage(makeImdbUrl(_restorablePerson.value.uniqueId)),
        child: const Text('IMDB'),
      ),

      if (isMobileLayout) posterSection(),

      Align(alignment: Alignment.topLeft, child: BoldLabel('Description:')),
      Align(
        alignment: Alignment.topLeft,
        child: InkWell(
          onTap: _toggleDescription,
          child: Text(
            _restorablePerson.value.description,
            style: biggerFont,
            overflow: _descriptionExpanded.value ? null : TextOverflow.ellipsis,
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
        url: _restorablePerson.value.imageUrl,
        showImages:
            () => MMSNav(context).viewWebPage(
              makeImdbUrl(_restorablePerson.value.uniqueId, photos: true),
            ),
      ),
    ],
  );

  List<Widget> _related() {
    final categories = <Widget>[];
    for (final category in _restorablePerson.value.related.entries) {
      final rolesMap = category.value;
      final rolesLabel = category.key;
      final description = rolesMap.toShortString(); // Get a list of movie roles
      categories
        ..add(
          BoldLabel('${rolesLabel.addColonIfNeeded()} (${rolesMap.length})'),
        )
        ..add(
          Center(
            child: InkWell(
              onTap:
                  () => MMSNav(context).searchForRelated(
                    // Open search details when tapped.
                    '$rolesLabel: ${_restorablePerson.value.title}',
                    rolesMap.values.toList(),
                  ),
              child: Text(description, textAlign: TextAlign.center),
            ),
          ),
        );
    }
    return categories;
  }
}
