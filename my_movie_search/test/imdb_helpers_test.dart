import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future main() async {
  group('makeImdbUrl', () {
    test(
      'empty string',
      () {
        expect(makeImdbUrl(''), startsWith('https://www.imdb.com/?'));
      },
    );
    test(
      'normal person',
      () {
        expect(
          makeImdbUrl('nm00123456'),
          startsWith('https://www.imdb.com/name/nm00123456/?'),
        );
      },
    );
    test(
      'normal movie',
      () {
        expect(
          makeImdbUrl('tt00123456'),
          startsWith('https://www.imdb.com/title/tt00123456/?'),
        );
      },
    );
    test(
      'mobile movie',
      () {
        expect(
          makeImdbUrl('tt00123456', mobile: true),
          startsWith('https://m.imdb.com/title/tt00123456/?'),
        );
      },
    );
    test(
      'movie photos',
      () {
        expect(
          makeImdbUrl('tt00123456', photos: true),
          startsWith('https://www.imdb.com/title/tt00123456/mediaindex?'),
        );
      },
    );
    test(
      'movie parentalGuide',
      () {
        expect(
          makeImdbUrl('tt00123456', parentalGuide: true),
          startsWith('https://www.imdb.com/title/tt00123456/parentalguide?'),
        );
      },
    );
  });
  group('getIdFromIMDBLink', () {
    test(
      'empty string',
      () {
        expect(getIdFromIMDBLink(''), '');
      },
    );
    test(
      'normal person',
      () {
        expect(
          getIdFromIMDBLink('/name/nm00123456/?ref_=nm_sims_nm_t_9'),
          'nm00123456',
        );
      },
    );
    test(
      'minimal movie',
      () {
        expect(
          getIdFromIMDBLink('/title/tt00123456'),
          'tt00123456',
        );
      },
    );
    test(
      'full movie',
      () {
        expect(
          getIdFromIMDBLink('/title/tt00123456/?ref_=nm_sims_nm_t_9'),
          'tt00123456',
        );
      },
    );
    test(
      'movie photos',
      () {
        expect(
          getIdFromIMDBLink('/title/tt00123456/mediaindex?ref_=nm_sims_nm_t_9'),
          'tt00123456',
        );
      },
    );
    test(
      'movie parentalGuide',
      () {
        expect(
          getIdFromIMDBLink(
            '/title/tt00123456/parentalguide?ref_=nm_sims_nm_t_9',
          ),
          'tt00123456',
        );
      },
    );
  });

  group('getIdFromIMDBLink', () {
    // Ensure conversion between IMDB and URL yields correct results.
    test('check sample urls', () {
      void testGetIdFromIMDBLink(String input, expectedOutput) {
        final text = getIdFromIMDBLink(input);
        expect(text, expectedOutput);
      }

      testGetIdFromIMDBLink(
        '/title/tt0145681/?ref_=nm_sims_nm_t_9',
        'tt0145681',
      );
      testGetIdFromIMDBLink(
        '/title/tt0145682?ref_=nm_sims_nm_t_9',
        'tt0145682',
      );
      testGetIdFromIMDBLink(
        '/name/nm0145683/?ref_=nm_sims_nm_t_9',
        'nm0145683',
      );
      testGetIdFromIMDBLink('/name/nm0145684?ref_=nm_sims_nm_t_9', 'nm0145684');
    });
  });
}
