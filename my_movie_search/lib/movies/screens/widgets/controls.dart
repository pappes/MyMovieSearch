import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

/// Determines if the screen is narrow enough to require a condenced layout.
bool useMobileLayout(BuildContext context) =>
    MediaQuery.of(context).size.width < 600;

/// A [Widget] that displays a network image and image address.
///
/// if no valid network address is supplied, a placeholder text is shown instead.
///
/// Diplayed image has pinch to zoom enabled.
///
/// An [showImages] handler can be supplied to allow drilldown on the image source.
///
class Poster extends Widget {
  Poster(
    this.context, {
    required this.url,
    void Function()? showImages,
    super.key,
  }) {
    bigUrl = getBigImage(url);
    smallImage = Image(
      image: NetworkImage(url),
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
    );
    largeImage = CachedNetworkImage(
      imageUrl: bigUrl,
      placeholder: (context, url) => smallImage,
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
    final tapableImage = GestureDetector(
      onTap: _pinchToZoom,
      child: largeImage,
    );

    final imageText = SelectableText(
      url,
      onTap: _pinchToZoom,
      style: tinyFont,
    );
    final imageSearch = ElevatedButton(
      onPressed: showImages,
      child: imageSearchIcon,
    );

    controls = ExpandedColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        if (url.startsWith(webAddressPrefix))
          tapableImage
        else
          placeholderMessage,
        imageText,
        if (showImages != null) imageSearch,
      ],
    );
  }

  static const Widget placeholderMessage = Text('NoImage');
  final Widget imageSearchIcon = const Icon(Icons.image_search);
  final BuildContext context;
  late final Widget controls;
  late final String url;
  late final String bigUrl;
  late final Widget smallImage;
  late final Widget largeImage;

  @override
  Element createElement() => controls.createElement();

  Future<Dialog?> _pinchToZoom() =>
      showImageViewer(context, NetworkImage(bigUrl));
}

/// A [Widget] that includes a [Column] that expands so that it
/// virtically fills the available space.
///
/// By default children are stacked from the top and and horizontally centered.
///
class ExpandedColumn extends Expanded {
  ExpandedColumn({
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

  static String _initCap(String string) =>
      '${string[0].toUpperCase()}${string.substring(1)}';
}
