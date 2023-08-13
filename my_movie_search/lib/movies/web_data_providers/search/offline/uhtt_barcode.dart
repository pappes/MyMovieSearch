// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"9324915073425","bestSource":"DataSourceType.uhttBarcode","title":"Dexter DVD the first season","alternateTitle":"dexter the ","type":"MovieContentType.barcode",
      "description":"9324915073425","sources":{"DataSourceType.uhttBarcode":"9324915073425"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitHtmlSample(dummy));
}

Stream<String> _emitHtmlSample(_) async* {
  yield htmlSampleFull;
}

const htmlSampleFull = '''

<table >
	<thead>
		<tr>
			<th>ID</th>
			<th>Name</th>
			<th>Manufacturer</th>
			<th>Barcode</th>
		</tr>
	</thead>
	<tbody>
		<tr class="uhtt-view--goods-table-item">
			<td>4292982</td>
			<td>Dexter DVD the first season</td>
			<td></td>
			<td>9324915073425</td>
		</tr>
	</tbody>
</table>
''';

const intermediateMapList = [
  {
    'description': 'Dexter DVD the first season',
    'cleandescription': 'dexter the ',
    'barcode': '9324915073425'
  }
];

const htmlSampleMid = r'''
<div class="results">
    <dl>
        <dt><a href="http://solidtorrents.to/torrents/space-babes-from-outer-space-2017-1080p-bluray-x26-714eb/6287c8eb8fe14ca928dd7182/"
                target="_blank">Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG</a></dt>
        <dd><span><a href="magnet:?xt=urn:btih:799625568D3F7419095C2BA1B0CFA11607B1B259&amp;tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Fwww.torrent.eu.org%3A451%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.0x.tf%3A6969%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&amp;dn=%5BBitsearch.to%5D+Space.Babes.from.Outer.Space.2017.1080p.BluRay.x265-RARBG">
        <i class="fa-solid fa-magnet"></i></a></span><span title="1586352627">a year</span><span>1.36 GB</span><span>19</span><span>14</span></dd>
    </dl>
    <dl>
        <dt><a href="http://solidtorrents.to/torrents/space-babes-from-outer-space-2017-bdrip-x264-pegas-13f94/6287be8d8fe14ca928d93cda/"
                target="_blank">Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS[rarbg]</a></dt>
        <dd><span><a href="magnet:?xt=urn:btih:C84EF9E1D665729C7BC899BD37652572D84B03C1&amp;tr=udp%3A%2F%2Ftracker.bitsearch.to%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.zerobytes.xyz%3A1337%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.breizh.pm%3A6969%2Fannounce&amp;tr=udp%3A%2F%2F9.rarbg.com%3A2920%2Fannounce&amp;tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce&amp;dn=%5BBitsearch.to%5D+Space.Babes.From.Outer.Space.2017.BDRip.x264-PEGASUS%5Brarbg%5D">
        <iclass="fa-solid fa-magnet"></i></a></span><span title="1586352627">a year</span><span>880 MB</span><span>13</span><span>12</span></dd>
    </dl>

</div>
''';
