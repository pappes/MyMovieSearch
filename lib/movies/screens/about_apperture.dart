import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/movie_card_small.dart';
import 'package:my_movie_search/movies/screens/widgets/snack_drawer.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:yaml/yaml.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({
    required this.restorationId,
    required this.criteria,
    super.key,
  });

  final SearchCriteriaDTO criteria;
  final String restorationId;

  @override
  State<AboutPage> createState() => _AboutState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) => MaterialPage(
    restorationId: RestorableSearchCriteria.getRestorationId(state),
    child: AboutPage(
      criteria: RestorableSearchCriteria.getDto(state),
      restorationId: RestorableSearchCriteria.getRestorationId(state),
    ),
  );
}

class _AboutState extends State<AboutPage> with RestorationMixin {
  _AboutState();

  SearchBloc? _searchBloc;
  late final _restorableCriteria = RestorableSearchCriteria();
  late final _restorableList = RestorableMovieList();
  bool searchRequested = false;
  String? applicationVersion;
  String? applicationDescription;

  @override
  String get restorationId => widget.restorationId;
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restorableCriteria.defaultVal = widget.criteria;
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableCriteria, 'criteriaDto');
    registerForRestoration(_restorableList, 'sortedList');

    _searchBloc ??= SearchBloc(
      movieRepository: SearchCriteriaDTOHelpers.getDatasource(
        _restorableCriteria.value.criteriaType,
      ),
    );
    _performSearch();
  }

  void _performSearch() {
    if (_restorableCriteria.value.criteriaType == SearchCriteriaType.about) {
      // Initiate a search if not restoring data.
      searchRequested = false;
    } else if (_restorableList.value.isEmpty) {
      // Initiate a search if not restoring data.
      searchRequested = true;
      _searchBloc!.add(SearchRequested(_restorableCriteria.value));
    }
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorableCriteria.dispose();
    _restorableList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      // Use the search criteria to set our appbar title.
      title: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('About Apperture'),
            Text(
              'Version: ${Settings().applicationVersion}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              Settings().applicationDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
    endDrawer: getDrawer(context),
    body: Center(
      child: searchRequested ? _buildMovieResults() : _movieListSection(),
    ),
  );

  Widget _buildMovieResults() => BlocBuilder<SearchBloc, SearchState>(
    bloc: _searchBloc,
    builder: (context, state) {
      if (_searchBloc!.sortedResults.isNotEmpty) {
        // if a search has been conducted use the new search results
        _restorableList.value = _searchBloc!.sortedResults
            .shallowCopy()
            .toList();
      }
      return _movieListSection();
    },
  );

  Scrollbar _movieListSection() => Scrollbar(
    thumbVisibility: true,
    child: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _restorableList.value.length,
      itemBuilder: _movieListBuilder,
      primary: true, //attach scrollbar controller to primary view
    ),
  );

  Widget _movieListBuilder(BuildContext context, int listIndex) {
    if (listIndex >= _restorableList.value.length) {
      return const ListTile(
        title: Text('More widgets than available data to populate them!'),
      );
    }

    return MovieTile(context, _restorableList.value[listIndex]);
  }
}
