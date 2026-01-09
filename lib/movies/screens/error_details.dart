import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/snack_drawer.dart';

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
      errorDto: RestorableMovie.getDto(state),
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

  void _gotError(MovieResultDTO dto) {
    // Check the user has not navigated away
    if (!mounted) return;

    setState(() => _restorableMovie.value = dto);
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _restorableMovie.defaultVal = widget.errorDto;
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, 'dto');
    unawaited(
      DtoCache.singleton().fetch(_restorableMovie.value).then(_gotError),
    );
  }

  @override
  void dispose() {
    // Restorable must be disposed when no longer used.
    _restorableMovie.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SelectionArea(
    child: Scaffold(
      appBar: AppBar(title: Text(_restorableMovie.value.title)),
      endDrawer: getDrawer(context),
      body: Scrollbar(thumbVisibility: true, child: bodySection()),
    ),
  );

  ScrollView bodySection() => ListView(
    primary: true, //attach scrollbar controller to primary view
    children: <Widget>[
      Text(_restorableMovie.value.title),
      Text(_restorableMovie.value.alternateTitle),
    ],
  );
}
