// allow test to do thing production code should not
// ignore_for_file: invalid_use_of_visible_for_overriding_member

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/utilities/settings.dart';

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('MagnetHelper intagration tests', () {
    // Confirm map can be converted to DTO.
    // Confirm map can be converted to DTO.
    test('Run addTrackers to get extra seeders', () async {
      const basicResult = magnetFragment1;
      // Backup the original list of magnet sources.
      final originalUrls = List<String>.from(magnetSources);
      try {
        await MagnetHelper.init();
      } finally {
        // Restore the original list of magnet sources.
        magnetSources
          ..clear()
          ..addAll(originalUrls);
      }
      final extendedResult = MagnetHelper.addTrackers(basicResult);

      // Check the results.
      expect(
        basicResult.length,
        lessThan(extendedResult.length),
        reason:
            'Emitted image URL length \n$basicResult \n'
            'needs to be less than expected image URL length \n'
            '$extendedResult',
      );
    });
  });
}
