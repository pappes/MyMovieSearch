import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';

bool useMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

List<Widget> poster_old(String url, {void Function()? onTap}) {
  final retval = <Widget>[];
  if (!url.startsWith('http')) {
    retval.add(const Text('NoImage'));
  } else {
    retval.add(
      GestureDetector(
        onTap: onTap,
        child: Image(
          image: NetworkImage(getBigImage(url)),
          alignment: Alignment.topCenter,
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  retval.add(SelectableText(url, style: tinyFont));
  return retval;
}

List<Widget> poster(String url, {void Function()? onTap}) {
  final retval = <Widget>[];
  if (!url.startsWith('http')) {
    retval.add(const Text('NoImage'));
  } else {
    retval.add(
      GestureDetector(
        onTap: onTap,
        child: showImage(url),
      ),
    );
  }

  retval.add(SelectableText(url, style: tinyFont));
  return retval;
}

Widget showImage(String location) {
  return PinchZoomImage(
    image: Image(
      image: NetworkImage(getBigImage(location)),
      alignment: Alignment.topCenter,
      fit: BoxFit.fitWidth,
    ), //Image.network(getBigImage(location)),
    zoomedBackgroundColor: const Color.fromRGBO(240, 240, 240, 1.0),
    hideStatusBarWhileZooming: true,
    onZoomStart: () {
      print('Zoom started');
    },
    onZoomEnd: () {
      print('Zoom finished');
    },
  );
}

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
