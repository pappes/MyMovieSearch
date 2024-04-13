import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

/// Determines if the screen is narrow enough to require a condenced layout.
bool useMobileLayout(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;

/// A [Widget] that displays a network image and image address.
///
/// if no valid network address is supplied, placeholder text is shown instead.
///
/// Diplayed image has pinch to zoom enabled.
///
/// showImages handler can be supplied to allow drilldown on the image source.
///
class Poster extends Widget {
  Poster(
    this._context, {
    required String url,
    void Function()? showImages,
    super.key,
  }) : _url = url {
    _bigUrl = getBigImage(_url);
    _smallImage = Image(
      image: NetworkImage(_url),
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
    );
    _largeImage = CachedNetworkImage(
      imageUrl: _bigUrl,
      placeholder: (context, url) => _smallImage,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    final tapableImage = GestureDetector(
      onTap: _pinchToZoom,
      child: _largeImage,
    );

    final imageText = SelectableText(
      _url,
      onTap: _pinchToZoom,
      style: tinyFont,
    );
    final imageSearch = ElevatedButton(
      onPressed: showImages,
      child: _imageSearchIcon,
    );

    _controls = LeftAligendColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (_url.startsWith(webAddressPrefix))
          tapableImage
        else
          _placeholderMessage,
        imageText,
        if (showImages != null) imageSearch,
      ],
    );
  }

  static const Widget _placeholderMessage = Text('NoImage');
  final Widget _imageSearchIcon = const Icon(Icons.image_search);
  final BuildContext _context;
  late final Widget _controls;
  late final String _url;
  late final String _bigUrl;
  late final Widget _smallImage;
  late final Widget _largeImage;

  @override
  Element createElement() => _controls.createElement();

  Future<Dialog?> _pinchToZoom() =>
      showImageViewer(_context, NetworkImage(_bigUrl));
}

List<Widget> movieLocationTable(
  Iterable<DataRow> rows, {
  GestureTapCallback? onTap,
  List<Widget> ifEmpty = const [],
}) =>
    (rows.isEmpty)
        ? ifEmpty
        : [
            InkWell(
              onTap: onTap,
              child: DataTable(
                headingRowHeight: 20,
                headingTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                dataRowMinHeight: 20,
                dataRowMaxHeight: 20,
                columnSpacing: 5,
                rows: rows.toList(),
                columns: const [
                  DataColumn(label: Text('Stacker')),
                  DataColumn(label: Text('Slot')),
                  DataColumn(label: Text('Title')),
                ],
              ),
            ),
          ];

Iterable<DataRow> locationsWithCustomTitle(MovieResultDTO movie) sync* {
  final customTitles = MovieLocation().getTitlesForMovie(movie.uniqueId);
  for (final customTitle in customTitles) {
    yield movieLocationRow(customTitle);
  }
}

DataRow movieLocationRow(
  DenomalizedLocation title, {
  void Function()? onLongPress,
  // ignore: avoid_positional_boolean_parameters
  void Function(bool?)? onSelectChanged,
}) =>
    DataRow(
      onLongPress: onLongPress,
      onSelectChanged: onSelectChanged,
      cells: [
        DataCell(Text(title.libNum)),
        DataCell(Text(title.location)),
        DataCell(Text(title.title)),
      ],
    );

/// A [Widget] that includes a [Column] that expands so that it
/// virtically fills the available space.
///
/// By default children are stacked from the top and and horizontally centered.
///
class LeftAligendColumn extends Expanded {
  LeftAligendColumn({
    super.key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> children = const <Widget>[],
  }) : super(
          child: Column(
            key: key,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: children,
          ),
        );
}

/// A [Text] widget that displays information with more emphasis.
///
/// Words seperated with _ and convereted to space
/// and have the initial letter capitalised.
///
class BoldLabel extends Text {
  BoldLabel(String string, {super.key})
      : super(
          _formatString(string),
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold),
        );

  static String _formatString(String string) {
    final newString = StringBuffer();
    final words = string.split('_');
    for (final word in words) {
      newString
        ..write(_initCap(word))
        ..write(' ');
    }
    return newString.toString();
  }

  static String _initCap(String string) =>
      '${string[0].toUpperCase()}${string.substring(1)}';
}
