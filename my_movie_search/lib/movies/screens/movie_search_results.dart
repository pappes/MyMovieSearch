import 'package:flutter/material.dart'
    show
        AppBar,
        BuildContext,
        Center,
        EdgeInsets,
        Key,
        ListTile,
        ListView,
        RestorableString,
        RestorationBucket,
        RestorationMixin,
        Scaffold,
        Scrollbar,
        State,
        StatefulWidget,
        Text,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder;

import 'package:my_movie_search/movies/blocs/repositories/movie_search_repository.dart';
import 'package:my_movie_search/movies/blocs/search_bloc.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/widgets/movie_card_small.dart';

class MovieSearchResultsNewPage extends StatefulWidget {
  const MovieSearchResultsNewPage({Key? key, required this.criteria})
      : super(key: key);
  final SearchCriteriaDTO criteria;

  @override
  _MovieSearchResultsPageState createState() => _MovieSearchResultsPageState();
}

class _MovieSearchResultsPageState extends State<MovieSearchResultsNewPage>
    with RestorationMixin {
  SearchBloc? _searchBloc;
  List<MovieResultDTO> _sortedList = [];
  late String _searchId;
  final _restorableList = RestorableMovieList();
  var _restorableId = RestorableString('');
  var _title = 'Results';

  _MovieSearchResultsPageState();

  @override
  void initState() {
    super.initState();
    _title = widget.criteria.criteriaTitle;
    _searchId = widget.criteria.searchId;
    //TODO: use a factory in inject search bloc instances _searchBloc = BlocProvider.of<SearchBloc>(context);
    _searchBloc = SearchBloc(movieRepository: MovieSearchRepository());
    _searchBloc!.add(SearchRequested(widget.criteria));
  }

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'MovieSearchResults$_searchId';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableId, 'searchId');
    registerForRestoration(_restorableList, _searchId);
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorableId.dispose();
    _restorableList.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Save state for restoration in case app is put to sleep.
    _restorableList.value = _sortedList;
    _restorableId = _restorableId;

    return Scaffold(
        appBar: AppBar(
          // Use the search criteria to set our appbar title.
          title: Text(_title),
        ),
        body: Center(
          child: _buildMovieResults(),
        ));
  }

  Widget _buildMovieResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        _sortedList = _searchBloc!.sortedResults;
        return Scrollbar(
          isAlwaysShown: true,
          child: ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _sortedList.length,
            itemBuilder: _movieListBuilder,
          ),
        );
      },
    );
  }

  Widget _movieListBuilder(BuildContext context, int listIndex) {
    if (listIndex >= _sortedList.length) {
      return const ListTile(
        title: Text("More widgets than available data to populate them!"),
      );
    }
    return MovieTile(context, _sortedList[listIndex]);
  }
}
