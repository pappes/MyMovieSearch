import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/screens/widgets/app_scaffold.dart';
import 'package:my_movie_search/movies/screens/widgets/search_text_field.dart';
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
  late final RestorableTextEditingController _textController;
  late final FocusNode _criteriaTextFocusNode;

  static int _keyboardRetryCount = 0;

  void _unfocus() {
    _criteriaTextFocusNode.unfocus();
  }

  /// Perform the search and navigate to the results page.
  Future<Object?> performSearch(SearchCriteriaDTO criteria) async {
    // Unfocus before navigating
    //to prevent the node from freezing in a 'disabled' state
    _unfocus();

    final result = await MMSNav(
      context,
    ).showResultsPage(criteria, showKeyboardOnReturn: true);
    _showKeyboard();
    return result;
  }

  /// Show the keyboard and request focus.
  void _showKeyboard() {
    _keyboardRetryCount = 0;
    _tryRequestFocus();

    unawaited(SystemChannels.textInput.invokeMethod('TextInput.show'));
  }

  /// Poll for focusability over the next couple of frames 
  /// in case the parent tree has IgnorePointer active.
  void _tryRequestFocus() {
    if (!mounted) return;

    // Wait for the route-pop transition layout to completely settle down
    if (_criteriaTextFocusNode.canRequestFocus) {
      _unfocus();
      FocusScope.of(context).requestFocus(_criteriaTextFocusNode);
    } else {
      if (_keyboardRetryCount < 100) {
        _keyboardRetryCount++;
        // If parent tree has IgnorePointer active, try the next frame
        WidgetsBinding.instance.addPostFrameCallback((_) => _tryRequestFocus());
      }
    }
  }

  /// Search for a barcode.
  Future<Object?> searchForBarcode(String barcode) => performSearch(
    SearchCriteriaDTO()..init(SearchCriteriaType.barcode, title: barcode),
  );

  /// Search for a movie.
  Future<Object?> searchForMovie(String title) {
    widget.criteria.criteriaTitle = title;
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
    super.initState();
    _textController = RestorableTextEditingController();
    _criteriaTextFocusNode = FocusNode();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _showKeyboard();
    });
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _textController.dispose();
    // Clean up the focus node when the Form is disposed.
    _criteriaTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    final page = AppScaffold(
      resizeToAvoidBottomInset: false,
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
                const Spacer(flex: 2), // 1 part of space at the top
                SearchTextField(
                  textEditingController: _textController.value,
                  focusNode: _criteriaTextFocusNode,
                  textStyle: hugeFont,
                  prefixIcon: _barcodeScanner(),
                  onSelected: searchForMovie,
                ),
                const Spacer(flex: 3), // 3 parts below the input box
              ],
            ),
          ),
        ),
      ),
    );
    return page;
  }

  /// Return the widget for the barcode scanner.
  Widget _barcodeScanner() => IconButton(
    icon: const Icon(Icons.qr_code_2),
    onPressed: () {
      _textController.value.clear();
      DVDBarcodeScanner().scanBarcode(context, searchForBarcode);
    },
  );
}
