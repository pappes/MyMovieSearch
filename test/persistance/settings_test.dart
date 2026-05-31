import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/utilities/settings.dart';

// Replace all alphnumeric chars with x.
String? obsfucate(String? setting) =>
    setting?.replaceAll(RegExp('[a-zA-Z0-9]'), 'x');
void main() {
  group('Settings', () {
    Settings().init(includeCloudSettings: false);
    test('Check the local settings', () {
      expect(
        obsfucate(Settings().googleKey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'google key does not match',
      );
      expect(
        obsfucate(Settings().omdbKey),
        'xxxxxxxx',
        reason: 'omdb key does not match',
      );
      expect(
        obsfucate(Settings().tmdbKey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'tmdb key does not match',
      );
      expect(
        obsfucate(Settings().tvdbKey),
        'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        reason: 'tvdb key does not match',
      );
      expect(
        obsfucate(Settings().meiliAdminKey),
        null,
        reason: 'meiliadmin key does not match',
      );
      expect(
        obsfucate(Settings().meiliSearchKey),
        null,
        reason: 'meilisearch key does not match',
      );
      expect(
        obsfucate(Settings().firebaseSecretsLocation),
        'xxxxxxx/xxxx',
        reason: 'secrets location does not match',
      );
      expect(
        obsfucate(Settings().meiliUrl),
        'xxxxx://xxxxx.xxxxxxxxxxx.xxx/',
        reason: 'meiliurl does not match',
      );
    });

    test('check the cloud based settings', () async {
      await Settings().init();

      expect(
        obsfucate(Settings().meiliAdminKey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'meiliadmin key does not match',
      );
      expect(
        obsfucate(Settings().meiliSearchKey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'meilisearch key does not match',
      );
      expect(
        obsfucate(Settings().meiliUrl),
        'xxxxx://xxxxxx.xxxx.xxx.xxxxxx.xxx/',
        reason: 'meiliurl does not match',
      );

      expect(
        jsonDecode(Settings().seVmKey ?? ''),
        isMap,
        reason: 'seVmKey does not match',
      );
    });
  });
}
