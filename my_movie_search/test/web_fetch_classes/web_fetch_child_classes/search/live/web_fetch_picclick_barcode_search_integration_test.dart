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
{"uniqueId":"item-125778116610","bestSource":"DataSourceType.picclickBarcode","title":"dexter the first crime show series one","alternateTitle":"Dexter The First Season 1 DVD Region 4 Crime Show Series One","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-125778116610"}}
''',
  r'''
{"uniqueId":"item-186032632764","bestSource":"DataSourceType.picclickBarcode","title":"dexter 2006","alternateTitle":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-186032632764"}}
''',
  r'''
{"uniqueId":"item-204379004407","bestSource":"DataSourceType.picclickBarcode","title":"dexter 2006","alternateTitle":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-204379004407"}}
''',
  r'''
{"uniqueId":"item-225586650908","bestSource":"DataSourceType.picclickBarcode","title":"dexter 4 set s013","alternateTitle":"DEXTER Season 1 DVD 4 Disc Set Region 4 (S013)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-225586650908"}}
''',
  r'''
{"uniqueId":"item-276005435412","bestSource":"DataSourceType.picclickBarcode","title":"dexter 4 r4 2008 2011","alternateTitle":"Dexter Season 1-4 (R4 DVD, 2008-2011) - Free Postage","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-276005435412"}}
''',
  r'''
{"uniqueId":"item-295793525174","bestSource":"DataSourceType.picclickBarcode","title":"dexter 2006","alternateTitle":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-295793525174"}}
''',
  r'''
{"uniqueId":"item-325541861426","bestSource":"DataSourceType.picclickBarcode","title":"dexter 4 r4 2008 2011","alternateTitle":"Dexter Season 1-4 (R4 DVD, 2008-2011) - Free Postage","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-325541861426"}}
''',
  r'''
{"uniqueId":"item-325770479158","bestSource":"DataSourceType.picclickBarcode","title":"dexter 2006","alternateTitle":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-325770479158"}}
''',
  r'''
{"uniqueId":"item-364420476732","bestSource":"DataSourceType.picclickBarcode","title":"dexter the first crime show series one","alternateTitle":"Dexter The First Season 1 DVD Region 4 Crime Show Series One","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-364420476732"}}
''',
  r'''
{"uniqueId":"item-394673491716","bestSource":"DataSourceType.picclickBarcode","title":"dexter 2006","alternateTitle":"Dexter : Season 1 (Box Set, DVD, 2006)","type":"MovieContentType.barcode","sources":{"DataSourceType.picclickBarcode":"item-394673491716"}}
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
        actualOutput.length,
        greaterThan(5),
        reason: 'Emitted DTO list ${actualOutput.toPrintableString()} '
            'needs to match expected DTO list ${expectedOutput.toPrintableString()}',
      );
    });
  });
}
