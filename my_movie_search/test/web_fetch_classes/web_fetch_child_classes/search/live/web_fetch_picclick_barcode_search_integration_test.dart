import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/picclick_barcode.dart';

import '../../../../test_helper.dart';

// ignore_for_file: unnecessary_raw_strings
////////////////////////////////////////////////////////////////////////////////
/// Read from real MagnetDb endpoint!
////////////////////////////////////////////////////////////////////////////////

final expectedDTOList = ListDTOConversion.decodeList(expectedDtoJsonStringList);
const expectedDtoJsonStringList = [
  r'''
{"uniqueId":"item-166207020874","bestSource":"DataSourceType.picclickBarcode","title":"Dexter Complete 1st and 2nd Season Region 4 PAL 2 DVD Box sets 8 Disc in Total","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-166207020874"}}
''',
  r'''
{"uniqueId":"item-204198538282","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-204198538282"}}
''',
  r'''
{"uniqueId":"item-204379004407","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-204379004407"}}
''',
  r'''
{"uniqueId":"item-225211746116","bestSource":"DataSourceType.picclickBarcode","title":"Dexter Season 1 🩸 R4 PAL 🩸 4 X DVD Boxed Set 🩸 V/G Condition ✅","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-225211746116"}}
''',
  r'''
{"uniqueId":"item-285236748444","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season One 1 (Box Set, DVD, 2006) First Season Free Postage","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-285236748444"}}
''',
  r'''
{"uniqueId":"item-295793525174","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-295793525174"}}
''',
  r'''
{"uniqueId":"item-304871470146","bestSource":"DataSourceType.picclickBarcode","title":"Dexter Season 1 DVD Region 4 PAL Free Postage","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-304871470146"}}
''',
  r'''
{"uniqueId":"item-314685857374","bestSource":"DataSourceType.picclickBarcode","title":"3x Dexter DVD- The Third, Fourth & Fifth Season 3 4 5, Region 4 Crime TV Show","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-314685857374"}}
''',
  r'''
{"uniqueId":"item-404205246266","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-404205246266"}}
''',
  r'''
{"uniqueId":"item-404311940471","bestSource":"DataSourceType.picclickBarcode","title":"Dexter: Complete Set Seasons 1-8 (US Crime Drama Series) Region 1 & 4 DVD","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-404311940471"}}
''',
];

void main() {
////////////////////////////////////////////////////////////////////////////////
  /// Integration tests
////////////////////////////////////////////////////////////////////////////////

  group('live QueryPicclickBarcodeSearch test', () {
    // Search for a known movie.
    test(
        'Run a search on piclick that will hopefully have static results', //not likely this is pulling data from ebay about live sales !
        () async {
      final criteria = SearchCriteriaDTO().fromString('9324915073425');
      final actualOutput =
          await QueryPicclickBarcodeSearch(criteria).readList(limit: 10);
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
