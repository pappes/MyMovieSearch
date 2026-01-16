// Raw data in code is generated from an external source.
// ignore_for_file: unnecessary_ignore
// ignore_for_file: unnecessary_raw_strings

Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleError = '$htmlSampleStart$htmlSampleEnd';
const htmlSampleEmpty = '$htmlSampleStart$htmlEmptySampleMid$htmlSampleEnd';
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

const htmlEmptySampleMid = 'No results found in Search Results.';

const htmlSampleMid = '''
<div class="cell_wrapper bgcolor-white nm-bgcolor-white has-hover DIRECT border-v">
  <div id="results_cell0" class="results_cell">
    <div class="displayDetailLink">
      <a title="Summer in February [DVD]." class="hideIE" id="detailLink0" href="#">Summer in February [DVD].</a>
    </div>
        <div class="displayElementText text-p highlightMe PUBDATE"> 2014
            2013</div>
    <div class="results_img_div">
      <a class="DISCOVERY_ALL listItem coverImageLink detailClick detailClick0" id="detailClick0" href="#">
        <img src="https://secure.syndetics.com/index.aspx?type=xw12&client=saplnsd&upc=9317731106354&oclc=&isbn=/LC.JPG" class="results_img" id="syndeticsImg0"></a>
    </div>
  </div>
</div>
''';

const intermediateMapList = [
  {
    'cleanDescription': 'Summer in February 2013',
    'rawDescription': 'Summer in February [DVD]. 2014 2013',
    'url':
        'https://secure.syndetics.com/index.aspx?type=xw12&client=saplnsd&upc=9317731106354&oclc=&isbn=/LC.JPG',
  }
];
