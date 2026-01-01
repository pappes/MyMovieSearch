// Raw data in code is generated from an external source.
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

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const intermediateMapList = [
  {
    'description': 'Love And Other Catastrophes 1996',
    'cleanDescription': 'A day in the life of two film-school students...',
    'url': 'https://d3fa68hw0m2vcc.cloudfront.net/099/25035.jpeg',
  }
];

const htmlSampleEmpty = '''
<!DOCTYPE html>
<body">
    <main>
        <div class="main">
            <div class="products">
                <p class="no-results">
                    Sorry, your search for
                    <strong>sdfsdfsdfsd</strong>
                    did not match any items.
                    "totalResults": 0
                </p>
            </div>
        </div>
    </main>
</body>
</html>''';
const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleError = '$htmlSampleStart$htmlSampleEnd';
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
  <main data-product="1234">
    <header>
        <h1 class=b-product-info__title>Love And Other Catastrophes</h1>
        <span class="year">1996</span>
    </header>
    <a class="thumbnail"">
      <img width="170" height="246" 
        src="https://d3fa68hw0m2vcc.cloudfront.net/099/25035.jpeg">
    </a>
  </main>
</div>
  <script type="application/ld+json">
  {
    "@type": "Product",
    "name": "Love And Other Catastrophes",
    "category": "Movies & TV > Movies > Comedy > Other",
    "sku": "1514099",
    "image": "https:\/\/d3fa68hw0m2vcc.cloudfront.net\/099\/25035.jpeg",
    "mainItemBarcode": "9398710559194",
    "description": "A day in the life of two film-school students...",
                "datePublished": "1996-06-26"
}
    </script>
''';
