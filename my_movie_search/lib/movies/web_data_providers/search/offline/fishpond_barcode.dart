// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"DataSourceType.fishpondBarcode dream","bestSource":"DataSourceType.fishpondBarcode","title":"Love And Other Catastrophes 1996","alternateTitle":"Love And Other Catastrophes 1996","type":"MovieContentType.barcode","imageUrl":"https://d3fa68hw0m2vcc.cloudfront.net/099/25035.jpeg","sources":{"DataSourceType.fishpondBarcode":"DataSourceType.fishpondBarcode dream"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitHtmlSample(dummy));
}

Stream<String> _emitHtmlSample(_) async* {
  yield htmlSampleFull;
}

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
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

const htmlSampleMid = r'''
<div class="summary-top">
  <header>
      <h1>Love And Other Catastrophes</h1>
      <span class="year">1996</span>
  </header>
    <a class="thumbnail"">
      <img width="170" height="246" 
        src="https://d3fa68hw0m2vcc.cloudfront.net/099/25035.jpeg">
    </a>
</div>
  <script type="application/ld+json">
  {
    "@type": "Product",
    "name": "Love And Other Catastrophes",
    "category": "Movies & TV > Movies > Comedy > Other",
    "sku": "1514099",
    "image": "https:\/\/d3fa68hw0m2vcc.cloudfront.net\/099\/25035.jpeg",
    "productID": "upc:9398710559194",
    "description": "A day in the life of two film-school students...",
}
    </script>
''';

const intermediateMapList = [
  {
    'description': 'Love And Other Catastrophes 1996',
    'url': 'https://d3fa68hw0m2vcc.cloudfront.net/099/25035.jpeg'
  }
];
