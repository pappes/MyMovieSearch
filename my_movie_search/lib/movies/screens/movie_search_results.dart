import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/movie_card_small.dart';

class MovieSearchResultsNewPage extends StatefulWidget {
  const MovieSearchResultsNewPage({
    required this.restorationId,
    required this.criteria,
    super.key,
  });

  final SearchCriteriaDTO criteria;
  final String restorationId;

  @override
  State<MovieSearchResultsNewPage> createState() =>
      _MovieSearchResultsPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) => MaterialPage(
        restorationId: RestorableSearchCriteria.getRestorationId(state),
        child: MovieSearchResultsNewPage(
          criteria: RestorableSearchCriteria.getDto(state),
          restorationId: RestorableSearchCriteria.getRestorationId(state),
        ),
      );
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsNewPage>
    with RestorationMixin {
  _MovieSearchResultsPageState();

  SearchBloc? _searchBloc;
  late final _restorableCriteria = RestorableSearchCriteria();
  late final _restorableList = RestorableMovieList();
  late final RestorableTextEditingController _textController;
  late final FocusNode _criteriaFocusNode = FocusNode();
  late final FocusNode _searchFocusNode = FocusNode();
  bool searchRequested = false;

  @override
  void initState() {
    _textController = RestorableTextEditingController(
      text: (widget.criteria.criteriaType == SearchCriteriaType.moreKeywords)
          ? 'Keywords for ${widget.criteria.criteriaList.first.title}'
          : widget.criteria.criteriaTitle,
    );
    super.initState();
    //final controller = _textController.value;
    //final text = controller.text;
    // TODO(pappes): use a factory in inject search bloc instances
    // e.g _searchBloc = BlocProvider.of<SearchBloc>(context);
    /*if (_searchBloc != null && !_searchBloc!.isClosed) {
      _searchBloc!.add(SearchRequested(widget.criteria));
    }*/
  }

  @override
  String get restorationId => widget.restorationId;
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restorableCriteria.defaultVal = widget.criteria;
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableCriteria, 'criteriaDto');
    registerForRestoration(_restorableList, 'sortedList');
    registerForRestoration(_textController, 'inputText');

    _searchBloc ??= SearchBloc(
      movieRepository: SearchCriteriaDTOHelpers.getDatasource(
        _restorableCriteria.value.criteriaType,
      ),
    );
    if (_restorableList.value.isEmpty) {
      // Initiate a search if not restoring data.
      searchRequested = true;
      _searchBloc!.add(SearchRequested(_restorableCriteria.value));
    } else {
      unawaited(_populateFromCache(_restorableList.value));
    }
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorableCriteria.dispose();
    _restorableList.dispose();
    _textController.dispose();
    // Clean up the focus node when the Form is disposed.
    _criteriaFocusNode.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _populateFromCache(List<MovieResultDTO> dtos) async {
    final futures = <Future<dynamic>>[];
    for (final dto in dtos) {
      final cached = DtoCache.singleton().merge(dto);
      futures.add(_replaceEntry(dtos, dtos.indexOf(dto), cached));
    }
    // When all cached data has been merged, call setState to update the screen.
    unawaited(Future.wait(futures).then((_) => setState(() => {})));
  }

  Future<void> _replaceEntry(
    List<MovieResultDTO> dtos,
    int index,
    Future<MovieResultDTO> cached,
  ) async {
    final newValue = await cached;
    if (dtos[index].uniqueId == newValue.uniqueId) dtos[index] = newValue;
  }

  @override
  Widget build(BuildContext context) {
    final criteriaText = TextField(
      controller: _textController.value,
      focusNode: _criteriaFocusNode,
      onSubmitted: _newSearch,
      showCursor: true,
      decoration: InputDecoration(
        hintText: 'search text',
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            _textController.value.clear();
            _criteriaFocusNode.requestFocus();
          },
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        // Use the search criteria to set our appbar title.
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(child: criteriaText),
              IconButton(
                onPressed: () => _newSearch(_textController.value.text),
                icon: const Icon(Icons.search),
                focusNode: _searchFocusNode,
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: searchRequested ? _buildMovieResults() : _movieListSection(),
      ),
    );
  }

  void _newSearch(String text) {
    searchRequested = true;
    _restorableCriteria.value.criteriaTitle = text;
    if (_restorableCriteria.value.criteriaList.isNotEmpty) {
      _restorableCriteria.value.criteriaList.clear();
    }
    _searchBloc!.add(SearchRequested(_restorableCriteria.value));
    _searchFocusNode.requestFocus();
  }

  Widget _buildMovieResults() => BlocBuilder<SearchBloc, SearchState>(
        bloc: _searchBloc,
        builder: (context, state) {
          if (_searchBloc!.sortedResults.isNotEmpty) {
            // if a search has been conducted use the new search results
            _restorableList.value =
                _searchBloc!.sortedResults.shallowCopy().toList();
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
    return MovieTile(
      context,
      _restorableList.value[listIndex],
    );
  }
}
