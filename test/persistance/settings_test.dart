import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/utilities/settings.dart';

// Replace all alphnumeric chars with x.
String? obsfucate(String? setting) =>
    setting?.replaceAll(RegExp('[a-zA-Z0-9]'), 'x');
void main() {
  // Wait for api key to be initialised
  setUpAll(() => Settings().init());
  group('Settings', () {
    test('Check the local settings', () {
      expect(
        obsfucate(Settings().googlekey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'google key does not match',
      );
      expect(
        obsfucate(Settings().omdbkey),
        'xxxxxxxx',
        reason: 'omdb key does not match',
      );
      expect(
        obsfucate(Settings().tmdbkey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'tmdb key does not match',
      );
      expect(
        obsfucate(Settings().tvdbkey),
        'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
        reason: 'tvdb key does not match',
      );
      expect(
        obsfucate(Settings().meiliadminkey),
        null,
        reason: 'meiliadmin key does not match',
      );
      expect(
        obsfucate(Settings().meilisearchkey),
        null,
        reason: 'meilisearch key does not match',
      );
      expect(
        obsfucate(Settings().firebaseSecretsLocation),
        'xxxxxxx/xxxx',
        reason: 'secrets location does not match',
      );
      expect(
        obsfucate(Settings().meiliurl),
        'xxxxx://xxxxx.xxxxxxxxxxx.xxx/',
        reason: 'meiliurl does not match',
      );
    });

    test('check the cloud based settings', () async {
      await Settings().asyncInit();

      expect(
        obsfucate(Settings().meiliadminkey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'meiliadmin key does not match',
      );
      expect(
        obsfucate(Settings().meilisearchkey),
        'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        reason: 'meilisearch key does not match',
      );
      expect(
        obsfucate(Settings().meiliurl),
        'xxxxx://xxxxxx.xxxx.xxx.xxxxxx.xxx/',
        reason: 'meiliurl does not match',
      );

      expect(
        jsonDecode(Settings().seVmKey??''),
        isMap,
        reason: 'seVmKey does not match',
      );
    });
  });
}
