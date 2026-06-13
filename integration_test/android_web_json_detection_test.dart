import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
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

const jfUrl = 'https://www.imdb.com/name/nm0000149/';
const imdbActorUrl2 = 'https://www.imdb.com/name/nm0000148/';
const imdbActorUrl3 = 'https://www.imdb.com/name/nm0000147/';
const apiPaginationFilter = 'FilmographyV2Pagination';

int jsonChunkCount = 0;

void callback(String jsonString) {
  AppLogger.instance.info(
    'JSON Callback($jsonChunkCount): '
    '${jsonString.truncate(100)}'
    '...${jsonString.length}',
  );
  jsonChunkCount++;
}

Future<void> _getJfDataFromImdb() async {
  jsonChunkCount = 0;
  await _getDatumFromImdb(jfUrl);
}

Future<void> _getMultipleDataFromImdb() async {
  jsonChunkCount = 0;
  await Future.wait([
    _getDatumFromImdb(jfUrl),
    _getDatumFromImdb(imdbActorUrl2),
    _getDatumFromImdb(imdbActorUrl3),
  ]);
}

Future<void> _getDatumFromImdb(String url) => WebJsonExtractor().execute(
  url,
  callback,
  apiAcceptFilter: apiPaginationFilter,
);

//this will only run on android because it uses flutter_inappwebview
void main() {
  // Ensure the platform bindings are initialized for the integration test.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Extract json from imdb for person filmography',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await _getJfDataFromImdb();

      // Check the results.
      expect(
        jsonChunkCount,
        greaterThanOrEqualTo(3),
        reason: 'Json chunks should have 3 entries but has $jsonChunkCount',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
  testWidgets(
    'Extract json from imdb for the same person again',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await _getJfDataFromImdb();

      // Check the results.
      expect(
        jsonChunkCount,
        greaterThanOrEqualTo(3),
        reason: 'Json chunks should have 3 entries but has $jsonChunkCount',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets(
    'Extract json using WebJsonSychroniser',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final extractor = WebJsonSychroniser(jfUrl, apiPaginationFilter);
      final json = await extractor.getJson();

      // Check the results.
      expect(
        json.length,
        greaterThanOrEqualTo(3),
        reason: 'Json chunks should have 3 entries but has ${json.length}',
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
  testWidgets(
    'Extract json from imdb for multiple people simultaneously',
    (tester) async {
      AppLogger.turnOnLocalLogs(level: LogLevel.trace);
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await _getMultipleDataFromImdb();

      // Check the results.
      expect(
        jsonChunkCount,
        greaterThanOrEqualTo(3 * 3),
        reason: 'Json chunks should have 9 entries but has $jsonChunkCount',
      );

    },
    timeout: const Timeout(Duration(seconds: 60)),
  );
}
