import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/persistence/meilisearch.dart';
import 'package:my_movie_search/utilities/settings.dart';

void main() {
  group('GCP', () {
    test('startSearchEngine should start the VM instance', () async {
      // Create GCP instance
      final gcp = GCP();
      Settings().init();
      await Settings().cloudSettingsInitialised;

      // Set up test data
      gcp.accountJson = Settings().seVmKey;

      // Call the method
      final started = await gcp.startSearchEngine();
      expect(started, true);
    });

    test('startSearchEngine should throw an exception if accountJson is null',
        () async {
      // Create GCP instance
      final gcp = GCP()

        // Set up test data
        ..accountJson = null;

      // Call the method
      final started = await gcp.startSearchEngine();
      expect(started, false);
    });
  });
}
