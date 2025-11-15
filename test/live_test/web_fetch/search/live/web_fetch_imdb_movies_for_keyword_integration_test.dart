import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/imdb_movies_for_keyword.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
r'''
{"uniqueId":"tt0033467","title":"Citizen Kane","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1941","yearRange":"1941","runTime":"7140","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0033467"}}
''',
r'''
{"uniqueId":"tt0037008","title":"Laura","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.series","year":"1944","yearRange":"1944","runTime":"5280","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0037008"}}
''',
r'''
{"uniqueId":"tt0057427","title":"The Trial","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Le procès","type":"MovieContentType.title","year":"1962","yearRange":"1962","runTime":"7140","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0057427"}}
''',
r'''
{"uniqueId":"tt0058329","title":"Marnie","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1964","yearRange":"1964","runTime":"7800","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0058329"}}
''',
r'''
{"uniqueId":"tt0066769","title":"The Andromeda Strain","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1971","yearRange":"1971","runTime":"7860","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0066769"}}
''',
r'''
{"uniqueId":"tt0069467","title":"Cries and Whispers","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Viskningar och rop","type":"MovieContentType.title","year":"1972","yearRange":"1972","runTime":"5520","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0069467"}}
''',
r'''
{"uniqueId":"tt0070917","title":"The Wicker Man","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1973","yearRange":"1973","runTime":"5280","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0070917"}}
''',
r'''
{"uniqueId":"tt0071360","title":"The Conversation","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1974","yearRange":"1974","runTime":"6780","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0071360"}}
''',
r'''
{"uniqueId":"tt0073453","title":"Night Moves","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1975","yearRange":"1975","runTime":"6000","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0073453"}}
''',
r'''
{"uniqueId":"tt0073580","title":"The Passenger","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Professione: reporter","type":"MovieContentType.title","year":"1975","yearRange":"1975","runTime":"7560","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0073580"}}
''',
r'''
{"uniqueId":"tt0074811","title":"The Tenant","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Le locataire","type":"MovieContentType.title","year":"1976","yearRange":"1976","runTime":"7560","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0074811"}}
''',
r'''
{"uniqueId":"tt0082085","title":"Blow Out","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1981","yearRange":"1981","runTime":"6480","censorRating":"CensorRatingType.adult","sources":{"DataSourceType.imdbKeywords":"tt0082085"}}
''',
r'''
{"uniqueId":"tt0098936","title":"Twin Peaks","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.series","year":"1990","yearRange":"1990-1991","runTime":"3000","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0098936"}}
''',
r'''
{"uniqueId":"tt0099871","title":"Jacob's Ladder","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1990","yearRange":"1990","runTime":"6780","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0099871"}}
''',
r'''
{"uniqueId":"tt0105665","title":"Twin Peaks: Fire Walk with Me","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1992","yearRange":"1992","runTime":"8040","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0105665"}}
''',
r'''
{"uniqueId":"tt0109665","title":"Dream Lover","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1994","yearRange":"1994","runTime":"6180","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0109665"}}
''',
r'''
{"uniqueId":"tt0114814","title":"The Usual Suspects","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1995","yearRange":"1995","runTime":"6360","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0114814"}}
''',
r'''
{"uniqueId":"tt0120176","title":"The Spanish Prisoner","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1997","yearRange":"1997","runTime":"6600","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0120176"}}
''',
r'''
{"uniqueId":"tt0125664","title":"Man on the Moon","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"1999","yearRange":"1999","runTime":"7080","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0125664"}}
''',
r'''
{"uniqueId":"tt0156887","title":"Perfect Blue","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Pâfekuto burû","type":"MovieContentType.title","year":"1997","yearRange":"1997","runTime":"4920","censorRating":"CensorRatingType.restricted","sources":{"DataSourceType.imdbKeywords":"tt0156887"}}
''',
r'''
{"uniqueId":"tt0161081","title":"What Lies Beneath","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2000","yearRange":"2000","runTime":"7800","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0161081"}}
''',
r'''
{"uniqueId":"tt0166924","title":"Mulholland Drive","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Mulholland Dr.","type":"MovieContentType.title","year":"2001","yearRange":"2001","runTime":"8820","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0166924"}}
''',
r'''
{"uniqueId":"tt0246578","title":"Donnie Darko","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2001","yearRange":"2001","runTime":"6780","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0246578"}}
''',
r'''
{"uniqueId":"tt0252501","title":"Hearts in Atlantis","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2001","yearRange":"2001","runTime":"6060","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0252501"}}
''',
r'''
{"uniqueId":"tt0272152","title":"K-PAX","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2001","yearRange":"2001","runTime":"7200","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0272152"}}
''',
r'''
{"uniqueId":"tt0324133","title":"Swimming Pool","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2003","yearRange":"2003","runTime":"6120","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0324133"}}
''',
r'''
{"uniqueId":"tt0337876","title":"Birth","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2004","yearRange":"2004","runTime":"6000","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0337876"}}
''',
r'''
{"uniqueId":"tt0348593","title":"The Door in the Floor","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2004","yearRange":"2004","runTime":"6660","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0348593"}}
''',
r'''
{"uniqueId":"tt0365686","title":"Revolver","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2005","yearRange":"2005","runTime":"6660","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0365686"}}
''',
r'''
{"uniqueId":"tt0368794","title":"I'm Not There","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.custom","year":"2007","yearRange":"2007","runTime":"8100","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0368794"}}
''',
r'''
{"uniqueId":"tt0454848","title":"Inside Man","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2006","yearRange":"2006","runTime":"7740","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0454848"}}
''',
r'''
{"uniqueId":"tt0460829","title":"Inland Empire","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2006","yearRange":"2006","runTime":"10800","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0460829"}}
''',
r'''
{"uniqueId":"tt0481369","title":"The Number 23","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2007","yearRange":"2007","runTime":"5880","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt0481369"}}
''',
r'''
{"uniqueId":"tt0945513","title":"Source Code","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2011","yearRange":"2011","runTime":"5580","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt0945513"}}
''',
r'''
{"uniqueId":"tt0970179","title":"Hugo","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2011","yearRange":"2011","runTime":"7560","censorRating":"CensorRatingType.kids","sources":{"DataSourceType.imdbKeywords":"tt0970179"}}
''',
r'''
{"uniqueId":"tt1008108","title":"Ashes to Ashes","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.series","year":"2008","yearRange":"2008-2010","runTime":"3600","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt1008108"}}
''',
r'''
{"uniqueId":"tt10731256","title":"Don't Worry Darling","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2022","yearRange":"2022","runTime":"7380","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt10731256"}}
''',
r'''
{"uniqueId":"tt13444912","title":"The Midnight Club","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.series","year":"2022","yearRange":"2022-2022","runTime":"3600","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt13444912"}}
''',
r'''
{"uniqueId":"tt1518812","title":"Meek's Cutoff","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2010","yearRange":"2010","runTime":"6240","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt1518812"}}
''',
r'''
{"uniqueId":"tt1924396","title":"Deception","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"La migliore offerta","type":"MovieContentType.title","year":"2013","yearRange":"2013","runTime":"7860","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt1924396"}}
''',
r'''
{"uniqueId":"tt2084970","title":"The Imitation Game","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2014","yearRange":"2014","runTime":"6840","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt2084970"}}
''',
r'''
{"uniqueId":"tt2365580","title":"Where'd You Go, Bernadette","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2019","yearRange":"2019","runTime":"6540","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt2365580"}}
''',
r'''
{"uniqueId":"tt2452254","title":"Clouds of Sils Maria","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2014","yearRange":"2014","runTime":"7440","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt2452254"}}
''',
r'''
{"uniqueId":"tt3262342","title":"Loving Vincent","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2017","yearRange":"2017","runTime":"5640","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt3262342"}}
''',
  r'''
{"uniqueId":"tt3286052","title":"February","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2015","yearRange":"2015","runTime":"5580","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt3286052"}}
''',
r'''
{"uniqueId":"tt3289956","title":"The Autopsy of Jane Doe","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2016","yearRange":"2016","runTime":"5160","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt3289956"}}
''',
r'''
{"uniqueId":"tt3387648","title":"The Taking","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2014","yearRange":"2014","runTime":"5400","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt3387648"}}
''',
r'''
{"uniqueId":"tt3613454","title":"Terror in Resonance","bestSource":"DataSourceType.imdbKeywords","alternateTitle":"Zankyô no teroru","type":"MovieContentType.series","year":"2014","yearRange":"2014-2014","runTime":"1380","censorRating":"CensorRatingType.family","sources":{"DataSourceType.imdbKeywords":"tt3613454"}}
''',
r'''
{"uniqueId":"tt6160448","title":"White Noise","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.title","year":"2022","yearRange":"2022","runTime":"8160","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt6160448"}}
''',
r'''
{"uniqueId":"tt9642938","title":"Unsolved Mysteries","bestSource":"DataSourceType.imdbKeywords","type":"MovieContentType.episode","year":"2020","yearRange":"2020","runTime":"2700","censorRating":"CensorRatingType.mature","sources":{"DataSourceType.imdbKeywords":"tt9642938"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryIMDBMoviesForKeyword test', () {
    // Search for a rare movie.
    test('Run a keyword search on IMDB that is likely to have static results',
        () async {
      final criteria = SearchCriteriaDTO().fromString('enigma');
      final actualOutput =
          await QueryIMDBMoviesForKeyword(criteria).readList(limit: 10);
      final expectedOutput = expectedDTOList;
      expectedDTOList.clearCopyrightedData();
      actualOutput.clearCopyrightedData();

      // Uncomment this line to update expectedOutput if sample data changes
      // printTestData(actualOutput);

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListFuzzyMatcher(
          expectedOutput,
          percentMatch: 60,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
    test('Run an empty search', () async {
      final criteria = SearchCriteriaDTO().fromString('therearenoresultszzzz');
      final actualOutput =
          await QueryIMDBMoviesForKeyword(criteria).readList(limit: 10);
      final expectedOutput = <MovieResultDTO>[];

      // Check the results.
      expect(
        actualOutput,
        MovieResultDTOListMatcher(
          expectedOutput,
        ),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list '
            '${expectedOutput.toPrintableString()}',
      );
    });
  });
}
