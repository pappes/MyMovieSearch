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
{"uniqueId":"item-145194046428","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 2 Box Set DVD 8 discs","alternateTitle":"dexter 2 8 ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-145194046428"}}
''',
  r'''
{"uniqueId":"item-165644878767","bestSource":"DataSourceType.picclickBarcode","title":"Dexter The First Season DVD 4Disc","alternateTitle":"dexter the first ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-165644878767"}}
''',
  r'''
{"uniqueId":"item-166207020874","bestSource":"DataSourceType.picclickBarcode","title":"Dexter Complete 1st and 2nd Season Region 4 PAL 2 DVD Box sets 8 Disc in Total","alternateTitle":"dexter 1st and 2 8 in total ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-166207020874"}}
''',
  r'''
{"uniqueId":"item-204198538282","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","alternateTitle":"dexter 2006 ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-204198538282"}}
''',
  r'''
{"uniqueId":"item-266369498252","bestSource":"DataSourceType.picclickBarcode","title":"Dexter DVD Season 1 Box Set 2006.Great Condition. Free Post","alternateTitle":"dexter 2006 great condition free post ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-266369498252"}}
''',
  r'''
{"uniqueId":"item-304871470146","bestSource":"DataSourceType.picclickBarcode","title":"Dexter Season 1 DVD Region 4 PAL Free Postage","alternateTitle":"dexter ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-304871470146"}}
''',
  r'''
{"uniqueId":"item-325770479158","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","alternateTitle":"dexter 2006 ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-325770479158"}}
''',
  r'''
{"uniqueId":"item-364404540844","bestSource":"DataSourceType.picclickBarcode","title":"Dexter The First Season 1 DVD Region 4 Crime Show Series One","alternateTitle":"dexter the first crime show series one ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-364404540844"}}
''',
  r'''
{"uniqueId":"item-385813276653","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","alternateTitle":"dexter 2006 ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-385813276653"}}
''',
  r'''
{"uniqueId":"item-404427909328","bestSource":"DataSourceType.picclickBarcode","title":"Dexter : Season 1 (Box Set, DVD, 2006)","alternateTitle":"dexter 2006 ","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-404427909328"}}
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
