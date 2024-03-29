// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main","bestSource":"DataSourceType.imdbKeywords","title":"Next »","type":"MovieContentType.navigation",
      "keywords":"[\"dream\"]",
      "description":"{ \"keyword\":\"dream\", \"page\":\"2\", \"url\":\"https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main\"}","sources":{"DataSourceType.imdbKeywords":"https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main"}}
''',
  r'''
{"uniqueId":"tt0218354","bestSource":"DataSourceType.imdbKeywords","title":"The Catgirl<3","type":"MovieContentType.series","year":"2010","yearRange":"2003–2010",
      "keywords":"[\"dream\"]",
      "description":"Then Kramer said, \"Everybody is Mescalon Smoochington\"<3",
      "userRating":"5.999","userRatingCount":"374","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWI5MzNiY2QyNTA4NzExMDg@._V1_UY98_CR32,0,67,98_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0218354"},
  "related":{"Cast:":{"nm0211835":{"uniqueId":"nm0211835","title":"Ataircan Dunlas\n            ","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0211835"}},
      "nm0414736":{"uniqueId":"nm0414736","title":"Tnny Keom \n            ","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0414736"}},
      "nm0714533":{"uniqueId":"nm0714533","title":"Eara Sabvan\n            ","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0714533"}},
      "nm0718931":{"uniqueId":"nm0718931","title":"Rano Romino\n            ","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0718931"}}},
    "Directed by:":{"nm0311837":{"uniqueId":"nm0311837","title":"Vonuck Heint\n            ","type":"MovieContentType.person","sources":{"DataSourceType.none":"nm0311837"}}}}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamImdbKeywordsHtmlOfflineData(_) =>
    Future.value(Stream.value(htmlSampleFull));

const htmlSampleEmpty = '$htmlSampleStart$imdbEmptySampleMid$htmlSampleEnd';
const htmlSampleFull = '$htmlSampleStart$imdbSampleMid$htmlSampleEnd';
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
const imdbEmptySampleMid = '<div class="lister-item"> '
    'No results. Try removing genres, ratings, or other filters to see more. '
    '</div>';

const intermediateMapList = [
  {
    'id': 'tt0218354',
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
        r'{"Vonuck Heint\n            ":"/name/nm0311837/?ref_=kw_li_dr_0"}',
    'topCredits':
        r'{"Rano Romino\n            ":"/name/nm0718931/?ref_=kw_li_st_0","Eara Sabvan\n            ":"/name/nm0714533/?ref_=kw_li_st_1","Ataircan Dunlas\n            ":"/name/nm0211835/?ref_=kw_li_st_2","Tnny Keom \n            ":"/name/nm0414736/?ref_=kw_li_st_3"}',
    'keywords': 'dream',
  },
  {
    'id':
        'https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main',
    'titleNameText': 'Next »',
    'keywords': 'dream',
    'titleDescription':
        '{ "keyword":"dream", "page":"2", "url":"https://www.imdb.com/search/keyword/?page=2&sort=moviemeter,asc&keywords=dream&explore=keywords&mode=detail&ref_=kw_nxt#main"}',
  },
];

const imdbSampleMid = r'''
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
