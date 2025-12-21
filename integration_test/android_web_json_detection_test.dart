import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
///     WebJsonExtractor uses a HeadlessInAppWebView
/// which requires a real android device or emulator to run
/// hence this is an integration test with a full MyApp widget.
///
/// Android device must be connected or launch from the command line with:
/// flutter test integration_test/android_web_json_detection_test.dart -d 192.168.0.33:41471
////////////////////////////////////////////////////////////////////////////////
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Json Extractor Integration Test')),
      body: const MyWebViewWidget(),
    ),
  );
}

class MyWebViewWidget extends StatefulWidget {
  const MyWebViewWidget({super.key});

  @override
  State<MyWebViewWidget> createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget> {
  @override
  Widget build(BuildContext context) => const Text('Json extractor');
}

int jsonChunkCount = 0;

void callback(String jsonString) {
  print(
    'JSON Callback($jsonChunkCount): '
    '${jsonString.substring(0, min(jsonString.length, 100))}'
    '...${jsonString.length}',
  );
  jsonChunkCount++;
}

Future<void> _getDataFromImdb() async {
  jsonChunkCount = 0;
  final extractor = WebJsonExtractor(
    'https://www.imdb.com/name/nm0000149/',
    callback,
    'FilmographyV2Pagination',
  );
  await extractor.waitForCompletion();
}

//this will only run on android because it uses flutter_inappwebview
void main() {
  // Ensure the platform bindings are initialized for the integration test.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  testWidgets(
    'Extract json from imdb for person filmography',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      await _getDataFromImdb();

      // Check the results.
      expect(
        jsonChunkCount,
        greaterThanOrEqualTo(3),
        reason: 'Json chunks should have 3 entries but has $jsonChunkCount',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
    // This test uses flutter_inappwebview which is configured for Android.
    skip: !Platform.isAndroid,
  );
  testWidgets(
    'Extract json from imdb for the same person again',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      await _getDataFromImdb();

      // Check the results.
      expect(
        jsonChunkCount,
        greaterThanOrEqualTo(3),
        reason: 'Json chunks should have 3 entries but has $jsonChunkCount',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
    // This test uses flutter_inappwebview which is configured for Android.
    skip: !Platform.isAndroid,
  );
  testWidgets(
    'Extract json using WebJsonSychroniser',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      final extractor = WebJsonSychroniser(
        'https://www.imdb.com/name/nm0000149/',
        'FilmographyV2Pagination',
      );
      final json = await extractor.getJson();

      // Check the results.
      expect(
        json.length,
        greaterThanOrEqualTo(3),
        reason: 'Json chunks should have 3 entries but has ${json.length}',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
    // This test uses flutter_inappwebview which is configured for Android.
    skip: !Platform.isAndroid,
  );
}
