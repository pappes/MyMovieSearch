import 'package:flutter/material.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

class ErrorDetailsPage extends StatefulWidget {
  const ErrorDetailsPage({super.key, required this.errorDto});

  final MovieResultDTO errorDto;

  @override
  _ErrorDetailsPageState createState() => _ErrorDetailsPageState();
}

class _ErrorDetailsPageState extends State<ErrorDetailsPage>
    with RestorationMixin {
  final _restorableMovie = RestorableMovie();

  _ErrorDetailsPageState();

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'ErrorDetails${widget.errorDto.uniqueId}';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, widget.errorDto.uniqueId);
  }

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

  ScrollView bodySection() {
    return ListView(
      primary: true, //attach scrollbar controller to primary view
      children: <Widget>[
        Text(widget.errorDto.title),
      ],
    );
  }
}
