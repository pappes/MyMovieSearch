Future<Stream<String>> streamHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleFull = '$htmlSampleStart$htmlSampleMid$htmlSampleEnd';
const htmlSampleEmpty = '$htmlSampleStart$htmlSampleMidEmpty$htmlSampleEnd';
const htmlSampleError = '$htmlSampleStart$htmlSampleEnd';
const htmlSampleStart = '''
<!DOCTYPE html>
<html
    xmlns:snip=true>
    
    </snip>
  
  <body id="styleguide-v2" class="fixed">
  
   <div class="lister-list">''';
const htmlSampleEnd = '''
</div>
  </body>
  </html>
''';

const intermediateMapList = [
  {
    'name': '2001 A Space Odyssey (1968) [BluRay] [1080p] [YTS AM] � Movies',
    'url':
        'https://www.torrentdownload.info/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7/2001-A-Space-Odyssey-+1968+-+BluRay+-+1080p+-+YTS-AM+',
    'description': '2.38 GB',
    'seeders': '578',
    'leechers': '248',
  },
];

const htmlSampleMidEmpty = '<br><h2>No Results Found</h2><br>';
const htmlSampleMid = '''
<table class="table2" cellspacing="0">
    <tbody>
        <tr>
            <td class="tdleft">
                <div class="tt-name"><a
                        href="/A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7/2001-A-Space-Odyssey-+1968+-+BluRay+-+1080p+-+YTS-AM+">2001
                        A <span class="na">Space</span> Odyssey (1968) [BluRay] [1080p] [YTS AM]</a> <span
                        class="smallish"> � Movies</span></div>
                <div class="tt-options"></div>
            </td>
            <td class="tdnormal">1 Year+</td>
            <td class="tdnormal">2.38 GB</td>
            <td class="tdseed">578</td>
            <td class="tdleech">248</td>
        </tr>
    </tbody>
</table>
''';
