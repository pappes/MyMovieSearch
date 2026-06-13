import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({
    required this.restorationId,
    required this.criteria,
    super.key,
  });

  static const title = 'Movie Search Criteria';
  final SearchCriteriaDTO criteria;
  final String restorationId;

  @override
  State<MovieSearchCriteriaPage> createState() =>
      _MovieSearchCriteriaPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<Object?> goRoute(_, GoRouterState state) => MaterialPage(
    restorationId: 'MovieSearchCriteriaPage',
    child: MovieSearchCriteriaPage(
      criteria: RestorableSearchCriteria.getDto(state),
      restorationId: 'MovieSearchCriteria',
    ),
  );
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage>
    with RestorationMixin {
  late RestorableTextEditingController _textController;
  late FocusNode _criteriaFocusNode;

  Future<Object?> performSearch(SearchCriteriaDTO criteria) async {
    // Await the route close
    final result = await MMSNav(
      context,
    ).showResultsPage(criteria, showKeyboardOnReturn: true);
    showKeyboard();
    return result;
  }

  @awaitNotRequired
  Future<void> showKeyboard({
    Duration delay = const Duration(milliseconds: 200),
  }) async {
    await Future<void>.delayed(delay);
    await SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  Future<Object?> searchForBarcode(String barcode) => performSearch(
    SearchCriteriaDTO()..init(SearchCriteriaType.barcode, title: barcode),
  );

  Future<Object?> searchForMovie() {
    widget.criteria.criteriaTitle = _textController.value.text;
    return performSearch(widget.criteria);
  }

  @override
  String? get restorationId => 'MovieSearchCriteriaPage${widget.restorationId}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // All restorable properties must be registered with the mixin. After
    // registration, the restorable either has its old value restored or is
    // initialized to its default value.
    registerForRestoration(_textController, 'criteriatext');
  }

  @override
  void initState() {
    _textController = RestorableTextEditingController();
    _criteriaFocusNode = FocusNode();
    super.initState();

    showKeyboard(delay: const Duration(milliseconds: 500));
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
    final page = AppScaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: (ModalRoute.of(context)?.canPop ?? false)
            ? const BackButton()
            : null,
        // Get title from the StatefulWidget MovieSearchCriteriaPage.
        title: const Text(MovieSearchCriteriaPage.title),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/MMS_ICON_highres_blue_desaturated.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.1, // Adjust opacity to make text readable
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            //special sizing to avoid redraw after keyboard pops up.
            height:
                MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(flex: 1), // 1 part of space at the top
                _CriteriaInput(this),
                const Spacer(flex: 3), // 3 parts below the input box
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: searchForMovie,
        tooltip: 'Search',
        child: const Icon(Icons.search),
      ),
    );
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
          autofillHints: const [AutofillHints.name],
          style: hugeFont,
          decoration: InputDecoration(
            labelText: 'Movie',
            hintText: 'Enter movie or tv series to search for',
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
                DVDBarcodeScanner().scanBarcode(
                  state.context,
                  state.searchForBarcode,
                );
              },
            ),
          ),
          onSubmitted: (_) {
            state.searchForMovie();
          },
        ),
      );
}
