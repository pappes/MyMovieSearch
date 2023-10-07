import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({super.key});

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

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage> {
  final textController = TextEditingController();
  final FocusNode criteriaFocusNode = FocusNode();

  void performSearch(SearchCriteriaDTO criteria) {
    MMSNav(context).showResultsPage(criteria);
  }

  void searchForBarcode(String barcode) {
    performSearch(
      SearchCriteriaDTO().init(
        SearchCriteriaType.barcode,
        title: barcode,
      ),
    );
  }

  void searchForMovie() {
    performSearch(
      SearchCriteriaDTO().init(
        SearchCriteriaType.movieTitle,
        title: textController.text,
      ),
    );
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    textController.dispose();
    // Clean up the focus node when the Form is disposed.
    criteriaFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
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
                  DVDBarcodeScanner()
                      .scanBarcode(state.context, state.searchForBarcode);
                },
              ),
            ),
            onSubmitted: (_) {
              state.searchForMovie();
            },
          ),
        );
}
