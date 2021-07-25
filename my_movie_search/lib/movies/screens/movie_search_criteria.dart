import 'package:flutter/material.dart'
    show
        AppBar,
        AutofillHints,
        BuildContext,
        Center,
        Column,
        FloatingActionButton,
        Icon,
        Icons,
        InputDecoration,
        Key,
        MainAxisAlignment,
        MaterialPageRoute,
        Navigator,
        RestorationBucket,
        RestorationMixin,
        Route,
        Scaffold,
        State,
        StatefulWidget,
        Text,
        TextField,
        TextInputAction,
        Widget;
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'movie_search_results.dart' show MovieSearchResultsNewPage;
import 'styles.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({Key? key}) : super(key: key);

  final String title = "Movie Search Criteria";

  @override
  _MovieSearchCriteriaPageState createState() =>
      _MovieSearchCriteriaPageState();

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => MovieSearchCriteriaPage());
  }
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage>
    with RestorationMixin {
  var _criteria = SearchCriteriaDTO();
  var _restorableCriteria = RestorableSearchCriteria();
  void searchForMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsNewPage(criteria: _criteria)),
    );
  }

  @override
  // The restoration bucket id for this page.
  String get restorationId =>
      runtimeType.toString(); //+ _criteria.value.criteriaTitle;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableCriteria, 'criteria');
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorableCriteria.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    _restorableCriteria.value = _criteria;
    return Scaffold(
      appBar: AppBar(
        // Get title from the StatefulWidget MovieSearchCriteriaPage.
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _CriteriaInput(this),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchForMovie,
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),
    );
  }
}

class _CriteriaInput extends Center {
  _CriteriaInput(_MovieSearchCriteriaPageState state)
      : super(
          child: TextField(
            textInputAction: TextInputAction.search,
            autofocus: true,
            autocorrect: true,
            autofillHints: [AutofillHints.sublocality],
            style: hugeFont,
            decoration: InputDecoration(
              labelText: "Movie",
              hintText: "Enter movie or tv series to search for",
            ),
            onChanged: (text) {
              state._criteria.criteriaTitle = text;
            },
            onSubmitted: (text) {
              state._criteria.criteriaTitle = text;
              state.searchForMovie();
            },
          ),
        );
}
