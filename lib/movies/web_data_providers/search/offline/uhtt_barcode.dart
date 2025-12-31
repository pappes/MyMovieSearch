// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_ignore
// ignore_for_file: unnecessary_raw_strings
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"9324915073425","bestSource":"DataSourceType.uhttBarcode","title":"dexter the","alternateTitle":"Dexter DVD the first season","type":"MovieContentType.barcode",
      "description":"9324915073425","sources":{"DataSourceType.uhttBarcode":"9324915073425"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleEmpty = '$htmlSampleStart$htmlSampleEnd';

const htmlSampleStart = '''
<table class="tablesorter">
	<thead>
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Manufacturer</th>
			<th>Barcode</th>
		</tr>
	</thead>
	<tbody>''';
const htmlSampleMid = '''
		<tr class="uhtt-view--goods-table-item">
			<td>4292982</td>
			<td>Dexter DVD the first season</td>
			<td></td>
			<td>9324915073425</td>
		</tr>
''';
const htmlSampleEnd = '''
	</tbody>
</table>
''';

const intermediateMapList = [
  {
    'description': 'Dexter DVD the first season',
    'cleandescription': 'dexter the',
    'barcode': '9324915073425',
  }
];
