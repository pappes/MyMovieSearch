// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"item-331233484","bestSource":"DataSourceType.picclickBarcode","title":"the pink panther film collection 6 peter sellers rare set","alternateTitle":"The Pink Panther Film Collection DVD Box Set - 6 Disc - Peter Sellers RARE Set","type":"MovieContentType.barcode",
      "description":"item-331233484","imageUrl":"https://www.picclickimg.com/bv123456789O9j~TH2/The-Pink-Panther-Film-Collection-DVD-Box-Set.jpg","sources":{"DataSourceType.picclickBarcode":"item-331233484"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitHtmlSample(dummy));
}

Stream<String> _emitHtmlSample(_) async* {
  yield htmlSampleFull;
}

const htmlSampleFull = '$htmlSampleStart$tpbSampleMid$htmlSampleEnd';
const htmlSampleStart = '''

<!DOCTYPE html>
<html xmlns:snip=true>
  <body>
    <div>''';
const htmlSampleEnd = '''
    </div>
  </body>
</html>
''';

const tpbSampleMid = '''
<ul class="items">
  <li id="item-331233484">
    <picture>
      <source
        srcset="https://www.picclickimg.com/bv123456789O9j~TH2/The-Pink-Panther-Film-Collection-DVD-Box-Set.webp"
        type="image/webp">
      <source
        srcset="https://www.picclickimg.com/bv123456789O9j~TH2/The-Pink-Panther-Film-Collection-DVD-Box-Set.jpg"
        type="image/jpeg"><img
        src="https://www.picclickimg.com/bv123456789O9j~TH2/The-Pink-Panther-Film-Collection-DVD-Box-Set.webp"
        onload="sq(this)"
        title="The Pink Panther Film Collection DVD Box Set - 6 Disc - Peter Sellers RARE Set"
        alt="The Pink Panther Film Collection DVD Box Set - 6 Disc - Peter Sellers RARE Set" />
    </picture>
    <h3 title="The Pink Panther Film Collection DVD Box Set - 6 Disc - Peter Sellers RARE Set">The
      Pink Panther Film Collection DVD Box Set - 6 Disc - Peter Sellers RARE Set</h3>
  </li>
</ul>
''';

const intermediateMapList = [
  {
    'description':
        'The Pink Panther Film Collection DVD Box Set - 6 Disc - Peter Sellers RARE Set',
    'barcode': 'item-331233484',
    'cleanDescription':
        'the pink panther film collection 6 peter sellers rare set',
    'url':
        'https://www.picclickimg.com/bv123456789O9j~TH2/The-Pink-Panther-Film-Collection-DVD-Box-Set.jpg'
  }
];
