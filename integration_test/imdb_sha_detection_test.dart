//@TestOn('android')

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';

////////////////////////////////////////////////////////////////////////////////
/// Read from real IMDB endpoint!
/// QueryIMDBJsonPaginatedFilmographyDetails uses a webviewController
/// which requires a real device or emulator to run
/// hence this is an integration test with a full MyApp widget.
///
/// to execute on android must be launched from the command line with:
/// flutter test integration_test/imdb_sha_detection_test.dart -d 192.168.0.33:41471
////////////////////////////////////////////////////////////////////////////////


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Sha Extractor Integration Test')),
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
  Widget build(BuildContext context) => const Text('Sha extractor');
}


Future<Map<ImdbJsonSource, String>> _extractShas() async {

  print('extracting shas');
  final shaMap = <ImdbJsonSource, String>{};
  await Future.wait({
    IMDBShaExtractor(shaMap, ImdbJsonSource.actor).updateSha(),
    IMDBShaExtractor(shaMap, ImdbJsonSource.actress).updateSha(),
    IMDBShaExtractor(shaMap, ImdbJsonSource.director).updateSha(),
    IMDBShaExtractor(shaMap, ImdbJsonSource.producer).updateSha(),
    IMDBShaExtractor(shaMap, ImdbJsonSource.writer).updateSha(),
    IMDBShaExtractor(shaMap, ImdbJsonSource.credits).updateSha()
  });
  return shaMap;
}

//this will only run on android because it uses flutter_inappwebview
void main() {
  // Ensure the platform bindings are initialized for the integration test.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());

  testWidgets('Extract SHAs from imdb for common roles', (tester) async {
      await tester.pumpWidget(const MyApp());

      final output =await _extractShas();

      // Check the results.
      expect(
        output.length,
        6,
        reason:
            'SHA map should have 6 entries but has ${output.length}:\n $output',
      );
      // This test uses flutter_inappwebview which is configured for Android.
    },
    timeout: const Timeout(Duration(seconds: 60)), 
    skip: !Platform.isAndroid
  );
}
