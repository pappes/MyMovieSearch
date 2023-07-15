import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart'
    show MovieSearchResultsNewPage;
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:universal_io/io.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({Key? key}) : super(key: key);

  static const String title = "Movie Search Criteria";

  @override
  _MovieSearchCriteriaPageState createState() =>
      _MovieSearchCriteriaPageState();

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const MovieSearchCriteriaPage(),
    );
  }
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage>
    with RestorationMixin {
  final _criteria = SearchCriteriaDTO().init(SearchCriteriaType.movieTitle);
  final _restorableCriteria = RestorableSearchCriteria();

  var _currentCriteria = '';
  late final textController = TextEditingController(text: _currentCriteria);
  late final FocusNode criteriaFocusNode = FocusNode();

  void searchForMovie() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieSearchResultsNewPage(criteria: _criteria),
      ),
    );
  }

  void searchBarcode(dynamic barcode) {
    if (barcode is String && barcode.isNotEmpty) {
      _criteria.criteriaTitle = barcode;
      _criteria.criteriaType = SearchCriteriaType.barcode;
      searchForMovie();
    }
  }

  void scanBarcode() {
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ),
      ).then(searchBarcode);
    } else {
      searchBarcode(
          '9324915073425'); // Hard code known barcode for linux testing
    }
  }

  @override
  // The restoration bucket id for this page.
  String get restorationId =>
      'MovieSearchCriteria'; //+ _criteria.value.criteriaTitle;

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
    textController.dispose();
    // Clean up the focus node when the Form is disposed.
    criteriaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    _restorableCriteria.value = _criteria;
    final page = Scaffold(
      appBar: AppBar(
        // Get title from the StatefulWidget MovieSearchCriteriaPage.
        title: const Text(MovieSearchCriteriaPage.title),
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
        child: const Icon(Icons.search),
      ),
    );
    criteriaFocusNode.requestFocus();
    return page;
  }
}

class _CriteriaInput extends Center {
  _CriteriaInput(_MovieSearchCriteriaPageState state)
      : super(
          child: TextField(
            controller: state.textController,
            focusNode: state.criteriaFocusNode,
            textInputAction: TextInputAction.search,
            autofocus: true,
            autofillHints: const [AutofillHints.sublocality],
            style: hugeFont,
            decoration: InputDecoration(
              labelText: "Movie",
              hintText: "Enter movie or tv series to search for",
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  state.textController.clear();
                  state.criteriaFocusNode.requestFocus();
                },
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.qr_code_2),
                onPressed: () {
                  state.textController.clear();
                  state.scanBarcode();
                },
              ),
            ),
            onChanged: (text) {
              state._criteria.criteriaTitle = text;
            },
            onSubmitted: (text) {
              state._criteria.criteriaTitle = text;
              state._criteria.criteriaType = SearchCriteriaType.movieTitle;
              state.searchForMovie();
            },
          ),
        );
}
