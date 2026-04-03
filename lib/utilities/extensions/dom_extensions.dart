import 'dart:async';

import 'package:html/dom.dart' show Element, Node;
import 'package:html_unescape/html_unescape_small.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:universal_io/io.dart';

// Extend standard dart library to use enums instead of hard coded strings
enum ElementType { anchor, image, text, table, row }

const webAddressPrefix = 'http';
const jsonScript = 'script[type="application/json"]';
const startHtml = '<';
const endHtml = '>';

const Map<ElementType, String> _htmlTags = {
  ElementType.anchor: 'a',
  ElementType.image: 'img',
  ElementType.text: 'text',
  ElementType.table: 'table',
  ElementType.row: 'tr',
};

enum AttributeType { address, source, elementClass }

const Map<AttributeType, String> _attributeNames = {
  AttributeType.address: 'href',
  AttributeType.source: 'src',
  AttributeType.elementClass: 'class',
};

/// Extend html DOM [Node] to provide convenience functions.
///
extension NodeHelper on Node {
  /// Convert [ElementType] element tag to html string element tag.
  ///
  /// ```dart
  /// ElementType.image;  // returns 'img'
  /// ```
  String element(ElementType et) => _htmlTags[et]!;

  /// Convert [AttributeType] element tag to html attribute tag.
  ///
  /// ```dart
  /// AttributeType.address; // returns 'href'
  /// ```
  String attribute(AttributeType at) => _attributeNames[at]!;
}

/// Extend html DOM [Element] to provide convenience functions.
///
extension ElementHelper on Element {
  static final htmlDecode = HtmlUnescape();

  /// Search the DOM for child elements of type [etype].
  ///
  /// ```dart
  /// getElementsByType(ElementType.row);
  /// ```
  List<Element> getElementsByType(ElementType etype) =>
      getElementsByTagName(_htmlTags[etype]!);

  /// Extract HTML attribute [atype] from a HTML element.
  ///
  /// ```dart
  /// getAttribute(AttributeType.source);
  /// ```
  String? getAttribute(AttributeType atype) =>
      attributes[_attributeNames[atype]!];

  String get cleanText => _cleanHtmlText(text);

  String _cleanHtmlText(dynamic text) {
    final str = text?.toString() ?? '';
    final cleanStr = str
        .replaceAll('\n', ' ')
        .replaceAll('\t', ' ')
        .replaceAll('\u{00a0}', ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
    return htmlDecode.convert(cleanStr.reduceWhitespace());
  }
}

/// Extend [HttpHeaders] to provide convenience functions.
///
extension HttpHeadersHelper on HttpHeaders {
  /// Convert [HttpHeaders] to a [Map<String, String>].
  ///
  /// ```dart
  /// final headers = HttpClient().headers;
  /// final map = headers.toMap();
  /// ```
  Map<String, String> toMap() {
    final map = <String, String>{};
    forEach((name, values) {
      map[name] = values.join(', ');
    });

    return map;
  }

  /// Convert [HttpHeaders] to a [Map<String, List<String>>].
  ///
  /// ```dart
  /// final headers = HttpClient().headers;
  /// final map = headers.toMultiMap();
  /// ```
  Map<String, List<String>> toMultiMap() {
    final map = <String, List<String>>{};
    forEach((name, values) {
      map[name] = values;
    });
    return map;
  }
}

/// Extend [HttpHeaders] to provide convenience functions.
///
extension HttpHeadersFactoryHelper on Map<String, dynamic> {
  /// Convert [Map] to [HttpHeaders].
  ///
  /// ```dart
  /// final headers = HttpClient().headers;
  /// final map = headers.toMap();
  /// ```
  Future<HttpHeaders> toHttpHeaders() async {
    final headers = await createEmptyHttpHeaders();
    for (final entry in entries) {
      final value = entry.value;
      if (value is Object) {
        headers.add(entry.key, value);
      }
    }

    return headers;
  }

  /// Initialise a real blank [HttpHeaders].
  ///
  /// ```dart
  /// final headers = await HttpHeadersFactoryHelper.createEmptyHttpHeaders();
  /// ```
  static Future<HttpHeaders> createEmptyHttpHeaders() async {
    final request = await HttpClient().headUrl(
      Uri.parse('http://www.microsoft.com:80'),
    );
    final headers = request.headers;

    request.abort();
    unawaited(request.close());
    headers.clear();
    return headers;
  }
}
