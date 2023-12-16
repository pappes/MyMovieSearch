import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({required this.restorationId, super.key});

  static const String title = "Movie Search Criteria";
  final String restorationId;

  @override
  State<MovieSearchCriteriaPage> createState() =>
      _MovieSearchCriteriaPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) =>
      const MaterialPage(
        restorationId: 'MovieSearchCriteriaPage',
        child: MovieSearchCriteriaPage(restorationId: 'MovieSearchCriteria'),
      );
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage>
    with RestorationMixin {
  late RestorableTextEditingController _textController;
  late FocusNode _criteriaFocusNode;

  void performSearch(SearchCriteriaDTO criteria) =>
      MMSNav(context).showResultsPage(criteria);

  void searchForBarcode(String barcode) => performSearch(
        SearchCriteriaDTO().init(
          SearchCriteriaType.barcode,
          title: barcode,
        ),
      );

  void searchForMovie() => performSearch(
        SearchCriteriaDTO().init(
          SearchCriteriaType.movieTitle,
          title: _textController.value.text,
        ),
      );

  @override
  String? get restorationId => 'MovieSearchCriteriaPage${widget.restorationId}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // All restorable properties must be registered with the mixin. After
    // registration, the counter either has its old value restored or is
    // initialized to its default value.
    registerForRestoration(_textController, 'criteriatext');
  }

  @override
  void initState() {
    _textController = RestorableTextEditingController();
    _criteriaFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _textController.dispose();
    // Clean up the focus node when the Form is disposed.
    _criteriaFocusNode.dispose();
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
    _criteriaFocusNode.requestFocus();
    return page;
  }
}

class _CriteriaInput extends Center {
  _CriteriaInput(_MovieSearchCriteriaPageState state)
      : super(
          child: TextField(
            controller: state._textController.value,
            focusNode: state._criteriaFocusNode,
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
                  state._textController.value.clear();
                  state._criteriaFocusNode.requestFocus();
                },
              ),
              prefixIcon: IconButton(
                icon: const Icon(Icons.qr_code_2),
                onPressed: () {
                  state._textController.value.clear();
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
