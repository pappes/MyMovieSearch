// ignore_for_file: unnecessary_raw_strings

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

/* To update this data run
       print(actualResult.toListOfDartJsonStrings(excludeCopyrightedData:false));
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt0218354","bestSource":"DataSourceType.imdbKeywords","title":"The Catgirl<3","type":"MovieContentType.title","year":"2010","yearRange":"(2003–2010)","languages":"[]","genres":"[]","keywords":"[]",
      "description":"Then Kramer said, \"Everybody is Mescalon Smoochington\"<3",
      "userRating":"5.999","userRatingCount":"644","censorRating":"CensorRatingType.mature","imageUrl":"https://m.media-amazon.com/images/M/MV5BOWI5MzNiY2QyNTA4NzExMDg@._V1_UY98_CR32,0,67,98_AL_.jpg","sources":{"DataSourceType.imdbKeywords":"tt0218354"},"related":{}}
''',
];
final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

Future<Stream<String>> streamImdbKeywordsHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitImdbKeywordsHtmlSample(dummy));
}

Stream<String> _emitImdbKeywordsHtmlSample(_) async* {
  yield imdbKeywordsHtmlSampleFull;
}

const imdbKeywordsHtmlSampleFull =
    '$imdbKeywordsHtmlSampleStart$imdbSampleMid$imdbKeywordsHtmlSampleEnd';
const imdbKeywordsHtmlSampleStart = '''

<!DOCTYPE html>
<html
    xmlns:snip=true>
    
    </snip>
  
  <body id="styleguide-v2" class="fixed">
  
   <div class="lister-list">''';
const imdbKeywordsHtmlSampleEnd = '''

</div>
    
  
  </body>
  </html>
''';

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
    'titlePopulartyRatingCount': '644',
    'titleDuration': '61 min',
    'directors': null,
    'topCredits': null,
    'keywords': null
  }
];

const imdbSampleMid = '''
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
        <p class="text-muted">
            Then Kramer said, "Everybody is Mescalon Smoochington"&lt;3
        </p>

        <p class="">
            Director:
            <a href="/name/nm0311837/?ref_=kw_li_dr_0">Vonuck Heint
            </a>
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
        <p class="sort-num_votes-visible">
            <span name="nv" data-value="644">644
            </span>
        </p>
    </div>
</div>''';
