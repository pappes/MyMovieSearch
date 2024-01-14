import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/// Display details of an error meessag to the user.
///
/// Public parameters are:
/// * [restorationId]
///   *  A unique value used to restore this instance of the object.
/// * [errorDto]
///   *  a [MovieResultDTO] containing the error message in the title field
class ErrorDetailsPage extends StatefulWidget {
  const ErrorDetailsPage({
    required this.restorationId,
    required this.errorDto,
    super.key,
  });

  final MovieResultDTO errorDto;
  final String restorationId;

  @override
  State<ErrorDetailsPage> createState() => _ErrorDetailsPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) => MaterialPage(
        restorationId: RestorableMovie.getRestorationId(state),
        child: ErrorDetailsPage(
          errorDto: state.extra as MovieResultDTO? ?? MovieResultDTO(),
          restorationId: RestorableMovie.getRestorationId(state),
        ),
      );
}

class _ErrorDetailsPageState extends State<ErrorDetailsPage>
    with RestorationMixin {
  _ErrorDetailsPageState();

  final _restorableMovie = RestorableMovie();

  @override
  // The restoration bucket id for this page.
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) =>
      // Register our property to be saved every time it changes,
      // and to be restored every time our app is killed by the OS!
      registerForRestoration(_restorableMovie, 'dto');

  @override
  void dispose() {
    // Restorable must be disposed when no longer used.
    _restorableMovie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _restorableMovie.value = widget.errorDto;
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.errorDto.title),
        ),
        body: Scrollbar(
          thumbVisibility: true,
          child: bodySection(),
        ),
      ),
    );
  }

  ScrollView bodySection() => ListView(
        primary: true, //attach scrollbar controller to primary view
        children: <Widget>[
          Text(widget.errorDto.title),
        ],
      );
}
