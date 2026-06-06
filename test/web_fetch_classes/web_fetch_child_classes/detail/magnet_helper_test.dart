import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/utilities/settings.dart';

void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init(includeCloudSettings: false));
  ////////////////////////////////////////////////////////////////////////////////
  /// Unit tests
  ////////////////////////////////////////////////////////////////////////////////

  group('MagnetHelper integration tests', () {
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
      final extendedResult2 = MagnetHelper.addTrackers(extendedResult);

      // Check the results.
      expect(
        basicResult.length + 5,
        lessThan(extendedResult!.length),
        reason:
            'Emitted image URL length \n$basicResult \n'
            'needs to be less than expected image URL length \n'
            '$extendedResult',
      );
      expect(
        extendedResult.length,
        equals(extendedResult2!.length),
        reason:
            'Emitted image URL length \n$extendedResult \n'
            'needs to be the same as expected image URL length \n'
            '$extendedResult2',
      );
    });
    test('test getName', () {
      const magnet =
          'magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.BZ%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce';
      final name = MagnetHelper.getName(magnet);
      expect(name, '2001: A Space Odyssey (1968) [1080p] [YTS.BZ]');
    });
    test('test setName', () {
      const magnet =
          'magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=2001%3A+A+Space+Odyssey+%281968%29+%5B1080p%5D+%5BYTS.BZ%5D&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce';
      const expectedName =
          'magnet:?xt=urn:btih:A2A78568F4CC7873E9E0088DDE28FA9D9976ACC7&dn=(great+movie)&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337%2Fannounce';
      final name = MagnetHelper.setName('(great movie)', magnet);
      expect(
        name,
        expectedName,
        reason: '(great movie) has not been inserted in to the magnet link',
      );
    });
  });
}
