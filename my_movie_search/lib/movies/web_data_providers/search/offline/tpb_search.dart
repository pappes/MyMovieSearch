// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"/title/tt0218354/?ref_=kw_li_tt","bestSource":"DataSourceType.tpb","title":"The Catgirl<3","type":"MovieContentType.series","year":"2010","yearRange":"2003–2010",
      "keywords":"[\"dream\"]",
      "description":"Then Kramer said, \"Everybody is Mescalon Smoochington\"<3",
      "userRating":"5.999","userRatingCount":"374","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWI5MzNiY2QyNTA4NzExMDg@._V1_UY98_CR32,0,67,98_AL_.jpg","sources":{"DataSourceType.tpb":"/title/tt0218354/?ref_=kw_li_tt"}}
''',
  r'''
{"uniqueId":"https://tpb.party/search/dream/1/99/0?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main","bestSource":"DataSourceType.tpb","title":"Next »",
      "keywords":"[\"dream\"]",
      "description":"{ \"keyword\":\"dream\", \"page\":\"2\", \"url\":\"https://tpb.party/search/dream/1/99/0?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main\"}","sources":{"DataSourceType.tpb":"https://tpb.party/search/dream/1/99/0?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main"}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamTpbHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitTpbHtmlSample(dummy));
}

Stream<String> _emitTpbHtmlSample(_) async* {
  yield tpbSampleFull;
}

const tpbSampleFull = '$tpbHtmlSampleStart$tpbSampleMid$tpbHtmlSampleEnd';
const tpbHtmlSampleStart = '''

<!DOCTYPE html>
<html
    xmlns:snip=true>
    
    </snip>
  
  <body id="styleguide-v2" class="fixed">
  
   <div class="lister-list">''';
const tpbHtmlSampleEnd = '''

</div>
    
  
  </body>
  </html>
''';

const intermediateMapList = [
  {
    'id': '/title/tt0218354/?ref_=kw_li_tt',
    'titleNameText': 'The Catgirl<3',
    'titleDescription':
        'Then Kramer said, "Everybody is Mescalon Smoochington"<3',
    'titleImage':
        'https://m.media-amazon.com/images/M/MV5BOWI5MzNiY2QyNTA4NzExMDg@._V1_UY98_CR32,0,67,98_AL_.jpg',
    'titleReleaseText': '(2003–2010)',
    'titleInfo': '(2003–2010)',
    'titleCensorRating': 'M',
    'titlePopulartyRating': '5.999',
    'titlePopulartyRatingCount': '374',
    'titleDuration': '61 min',
    'directors':
        '{"Vonuck Heint\\n            ":"/name/nm0311837/?ref_=kw_li_dr_0"}',
    'topCredits':
        '{"Rano Romino\\n            ":"/name/nm0718931/?ref_=kw_li_st_0","Eara Sabvan\\n            ":"/name/nm0714533/?ref_=kw_li_st_1","Ataircan Dunlas\\n            ":"/name/nm0211835/?ref_=kw_li_st_2","Tnny Keom \\n            ":"/name/nm0414736/?ref_=kw_li_st_3"}',
    'keywords': 'dream'
  },
  {
    'id':
        'https://tpb.party/search/dream/1/99/0?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main',
    'titleNameText': 'Next »',
    'keywords': 'dream',
    'titleDescription':
        '{ "keyword":"dream", "page":"2", "url":"https://tpb.party/search/dream/1/99/0?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main"}'
  },
];

const tpbSampleMid = r'''
<div class="lister-item mode-advanced">
    <div class="lister-item-image float-left">
          <img src="https://m.media-amazon.com/images/M/MV5BOWI5MzNiY2QyNTA4NzExMDg@._V1_UY98_CR32,0,67,98_AL_.jpg">
    </div>
    <div class="lister-item-content">
        <h3 class="lister-item-header">
            <a href="/title/tt0218354/?ref_=kw_li_tt"> The Catgirl&lt;3
            </a>
            <span class="lister-item-year text-muted unbold">(2003–2010)
            </span>
        </h3>
        <p class="text-muted ">
            <span class="certificate">M
            </span>
            <span class="runtime">61 min
            </span>
            <span class="genre">
                Horror, Action, Comedy
            </span>
        </p>
        <div class="ratings-bar">
              <strong>5.999
              </strong>
        </div>
        <p class="">
            Then Kramer said, "Everybody is Mescalon Smoochington"&lt;3
        </p>

        <p class="text-muted">
            Director:
            <a href="/name/nm0311837/?ref_=kw_li_dr_0">Vonuck Heint
            </a>
            <span class="ghost">|</span>
            Stars:
            <a href="/name/nm0718931/?ref_=kw_li_st_0">Rano Romino
            </a>,
            <a href="/name/nm0714533/?ref_=kw_li_st_1">Eara Sabvan
            </a>,
            <a href="/name/nm0211835/?ref_=kw_li_st_2">Ataircan Dunlas
            </a>,
            <a href="/name/nm0414736/?ref_=kw_li_st_3">Tnny Keom 
            </a>
        </p>
        <p class="text-muted text-small">
                <span class="text-muted">Votes:</span>
                <span name="nv" data-value="374">374</span>
                <span class="ghost">|</span>                
                <span class="text-muted">Gross:</span>
                <span name="nv" data-value="9,600">$9.6K</span>
            
        </p>
    </div>
    <a href="?page=2&amp;sort=moviemeter,asc&amp;keywords=dream&amp;explore=keywords&amp;mode=detail&amp;ref_=kw_nxt#main" class="lister-page-next next-page" ref-marker="kw_nxt">Next »</a>
</div>''';
