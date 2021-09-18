import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

//show BuildContext, FontWeight, MediaQuery, Text, TextAlign, TextStyle;

bool useMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 600;
}

List<Widget> poster(String url, {void Function()? onTap}) {
  return [
    url.startsWith('http')
        ? GestureDetector(
            child: Image(
              image: NetworkImage(getBigImage(url)),
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
            onTap: onTap,
          )
        : Text('NoImage'),
    SelectableText(url, style: tinyFont),
  ];
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
          children: children,
          key: key,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
          textDirection: textDirection,
          verticalDirection: verticalDirection,
          textBaseline: textBaseline,
        ));
}

class BoldLabel extends Text {
  BoldLabel(string)
      : super(
          formatString(string),
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontWeight: FontWeight.bold,
          ),
        ) {}

  static formatString(string) {
    var newString = '';
    var words = string.split('_');
    words.forEach((word) => newString += initCap(word) + ' ');
    return newString;
  }

  static initCap(string) {
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }
}
