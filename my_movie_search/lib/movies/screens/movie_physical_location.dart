import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/controls.dart';

/// Add information about storage of physical media.
///
/// Public parameters are:
/// * [restorationId]
///   *  A unique value used to restore this instance of the object.
/// * [movieDto]
///   *  a [MovieResultDTO] containing the error message in the title field
class MoviePhysicalLocationPage extends StatefulWidget {
  const MoviePhysicalLocationPage({
    required this.restorationId,
    required this.movieDto,
    super.key,
  });

  final MovieResultDTO movieDto;
  final String restorationId;

  @override
  State<MoviePhysicalLocationPage> createState() =>
      _MoviePhysicalLocationPageState();

  /// Instruct goroute how to navigate to this page.
  static MaterialPage<dynamic> goRoute(_, GoRouterState state) => MaterialPage(
        restorationId: RestorableMovie.getRestorationId(state),
        child: MoviePhysicalLocationPage(
          movieDto: RestorableMovie.getDto(state),
          restorationId: RestorableMovie.getRestorationId(state),
        ),
      );
}

class _MoviePhysicalLocationPageState extends State<MoviePhysicalLocationPage>
    with RestorationMixin {
  _MoviePhysicalLocationPageState();

  final _restorableMovie = RestorableMovie(MovieResultDTO());
  late final RestorableTextEditingController _stackerController;
  late final RestorableTextEditingController _locationController;
  late final RestorableTextEditingController _titleController;
  late final FocusNode _stackerFocusNode = FocusNode();
  late final FocusNode _locationFocusNode = FocusNode();
  late final FocusNode _titleFocusNode = FocusNode();

  @override
  // The restoration bucket id for this page.
  String get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorableMovie, 'dto');
    registerForRestoration(_stackerController, '_stackerController');
    registerForRestoration(_locationController, '_locationController');
    registerForRestoration(_titleController, '_titleController');
  }

  @override
  void initState() {
    _stackerController = RestorableTextEditingController(text: '001');
    _locationController = RestorableTextEditingController(text: '001');
    _titleController = RestorableTextEditingController(
      text: widget.movieDto.title,
    );
    super.initState();
  }

  @override
  void dispose() {
    // Restorable must be disposed when no longer used.
    _restorableMovie.dispose();
    _stackerController.dispose();
    _locationController.dispose();
    _titleController.dispose();
    _stackerFocusNode.dispose();
    _locationFocusNode.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _restorableMovie.value = widget.movieDto;
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_restorableMovie.value.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: _bodySection(),
        ),
      ),
    );
  }

  Widget _bodySection() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _stackerSectionLayout(),
                _locationSectionLayout(),
              ],
            ),
          ),
          _existingContentsSectionLayout(),
        ],
      );
  Widget _stackerSectionLayout() => SizedBox(
        width: 100,
        child: _stackerSectionContents(),
      );
  Widget _locationSectionLayout() => Expanded(
        child: _locationSectionContents(),
      );
  Widget _existingContentsSectionLayout() => Align(
        alignment: Alignment.bottomCenter,
        child: _existingContentsSectionContents(),
      );
  Widget _stackerSectionContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldLabel('Stacker'),
          _availableStackersLayout(),
          Align(
            alignment: Alignment.bottomLeft,
            child: _stackerInputField(),
          ),
        ],
      );
  Widget _locationSectionContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldLabel('Location'),
          LeftAligendColumn(
            children: [
              const Text('empty locations:'),
              _emptyLocationsLayout(),
              const Text('used locations:'),
              _usedLocationsLayout(),
            ],
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const VerticalDivider(),
                Flexible(
                  flex: 1,
                  child: Column(
                    children: [
                      _locationInputField(),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Flexible(
                  flex: 2,
                  child: Column(
                    children: [
                      _titleInputField(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _availableStackersLayout() => _scrollableColumn(
        _createStackerWidgets(_getStackerLabels()),
      );
  Widget _usedLocationsLayout() => _scrollableColumn(
        flex: 1,
        _usedLocationsContent(),
      );
  Widget _emptyLocationsLayout() => _scrollableColumn(
        flex: 4,
        _emptyLocationsContent(),
        primary: true,
      );

  Widget _scrollableColumn(
    Iterable<Widget> contents, {
    bool primary = false,
    int flex = 1,
  }) =>
      Expanded(
        flex: flex,
        child: Row(
          children: [
            const VerticalDivider(),
            LeftAligendColumn(
              children: [
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView(
                      primary: primary, //there can be only one
                      children: contents.toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Iterable<Widget> _emptyLocationsContent() => _createLocationsWidgets(
        MovieLocation().emptyLocations(_stackerController.value.text),
      );

  Iterable<Widget> _usedLocationsContent() => _createLocationsWidgets(
        MovieLocation().usedLocations(_stackerController.value.text),
      );

  Iterable<Widget> _createLocationsWidgets(Iterable<String> locations) sync* {
    for (final location in locations) {
      yield selectableText(location, _locationController.value);
    }
  }

  List<Widget> _createStackerWidgets(List<String> indexes) {
    final widgets = <Widget>[];
    for (final index in indexes) {
      widgets.add(
        selectableText(index, _stackerController.value),
      );
    }
    return widgets;
  }

  Widget selectableText(String text, TextEditingController controller) =>
      InkWell(
        child: Text(text),
        onTap: () => setState(() => controller.text = text),
      );

  Widget _existingContentsSectionContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[BoldLabel('Existing Contents')],
          ...movieLocations(
            _restorableMovie.value,
            proposedLocation: currentLocation(),
          ),
          ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    MovieLocation().storeMovieAtLocation(
                      currentMovie(),
                      currentLocation(),
                    );
                    context.pop();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ],
      );

  StackerAddress currentLocation() => StackerAddress(
        libNum: _stackerController.value.text,
        location: _locationController.value.text,
      );
  StackerContents currentMovie() => StackerContents(
        uniqueId: _restorableMovie.value.uniqueId,
        titleName: _titleController.value.text,
      );

  List<Widget> movieLocations(
    MovieResultDTO movie, {
    StackerAddress? proposedLocation,
  }) =>
      movieLocationTable(
        [
          ...moviesAtLocation(proposedLocation),
          ...locationsWithCustomTitle(movie),
        ],
      );

  Iterable<DataRow> moviesAtLocation(StackerAddress? location) sync* {
    if (location != null) {
      final movies = MovieLocation().getMoviesAtLocation(location);
      for (final movie in movies) {
        yield movieLocationRow(location, movie.titleName);
      }
    }
  }

  Widget _stackerInputField() => TextField(
        controller: _stackerController.value,
        focusNode: _stackerFocusNode,
        //onSubmitted: _newSearch,
        showCursor: true,
        decoration: InputDecoration(
          hintText: 'Which device is the disc in?',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _stackerController.value.clear();
              _stackerFocusNode.requestFocus();
            },
          ),
        ),
      );

  Widget _locationInputField() => TextField(
        controller: _locationController.value,
        focusNode: _locationFocusNode,
        //onSubmitted: _newSearch,
        showCursor: true,
        decoration: InputDecoration(
          hintText: 'Which position is the disc in?',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _locationController.value.clear();
              _locationFocusNode.requestFocus();
            },
          ),
        ),
      );

  Widget _titleInputField() => TextField(
        controller: _titleController.value,
        focusNode: _titleFocusNode,
        //onSubmitted: _newSearch,
        showCursor: true,
        decoration: InputDecoration(
          hintText: 'What is the name of the disc?',
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _titleController.value.clear();
              _titleFocusNode.requestFocus();
            },
          ),
        ),
      );

  List<String> _getStackerLabels() {
    final labels = <String>[];
    for (int i = 1; i < 100; i++) {
      labels.add(i.toString().padLeft(3, '0'));
    }
    return labels;
  }
}
