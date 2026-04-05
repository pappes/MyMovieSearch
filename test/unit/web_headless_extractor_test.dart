import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart' as mockito;

import 'package:my_movie_search/utilities/web_data/headless_web_engine.dart';
import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

import 'web_headless_extractor_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HeadlessWebEngine>()])
void main() {
  late MockHeadlessWebEngine mockEngine;
  late WebJsonExtractor extractor;

  setUp(() {
    mockEngine = MockHeadlessWebEngine();
    extractor = WebJsonExtractor(webEngine: mockEngine);
  });

  test('processRawData validates and passes valid JSON', () {
    var dataPassed = false;
    extractor.processRawData('{"key":"value"}', (data) {
      dataPassed = true;
      expect(data, '{"key":"value"}');
    });

    expect(dataPassed, isTrue);
  });

  test('processRawData ignores invalid JSON', () {
    var dataPassed = false;
    extractor.processRawData('Invalid HTML string <html', (data) {
      dataPassed = true;
    });

    expect(dataPassed, isFalse);
  });

  test('execute delegates to webEngine.run', () async {
    await extractor.execute(
      'https://example.com',
      (data) {},
      apiAcceptFilter: 'apiFilter',
    );

    mockito
        .verify(
          mockEngine.run(
            url: 'https://example.com',
            urlInterceptFilter: 'apiFilter',
            onEngineData: mockito.anyNamed('onEngineData'),
            onPageLoaded: mockito.anyNamed('onPageLoaded'),
          ),
        )
        .called(1);
  });
}
