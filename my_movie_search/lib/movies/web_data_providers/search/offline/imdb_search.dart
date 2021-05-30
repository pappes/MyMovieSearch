import 'dart:async';

//query string https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=wonder%20woman

final imdbHtmlSampleInner = r'''
<tr class="findResult odd">
  <td class="primary_photo"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1"><img src="https://m.media-amazon.com/images/M/MV5BMTYzODQzYjQtNTczNC00MzZhLTg1ZWYtZDUxYmQ3ZTY4NzA1XkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0451279/?ref_=fn_tt_tt_1">Wonder Woman</a> (2017) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2"><img src="https://m.media-amazon.com/images/M/MV5BZjAxYTcxMDUtZTRmMi00NTk3LThkZTItNGNlZTQ3NWRhMjY5XkEyXkFqcGdeQXVyNjExODE1MDc@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt0074074/?ref_=fn_tt_tt_2">Wonder Woman</a> (1975) (TV Series) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3"><img src="https://m.media-amazon.com/images/M/MV5BMjA0MzYzNzY3OV5BMl5BanBnXkFtZTcwMzM4ODM4NA@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt1740828/?ref_=fn_tt_tt_3">Wonder Woman</a> (2011) (TV Movie) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4"><img src="https://m.media-amazon.com/images/M/MV5BYTlhNzJjYzYtNGU3My00ZDI5LTgzZDUtYzllYjU1ZmU0YTgwXkEyXkFqcGdeQXVyMjQwMDg0Ng@@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt7126948/?ref_=fn_tt_tt_4">Wonder Woman 1984</a> (2020) </td> 
</tr>
<tr class="findResult odd"> 
  <td class="primary_photo"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5"><img src="https://m.media-amazon.com/images/M/MV5BZTkyNmMzMTEtZTNjMC00NTg4LWJlNTktZDdmNzE1M2YxN2E4XkEyXkFqcGdeQXVyNzU3NjUxMzE@._V1_UX32_CR0,0,32,44_AL_.jpg"></a> </td> 
  <td class="result_text"> <a href="/title/tt8752498/?ref_=fn_tt_tt_5">Wonder Woman: Bloodlines</a> (2019) </td> 
</tr>
<tr class="findResult even"> 
  <td class="primary_photo"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6"><img src="https://m.media-amazon.com/images/S/sash/85lhIiFCmSScRzu.png"></a> </td> 
  <td class="result_text"> <a href="/title/tt13722802/?ref_=fn_tt_tt_6">Wonder Woman 3</a> </td> 
</tr>
''';

final imdbHtmlSampleFull = '''
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
$imdbHtmlSampleInner
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

Stream<String> streamImdbHtmlOfflineData(String dummy) {
  return emitImdbHtmlSample(dummy);
}

Stream<String> emitImdbHtmlSample(String dummy) async* {
  yield imdbHtmlSampleFull;
}
