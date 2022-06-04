import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

/// Determines if the screen is narrow enough to require a condenced layout.
bool useMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

/// A [Widget] that displays a network image and image address.
///
/// if no valid network address is supplied, a placeholder text is shown instead.
///
/// Diplayed image has pinch to zoom enabled.
///
/// An [onTap] handler can be supplied to allow drilldown on the image.
///
class Poster extends Widget {
  Poster({
    required this.url,
    this.onTap,
    Key? key,
  }) : super(key: key) {
    urlText = SelectableText(url, style: tinyFont);
    controls = makeControls();
  }

  static const placeholderMessage = Text('NoImage');
  final String url;
  late final SelectableText urlText;
  late final Widget controls;
  final void Function()? onTap;

  @override
  Element createElement() {
    return controls.createElement();
  }

  ExpandedColumn makeControls() {
    return ExpandedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (url.startsWith('http'))
          GestureDetector(onTap: onTap, child: showImage(url))
        else
          placeholderMessage,
        urlText,
      ],
    );
  }

  Widget showImage(String location) {
    return PinchZoomImage(
      image: Image(
        image: NetworkImage(getBigImage(location)),
        alignment: Alignment.topCenter,
        fit: BoxFit.fitWidth,
      ),
      zoomedBackgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
      hideStatusBarWhileZooming: true,
    );
  }
}

/// A [Widget] that includes a [Column] that expands so that it
/// virtically fills the available space.
///
/// By default children are stacked from the top and and horizontally centered.
///
class ExpandedColumn extends Expanded {
  ExpandedColumn({
    Key? key,
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
  BoldLabel(String string)
      : super(
          _formatString(string),
          textAlign: TextAlign.left,
          style: const TextStyle(
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.bold,
          ),
        );

  static String _formatString(String string) {
    final newString = StringBuffer();
    final words = string.split('_');
    for (final word in words) {
      newString.write(_initCap(word));
      newString.write(' ');
    }
    return newString.toString();
  }

  static String _initCap(String string) {
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }
}
