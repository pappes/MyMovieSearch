import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        restorationId: state.fullPath,
        child: MoviePhysicalLocationPage(
          movieDto: state.extra as MovieResultDTO? ?? MovieResultDTO(),
          restorationId: RestorableMovie.getRestorationId(state),
        ),
      );
}

class _MoviePhysicalLocationPageState extends State<MoviePhysicalLocationPage>
    with RestorationMixin {
  _MoviePhysicalLocationPageState();

  final _restorableMovie = RestorableMovie();
  late final RestorableTextEditingController _stackerController;
  late final RestorableTextEditingController _locationController;
  late final RestorableTextEditingController _titleController;
  late final FocusNode _stackerFocusNode = FocusNode();
  late final FocusNode _locationFocusNode = FocusNode();
  late final FocusNode _titleFocusNode = FocusNode();
  var _mobileLayout = true;

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
    _mobileLayout = useMobileLayout(context);
    return SelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_restorableMovie.value.title),
        ),
        //body: bodySection(),
        body: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: bodySection(),
          ),
        ),

        /* body: Scrollbar(
          thumbVisibility: true,
          child: bodySection(),
        ),*/
      ),
    );
  }

  ScrollView oldBodySection() => ListView(
        primary: true, //attach scrollbar controller to primary view
        children: <Widget>[
          Text(widget.movieDto.title),
        ],
      );

  Widget bodySection() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                stackerSectionLayout(),
                const VerticalDivider(
                  endIndent: 50,
                ),
                locationSectionLayout(),
              ],
            ),
          ),
          existingContentsSectionLayout(),
        ],
      );
  Widget stackerSectionLayout() => SizedBox(
        width: 100,
        child: stackerSectionContents(),
      );
  Widget locationSectionLayout() => Expanded(
        child: locationSectionContents(),
      );
  Widget existingContentsSectionLayout() => Align(
        alignment: Alignment.bottomCenter,
        child: Expanded(child: existingContentsSectionContents()),
      );
  Widget stackerSectionContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldLabel('Stacker'),
          const Expanded(
            child: Column(
              children: [
                Text('001'),
                Text('002'),
                Text('003'),
                Text('004'),
                Text('005'),
                Text('006'),
                Text('007'),
                Text('008'),
                Text('009'),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: stackerInputField(),
          ),
        ],
      );
  Widget locationSectionContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldLabel('Location'),
          const Expanded(child: Text('more stuff here')),
          //const Expanded(child: Text('more stuff here')),
          Align(
            alignment: Alignment.bottomRight,
            child: locationInputField(),
          ),
        ],
      );
  Widget existingContentsSectionContents() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...[BoldLabel('Existing Contents')],
          ...movieLocations(
            _restorableMovie.value,
          ),
          ...[
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Add'),
                Text('Done'),
              ],
            )
          ],
        ],
      );
  //Widget orientation() => _mobileLayout ? Row.new : Column.new;

  Widget stackerInputField() => TextField(
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

  Widget locationInputField() => TextField(
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
}
