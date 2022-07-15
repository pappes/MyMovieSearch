import 'package:html/dom.dart' show Element, Node;

//Entend stardard dart library to use enums instead of hard coded strings
enum ElementType { anchor, image, text, table, row }

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
  String element(ElementType et) {
    return _htmlTags[et]!;
  }

  /// Convert [AttributeType] element tag to html attribute tag.
  ///
  /// ```dart
  /// AttributeType.address; // returns 'href'
  /// ```
  String attribute(AttributeType at) {
    return _attributeNames[at]!;
  }
}

/// Extend html DOM [Element] to provide convenience functions.
///
extension ElementHelper on Element {
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
}
