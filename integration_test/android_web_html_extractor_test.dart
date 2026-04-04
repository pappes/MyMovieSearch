import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_movie_search/utilities/web_data/http_method.dart';
import 'package:my_movie_search/utilities/web_data/web_html_extractor.dart';

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

  runApp(const MyApp());

  // Get app warmed up before launching headless browser.
  await Future<void>.delayed(const Duration(seconds: 8));


  testWidgets(
    'WebHtmlExtractor low level class',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      String? htmlData;
      final extractor = WebHtmlExtractor();
      await extractor.execute(
        'https://www.imdb.com/name/nm0000149/',
        'never_match_this_string_to_avoid_intercepts',
        (data) {
          if (data.contains(
            '<script id="__NEXT_DATA__" '
            'type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
          )) {
            htmlData = data;
          }
        },
      );

      expect(htmlData, isNotNull);
      expect(
        htmlData,
        contains(
          '<script id="__NEXT_DATA__" type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
    skip: !Platform.isAndroid,
  );

  testWidgets(
    'test HeadlessHttpClientRequest as replacement for HttpClientRequest',
    (tester) async {
      await tester.pumpWidget(const MyApp());

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
    skip: !Platform.isAndroid,
  );

  testWidgets(
    'test HeadlessHttpClient as replacement for HttpClient',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      final client = HeadlessHttpClient();
      final request = await client.openUrl(
        HttpMethod.get.value,
        Uri.parse('https://www.imdb.com/name/nm0000149/'),
      );
      final response = await request.close();
      final htmlData = await response.transform(utf8.decoder).join();
      final statusCode = response.statusCode;

      expect(htmlData, isNotNull);
      expect(statusCode, HttpStatus.ok);
      expect(
        htmlData,
        contains(
          '<script id="__NEXT_DATA__" '
          'type="application/json">{"props":{"pageProps":{"nmconst":"nm0000149"',
        ),
      );
    },
    timeout: const Timeout(Duration(seconds: 60)),
    skip: !Platform.isAndroid,
  );

  testWidgets(
    'Use real HttpClient to baseline test results',
    (tester) async {
      await tester.pumpWidget(const MyApp());

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
}
