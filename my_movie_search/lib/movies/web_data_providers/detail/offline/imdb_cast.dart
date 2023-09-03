import 'package:my_movie_search/movies/models/movie_result_dto.dart';
// ignore_for_file: unnecessary_raw_strings

//query string https://www.imdb.com/title/tt0106977/fullcredits?ref_=tt_ov_st_sm

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);

/* To update this data, uncomment printTestData(actualResult);
in test('Run dtoFromCompleteJsonMap()'*/
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"tt7602562","bestSource":"DataSourceType.imdbSuggestions","type":"MovieContentType.title","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"tt7602562"},
  "related":{"Directed by:":{"nm0001112":{"uniqueId":"nm0001112","bestSource":"DataSourceType.imdbSuggestions","title":"Andrew Davis","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0001112"},"related":{}}},
    "Writing Credits:":{"nm0835732":{"uniqueId":"nm0835732","bestSource":"DataSourceType.imdbSuggestions","title":"Jeb Stuart","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0835732"},"related":{}},
      "nm0878638":{"uniqueId":"nm0878638","bestSource":"DataSourceType.imdbSuggestions","title":"David Twohy","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0878638"},"related":{}},
      "nm0400403":{"uniqueId":"nm0400403","bestSource":"DataSourceType.imdbSuggestions","title":"Roy Huggins","type":"MovieContentType.person","creditsOrder":"97","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0400403"},"related":{}}},
    "Cast:":{"nm0000148":{"uniqueId":"nm0000148","bestSource":"DataSourceType.imdbSuggestions","title":"Harrison Ford","charactorName":"Dr. Richard Kimble","type":"MovieContentType.person","creditsOrder":"100","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0000148"},"related":{}},
      "nm0000169":{"uniqueId":"nm0000169","bestSource":"DataSourceType.imdbSuggestions","title":"Tommy Lee Jones","charactorName":"Samuel Gerard","type":"MovieContentType.person","creditsOrder":"99","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0000169"},"related":{}},
      "nm0000688":{"uniqueId":"nm0000688","bestSource":"DataSourceType.imdbSuggestions","title":"Sela Ward","charactorName":"Helen Kimble","type":"MovieContentType.person","creditsOrder":"98","languages":"[]","genres":"[]","keywords":"[]","sources":{"DataSourceType.imdbSuggestions":"nm0000688"},"related":{}}}}}
''',
];

const intermediateMapList = [
  {
    "Directed by:": [
      {"name": "Andrew Davis", "url": "/name/nm0001112/?ref_=ttfc_fc_dr1"},
    ],
    "Writing Credits:": [
      {"name": "Jeb Stuart", "url": "/name/nm0835732/?ref_=ttfc_fc_wr1"},
      {"name": "David Twohy", "url": "/name/nm0878638/?ref_=ttfc_fc_wr2"},
      {"name": "David Twohy", "url": '''/name/nm0878638/?ref_=ttfc_fc_wr3'''},
      {"name": "Roy Huggins", "url": "/name/nm0400403/?ref_=ttfc_fc_wr4"},
    ],
    "Cast:": [
      {
        "name": "Harrison Ford",
        "url": "/name/nm0000148/?ref_=ttfc_fc_cl_t1",
        "charactorName": "Dr. Richard Kimble",
      },
      {
        "name": "Tommy Lee Jones",
        "url": "/name/nm0000169/?ref_=ttfc_fc_cl_t2",
        "charactorName": "Samuel Gerard",
      },
      {
        "name": "Sela Ward",
        "url": "/name/nm0000688/?ref_=ttfc_fc_cl_t3",
        "charactorName": "Helen Kimble",
      },
    ],
    "id": "tt7602562",
  }
];

const imdbHtmlSampleInner = '''
    <div id="fullcredits_content" class="header">

    <h4
      name="director" id="director"
      class="dataHeaderWithBorder">Directed by&nbsp;</h4>
    <table class="simpleTable simpleCreditsTable">
    <colgroup>
      <col class="column1">
      <col class="column2">
      <col class="column3">
    </colgroup>
    <tbody>
       
        <tr>
        <td class="name">
<a href="/name/nm0001112/?ref_=ttfc_fc_dr1"
> Andrew Davis
</a>        </td>
          <td colspan="2"></td>
        </tr>
    </tbody>
    </table>
    <h4 name="writer" id="writer" class="dataHeaderWithBorder">Writing Credits
<span>(<a href="https://help.imdb.com/article/imdb/general-information/imdb-partners/G8TZTG4LR6ZV4LXZ?ref_=cons_tt_writer_wga#GVTJ2XVZFGX5YDW9"
>WGA</a>)</span>    &nbsp;
    </h4>
    <table class="simpleTable simpleCreditsTable">
    <colgroup>
      <col class="column1">
      <col class="column2">
      <col class="column3">
    </colgroup>
    <tbody>
        <tr>
          <td class="name">
<a href="/name/nm0835732/?ref_=ttfc_fc_wr1"
> Jeb Stuart
</a>          </td>
            <td>...</td>
            <td class="credit">
              (screenplay) and
            </td>
        </tr>
        <tr>
          <td class="name">
<a href="/name/nm0878638/?ref_=ttfc_fc_wr2"
> David Twohy
</a>          </td>
            <td>...</td>
            <td class="credit">
              (screenplay)
            </td>
        </tr>
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr>
          <td class="name">
<a href="/name/nm0878638/?ref_=ttfc_fc_wr3"
> David Twohy
</a>          </td>
            <td>...</td>
            <td class="credit">
              (story)
            </td>
        </tr>
        <tr><td colspan="3">&nbsp;</td></tr>
        <tr>
          <td class="name">
<a href="/name/nm0400403/?ref_=ttfc_fc_wr4"
> Roy Huggins
</a>          </td>
            <td>...</td>
            <td class="credit">
              (characters)
            </td>
        </tr>
    </tbody>
    </table>
    <h4 name="cast" id="cast" class="dataHeaderWithBorder">
      
      Cast
          <span>(in credits order)</span>
        <span> verified as complete </span>
    &nbsp;
    </h4>
    <table class="cast_list">
  <tr><td colspan="4" class="castlist_label"></td></tr>
      <tr class="odd">
          <td class="primary_photo">
<a href="/name/nm0000148/?ref_=ttfc_fc_cl_i1"
><img height="44" width="32" alt="Harrison Ford" title="Harrison Ford" src="https://m.media-amazon.com/images/S/sash/N1QWYSqAfSJV62Y.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTY4Mjg0NjIxOV5BMl5BanBnXkFtZTcwMTM2NTI3MQ@@._V1_UX32_CR0,0,32,44_AL_.jpg" /></a>          </td>
          <td>
<a href="/name/nm0000148/?ref_=ttfc_fc_cl_t1"
> Harrison Ford
</a>          </td>
          <td class="ellipsis">
              ...
          </td>
          <td class="character">
            <a href="/title/tt0106977/characters/nm0000148?ref_=ttfc_fc_cl_t1" >Dr. Richard Kimble</a> 
                  
          </td>
      </tr>
      <tr class="even">
          <td class="primary_photo">
<a href="/name/nm0000169/?ref_=ttfc_fc_cl_i2"
><img height="44" width="32" alt="Tommy Lee Jones" title="Tommy Lee Jones" src="https://m.media-amazon.com/images/S/sash/N1QWYSqAfSJV62Y.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTkyNjc4MDc0OV5BMl5BanBnXkFtZTcwOTc5OTUwOQ@@._V1_UX32_CR0,0,32,44_AL_.jpg" /></a>          </td>
          <td>
<a href="/name/nm0000169/?ref_=ttfc_fc_cl_t2"
> Tommy Lee Jones
</a>          </td>
          <td class="ellipsis">
              ...
          </td>
          <td class="character">
            <a href="/title/tt0106977/characters/nm0000169?ref_=ttfc_fc_cl_t2" >Samuel Gerard</a> 
                  
          </td>
      </tr>
      <tr class="odd">
          <td class="primary_photo">
<a href="/name/nm0000688/?ref_=ttfc_fc_cl_i3"
><img height="44" width="32" alt="Sela Ward" title="Sela Ward" src="https://m.media-amazon.com/images/S/sash/N1QWYSqAfSJV62Y.png" class="loadlate hidden " loadlate="https://m.media-amazon.com/images/M/MV5BMTZlZDE3YzAtNGZiMi00YTA4LTk0MGUtZDkxNTY0MzQ0YzEwXkEyXkFqcGdeQXVyMTExNzQzMDE0._V1_UY44_CR17,0,32,44_AL_.jpg" /></a>          </td>
          <td>
<a href="/name/nm0000688/?ref_=ttfc_fc_cl_t3"
> Sela Ward
</a>          </td>
          <td class="ellipsis">
              ...
          </td>
          <td class="character">
            <a href="/title/tt0106977/characters/nm0000688?ref_=ttfc_fc_cl_t3" >Helen Kimble</a> 
                  
          </td>
      </tr>

    </table>

    </div>
  </div> 
''';

const imdbHtmlSampleStart = ' <!DOCTYPE html> <html     <head>'
    ' </head> <body id="styleguide-v2" class="fixed">';
const imdbHtmlSampleEnd = ' </body> </html>';
const imdbHtmlSampleFull =
    '$imdbHtmlSampleStart $imdbHtmlSampleInner $imdbHtmlSampleEnd';

Future<Stream<String>> streamImdbHtmlOfflineData(dynamic dummy) {
  return Future.value(emitImdbHtmlSample(dummy));
}

Stream<String> emitImdbHtmlSample(_) async* {
  yield imdbHtmlSampleFull;
}
