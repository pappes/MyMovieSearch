import 'package:html/dom.dart' show Element, Node;

enum ElementType { anchor, image, text, table, row }

const Map<ElementType, String> HTMLTAGS = {
  ElementType.anchor: 'a',
  ElementType.image: 'img',
  ElementType.text: 'text',
  ElementType.table: 'table',
  ElementType.row: 'tr',
};
enum AttributeType { address, source, elementClass }

const Map<AttributeType, String> ATTRIBUTENAMES = {
  AttributeType.address: 'href',
  AttributeType.source: 'src',
  AttributeType.elementClass: 'class',
};

extension NodeHelper on Node {
  String element(ElementType et) {
    return HTMLTAGS[et]!;
  }

  String attribute(ElementType at) {
    return ATTRIBUTENAMES[at]!;
  }
}

extension ElementHelper on Element {
  List<Element> getElementsByType(ElementType etype) =>
      this.getElementsByTagName(HTMLTAGS[etype]!);
  String? getAttribute(AttributeType atype) =>
      this.attributes[ATTRIBUTENAMES[atype]!];
}
