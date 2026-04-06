import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_movie_search/utilities/thread.dart';
import 'package:my_movie_search/utilities/web_data/http_method.dart';
import 'package:my_movie_search/utilities/web_data/web_html_extractor.dart';

import 'test_helper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Html Extractor Integration Test')),
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
  Widget build(BuildContext context) => const Text('Html extractor');
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // On Android, this ensures cookies are persistent
  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  testWidgets(
    'Use real HttpClient to baseline test results',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final client = HttpClient();
      final request = await client.openUrl(
        HttpMethod.get.value,
        Uri.parse('https://www.imdb.com/name/nm0000149/'),
      );
      final response = await request.close();
      final htmlData = await response.transform(utf8.decoder).join();
      final statusCode = response.statusCode;

      expect(htmlData, isEmpty);
      expect(statusCode, HttpStatus.accepted);
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets(
    'WebHtmlExtractor low level class',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      String? htmlData;
      final extractor = WebHtmlExtractor();
      await extractor.execute('https://www.imdb.com/name/nm0000149/', (data) {
        if (data.contains(
          '<script id="__NEXT_DATA__" '
          'type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
        )) {
          htmlData = data;
        }
      });

      expect(htmlData, isNotNull);
      expect(
        htmlData,
        contains(
          '<script id="__NEXT_DATA__" '
          'type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets(
    'HeadlessHttpClientRequest as replacement for HttpClientRequest',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final adapter = HeadlessHttpClientRequest(
        'https://www.imdb.com/name/nm0000149/',
      );
      final htmlStream = await adapter.getHtmlStream();
      final htmlData = await htmlStream.join();
      await adapter.close();

      expect(htmlData, isNotNull);
      expect(
        htmlData,
        contains(
          '<script id="__NEXT_DATA__" '
          'type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets(
    'HeadlessHttpClient for a movie as replacement for HttpClient',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final client = HeadlessHttpClient();
      final request = await client.openUrl(
        HttpMethod.get.value,
        Uri.parse('https://www.imdb.com/title/tt0105236/fullcredits/'),
      );
      final response = await request.close();
      final htmlData = await response.transform(utf8.decoder).join();
      final statusCode = response.statusCode;

      expect(htmlData, isNotNull);
      expect(statusCode, HttpStatus.ok);
      expect(
        htmlData,
        contains(
          '</script><script id="__NEXT_DATA__" '
          'type="application/json">{"props":{"pageProps":{"contentData":{"entityMetadata":{"id":"tt0105236',
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets(
    'WebHtmlSychroniser',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      Future<String> getHtml(String url) async {
        await warmUpHeadlessEngine();
        final htmlData = await WebHtmlSychroniser(url).getHtml();
        if (htmlData.isEmpty) {
          return 'noresults';
        }
        return htmlData.first;
      }

      final htmlOutput = await getHtml('https://www.imdb.com/name/nm0000149/');

      expect(htmlOutput, isNotNull);
      expect(
        htmlOutput,
        contains(
          '<script id="__NEXT_DATA__" '
          'type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

  testWidgets(
    'WebHtmlSychroniser on non-UI thread',
    (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      Future<String> getHtml(String url) async {
        final htmlData = await WebHtmlSychroniser(url).getHtml();
        if (htmlData.isEmpty) {
          return 'noresults';
        }
        return htmlData.first;
      }

      final otherThread = ThreadRunner.namedThread('a');
      // Use throwsA for Futures
      await expectLater(
        () => otherThread.run(getHtml, 'https://www.imdb.com/name/nm0000149/'),
        throwsA(isA<AssertionError>()),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
  );

}
