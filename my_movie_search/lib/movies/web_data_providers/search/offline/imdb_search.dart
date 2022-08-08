//query string https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=wonder%20woman

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  '{"source": "imdbSearch", "uniqueId": "tt0451279", "title": "Search Woman", "year": "2017", "yearRange": "2017", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BMTYz...GdeQXVyODE5NzE3OTE@._V1_UX32_CR0,0,32,44_AL_.jpg", "related": {}}',
  '{"source": "imdbSearch", "uniqueId": "tt0074074", "title": "Search Woman", "type": "series", "year": "1975", "yearRange": "1975", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BZjA...XkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg", "related": {}}',
  '{"source": "imdbSearch", "uniqueId": "tt1740828", "title": "Search Woman", "type": "movie", "year": "2011", "yearRange": "2011", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5B...zM4ODM4NA@@._V1_UX32_CR0,0,32,44_AL_.jpg", "related": {}}',
  '{"source": "imdbSearch", "uniqueId": "tt7126948", "title": "Search Woman 1984", "year": "2020", "yearRange": "2020", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BYT...QXVyMjQwMDg0Ng@@._V1_UX32_CR0,0,32,44_AL_.jpg", "related": {}}',
  '{"source": "imdbSearch", "uniqueId": "tt8752498", "title": "Search Woman: Bloodlines", "year": "2019", "yearRange": "2019", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/M/MV5BZTkyNmMz...GdeQXVyNzU3NjUxMzE@._V1_UX32_CR0,0,32,44_AL_.jpg", "related": {}}',
  '{"source": "imdbSearch", "uniqueId": "tt13722802", "title": "Search Woman 3", "languages": [], "genres": [], "keywords": [], "imageUrl": "https://m.media-amazon.com/images/S/sash/85lhIiFC....mSScRzu.png", "related": {}}',
];

const intermediateMapList = [
  {
    "Image":
        "https://m.media-amazon.com/images/M/MV5BMTYz...GdeQXVyODE5NzE3OTE@._V1_UX32_CR0,0,32,44_AL_.jpg",
    "Info": " Search Woman (2017) ",
    "AnchorAddress": "/title/tt0451279/?ref_=fn_tt_tt_1",
    "Title": "Search Woman"
  },
  {
    "Image":
        "https://m.media-amazon.com/images/M/MV5BZjA...XkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg",
    "Info": " Search Woman (1975) (TV Series) ",
    "AnchorAddress": "/title/tt0074074/?ref_=fn_tt_tt_2",
    "Title": "Search Woman"
  },
  {
    "Image":
        "https://m.media-amazon.com/images/M/MV5B...zM4ODM4NA@@._V1_UX32_CR0,0,32,44_AL_.jpg",
    "Info": " Search Woman (2011) (TV Movie) ",
    "AnchorAddress": "/title/tt1740828/?ref_=fn_tt_tt_3",
    "Title": "Search Woman"
  },
  {
    "Image":
        "https://m.media-amazon.com/images/M/MV5BYT...QXVyMjQwMDg0Ng@@._V1_UX32_CR0,0,32,44_AL_.jpg",
    "Info": " Search Woman 1984 (2020) ",
    "AnchorAddress": "/title/tt7126948/?ref_=fn_tt_tt_4",
    "Title": "Search Woman 1984"
  },
  {
    "Image":
        "https://m.media-amazon.com/images/M/MV5BZTkyNmMz...GdeQXVyNzU3NjUxMzE@._V1_UX32_CR0,0,32,44_AL_.jpg",
    "Info": " Search Woman: Bloodlines (2019) ",
    "AnchorAddress": "/title/tt8752498/?ref_=fn_tt_tt_5",
    "Title": "Search Woman: Bloodlines"
  },
  {
    "Image": "https://m.media-amazon.com/images/S/sash/85lhIiFC....mSScRzu.png",
    "Info": " Search Woman 3 ",
    "AnchorAddress": "/title/tt13722802/?ref_=fn_tt_tt_6",
    "Title": "Search Woman 3"
  },
];

const imdbSearchHtmlSampleInner = '''
<tr class="findResult odd">
  <td class="primary_photo"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1"><img src="https://m.media-amazon.com/images/M/MV5BMTYz...GdeQXVyODE5NzE3OTE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1">Search Woman</a> (2017) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2"><img src="https://m.media-amazon.com/images/M/MV5BZjA...XkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2">Search Woman</a> (1975) (TV Series) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3"><img src="https://m.media-amazon.com/images/M/MV5B...zM4ODM4NA@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3">Search Woman</a> (2011) (TV Movie) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4"><img src="https://m.media-amazon.com/images/M/MV5BYT...QXVyMjQwMDg0Ng@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4">Search Woman 1984</a> (2020) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5"><img src="https://m.media-amazon.com/images/M/MV5BZTkyNmMz...GdeQXVyNzU3NjUxMzE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5">Search Woman: Bloodlines</a> (2019) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6"><img src="https://m.media-amazon.com/images/S/sash/85lhIiFC....mSScRzu.png"></a> </td> 
  <td class="result_text"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6">Search Woman 3</a> </td> 
</tr>
''';

const imdbSearchHtmlSampleFull = '''
<!DOCTYPE html>
<html
    xmlns:snip=true>
    </snip>
  <body id="styleguide-v2" class="fixed">
    <div id="wrapper">
      <div id="root" class="redesign">
        <div id="pagecontent" class="pagecontent">
          <div id="content-2-wide">
            <div id="main">
              <div class="article">
                <div  class="findSection">
                  <table class="findList">
                    <tbody> 
$imdbSearchHtmlSampleInner
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
''';

Future<Stream<String>> streamImdbSearchHtmlOfflineData(dynamic dummy) {
  return Future.value(_emitImdbSearchHtmlSample(dummy));
}

Stream<String> _emitImdbSearchHtmlSample(_) async* {
  yield imdbSearchHtmlSampleFull;
}
