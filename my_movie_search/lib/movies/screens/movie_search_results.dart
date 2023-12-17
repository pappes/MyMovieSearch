import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/blocs/repositories/barcode_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/more_keywords_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/movies_for_keyword_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/blocs/repositories/tor_repository.dart';
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
        restorationId: state.fullPath,
        child: MovieSearchResultsNewPage(
          criteria: state.extra as SearchCriteriaDTO? ?? SearchCriteriaDTO(),
          restorationId: RestorableSearchCriteria.getRestorationId(state),
        ),
      );
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsNewPage>
    with RestorationMixin {
  _MovieSearchResultsPageState();

  SearchBloc? _searchBloc;
  List<MovieResultDTO> _sortedList = [];
  late final RestorableMovieList _restorableList;
  late final RestorableTextEditingController _textController;
  late final FocusNode _criteriaFocusNode = FocusNode();
  late final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    _textController = RestorableTextEditingController(
      text: (widget.criteria.criteriaType == SearchCriteriaType.moreKeywords)
          ? 'Keywords for ${widget.criteria.criteriaList.first.title}'
          : widget.criteria.criteriaTitle,
    );
    _restorableList = RestorableMovieList();
    super.initState();
    //final controller = _textController.value;
    //final text = controller.text;
    // TODO(pappes): use a factory in inject search bloc instances
    // e.g _searchBloc = BlocProvider.of<SearchBloc>(context);
    /*if (_searchBloc != null && !_searchBloc!.isClosed) {
      _searchBloc!.add(SearchRequested(widget.criteria));
    }*/
  }

  BaseMovieRepository getDatasource() {
    switch (widget.criteria.criteriaType) {
      case SearchCriteriaType.downloadSimple:
      case SearchCriteriaType.downloadAdvanced:
        return TorRepository();
      case SearchCriteriaType.moviesForKeyword:
        return MoviesForKeywordRepository();
      case SearchCriteriaType.barcode:
        return BarcodeRepository();
      case SearchCriteriaType.moreKeywords:
        return MoreKeywordsRepository();
      case SearchCriteriaType.none:
      case SearchCriteriaType.custom:
      case SearchCriteriaType.movieDTOList:
      case SearchCriteriaType.movieTitle:
        return MovieSearchRepository();
    }
  }

  @override
  String get restorationId => widget.restorationId;
  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableList, 'sortedList');
    registerForRestoration(_textController, 'inputText');
    _searchBloc = SearchBloc(movieRepository: getDatasource());
    if (oldBucket == null && _searchBloc != null && !_searchBloc!.isClosed) {
      _searchBloc!.add(SearchRequested(widget.criteria));
    }
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorableList.dispose();
    _textController.dispose();
    // Clean up the focus node when the Form is disposed.
    _criteriaFocusNode.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Save state for restoration in case app is put to sleep.
    _restorableList.value = _sortedList;

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
        child: _buildMovieResults(),
      ),
    );
  }

  void _newSearch(String text) {
    widget.criteria.criteriaTitle = text;
    if (widget.criteria.criteriaList.isNotEmpty) {
      widget.criteria.criteriaList.clear();
    }
    _searchBloc!.add(SearchRequested(widget.criteria));
    _searchFocusNode.requestFocus();
  }

  Widget _buildMovieResults() => BlocBuilder<SearchBloc, SearchState>(
        bloc: _searchBloc,
        builder: (context, state) {
          _sortedList = _searchBloc!.sortedResults;
          return Scrollbar(
            thumbVisibility: true,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _sortedList.length,
              itemBuilder: _movieListBuilder,
              primary: true, //attach scrollbar controller to primary view
            ),
          );
        },
      );

  Widget _movieListBuilder(BuildContext context, int listIndex) {
    if (listIndex >= _sortedList.length) {
      return const ListTile(
        title: Text('More widgets than available data to populate them!'),
      );
    }
    return MovieTile(
      context,
      _sortedList[listIndex],
    );
  }
}
