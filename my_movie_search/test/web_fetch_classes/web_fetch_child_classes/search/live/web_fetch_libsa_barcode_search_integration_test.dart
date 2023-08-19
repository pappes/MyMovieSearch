import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/libsa_barcode.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"https://secure.syndetics.com/index.aspx?type=xw12&client=saplnsd&upc=9317731106354&oclc=&isbn=/MC.GIF","bestSource":"DataSourceType.libsaBarcode","title":"Summer in February 2013","alternateTitle":"Summer in February [DVD]. 2014 2013","type":"MovieContentType.barcode","sources":{"DataSourceType.libsaBarcode":"https://secure.syndetics.com/index.aspx?type=xw12&client=saplnsd&upc=9317731106354&oclc=&isbn=/MC.GIF"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryLibsaBarcodeSearch test', () {
    // Search for a known movie.
    test('Run a search on libsa that will hopefully have static results',
        () async {
      final criteria = SearchCriteriaDTO().fromString('9317731106354');
      final actualOutput =
          await QueryLibsaBarcodeSearch(criteria).readList(limit: 10);
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
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
