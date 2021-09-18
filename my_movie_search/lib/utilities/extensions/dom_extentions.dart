import 'package:html/dom.dart' show Element, Node;

enum ElementType { anchor, image, text, table, row }

const Map<ElementType, String> _HTMLTAGS = {
  ElementType.anchor: 'a',
  ElementType.image: 'img',
  ElementType.text: 'text',
  ElementType.table: 'table',
  ElementType.row: 'tr',
};
enum AttributeType { address, source, elementClass }

const Map<AttributeType, String> _ATTRIBUTENAMES = {
  AttributeType.address: 'href',
  AttributeType.source: 'src',
  AttributeType.elementClass: 'class',
};

/// Extend html DOM [Node] to provide convenience functions.
///
extension NodeHelper on Node {
  /// Convert [ElementType] element tag to html string element tag.
  ///
  /// e.g. ElementType.image is converted to 'img'
  String element(ElementType et) {
    return _HTMLTAGS[et]!;
  }

  /// Convert [AttributeType] element tag to html attribute tag.
  ///
  /// e.g. AttributeType.address is converted to 'href'
  String attribute(AttributeType at) {
    return _ATTRIBUTENAMES[at]!;
  }
}

/// Extend html DOM [Element] to provide convenience functions.
///
extension ElementHelper on Element {
  /// Search the DOM for child elements of type [etype].
  ///
  List<Element> getElementsByType(ElementType etype) =>
      this.getElementsByTagName(_HTMLTAGS[etype]!);

  /// Extract HTML attribute [atype] from a HTML element.
  ///
  String? getAttribute(AttributeType atype) =>
      this.attributes[_ATTRIBUTENAMES[atype]!];
}
