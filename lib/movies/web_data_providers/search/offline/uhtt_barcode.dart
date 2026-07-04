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
  },
];
