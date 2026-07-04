import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  group('makeImdbUrl', () {
    test('empty string', () {
      expect(makeImdbUrl(''), startsWith('https://www.imdb.com/?'));
    });
    test('normal person', () {
      expect(
        makeImdbUrl('nm00123456'),
        startsWith('https://www.imdb.com/name/nm00123456/?'),
      );
    });
    test('normal movie', () {
      expect(
        makeImdbUrl('tt00123456'),
        startsWith('https://www.imdb.com/title/tt00123456/?'),
      );
    });
    test('mobile movie', () {
      expect(
        makeImdbUrl('tt00123456', mobile: true),
        startsWith('https://m.imdb.com/title/tt00123456/?'),
      );
    });
    test('movie photos', () {
      expect(
        makeImdbUrl('tt00123456', photos: true),
        startsWith('https://www.imdb.com/title/tt00123456/mediaindex?'),
      );
    });
    test('movie parentalGuide', () {
      expect(
        makeImdbUrl('tt00123456', parentalGuide: true),
        startsWith('https://www.imdb.com/title/tt00123456/parentalguide?'),
      );
    });
  });
  group('getIdFromIMDBLink', () {
    test('empty string', () {
      expect(getIdFromIMDBLink(''), '');
    });
    test('normal person', () {
      expect(
        getIdFromIMDBLink('/name/nm00123456/?ref_=nm_sims_nm_t_9'),
        'nm00123456',
      );
    });
    test('minimal movie', () {
      expect(getIdFromIMDBLink('/title/tt00123456'), 'tt00123456');
    });
    test('full movie', () {
      expect(
        getIdFromIMDBLink('/title/tt00123456/?ref_=nm_sims_nm_t_9'),
        'tt00123456',
      );
    });
    test('movie photos', () {
      expect(
        getIdFromIMDBLink('/title/tt00123456/mediaindex?ref_=nm_sims_nm_t_9'),
        'tt00123456',
      );
    });
    test('movie parentalGuide', () {
      expect(
        getIdFromIMDBLink(
          '/title/tt00123456/parentalguide?ref_=nm_sims_nm_t_9',
        ),
        'tt00123456',
      );
    });
  });

  group('getIdFromIMDBLink', () {
    // Ensure conversion between IMDB and URL yields correct results.
    test('check sample urls', () {
      void testGetIdFromIMDBLink(String input, String expectedOutput) {
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

  group('getImdbCensorRating', () {
    // Ensure conversion between string and CensorRatingType
    // yields correct results.
    test('check sample urls', () {
      void testGetImdbCensorRating(
        String? input,
        CensorRatingType? expectedOutput,
      ) {
        final actualOutput = getImdbCensorRating(input);
        expect(
          actualOutput,
          expectedOutput,
          reason: '$input did not return $expectedOutput',
        );
      }

      testGetImdbCensorRating(null, null);
      testGetImdbCensorRating('Unrated', .none);

      testGetImdbCensorRating('Banned', .adult);
      testGetImdbCensorRating('X', .adult);
      testGetImdbCensorRating('XXX', .adult);
      testGetImdbCensorRating('R21', .adult);
      testGetImdbCensorRating('SOA', .adult);

      testGetImdbCensorRating('R', .restricted);
      testGetImdbCensorRating('R(A)', .restricted);
      testGetImdbCensorRating('RP18', .restricted);
      testGetImdbCensorRating('Mature', .restricted);
      testGetImdbCensorRating('Adult', .restricted);
      testGetImdbCensorRating('GA', .restricted);
      testGetImdbCensorRating('M18', .restricted);
      testGetImdbCensorRating('VM18', .restricted);
      testGetImdbCensorRating('18+', .restricted);
      testGetImdbCensorRating('RP18', .restricted);
      testGetImdbCensorRating('NC17', .restricted);
      testGetImdbCensorRating('NC-17', .restricted);

      testGetImdbCensorRating('21', .adult);
      testGetImdbCensorRating('19', .restricted);
      testGetImdbCensorRating('18', .restricted);
      testGetImdbCensorRating('17', .restricted);
      testGetImdbCensorRating('16', .mature);
      testGetImdbCensorRating('15', .mature);
      testGetImdbCensorRating('14', .mature);
      testGetImdbCensorRating('13', .family);
      testGetImdbCensorRating('12', .family);
      testGetImdbCensorRating('11', .family);
      testGetImdbCensorRating('10', .family);
      testGetImdbCensorRating('9', .family);
      testGetImdbCensorRating('8', .family);
      testGetImdbCensorRating('7', .family);
      testGetImdbCensorRating('6', .family);
      testGetImdbCensorRating('15+', .mature);
      testGetImdbCensorRating('14+', .mature);
      testGetImdbCensorRating('13+', .family);
      testGetImdbCensorRating('12+', .family);
      testGetImdbCensorRating('9+', .family);
      testGetImdbCensorRating('7+', .family);
      testGetImdbCensorRating('6+', .family);

      testGetImdbCensorRating('NC16', .mature);
      testGetImdbCensorRating('R16', .mature);
      testGetImdbCensorRating('RP16', .mature);
      testGetImdbCensorRating('VM16', .mature);
      testGetImdbCensorRating('VM 16', .mature);
      testGetImdbCensorRating('R15', .mature);
      testGetImdbCensorRating('R15+', .mature);
      testGetImdbCensorRating('15A', .mature);
      testGetImdbCensorRating('15PG', .mature);
      testGetImdbCensorRating('VM14', .mature);
      testGetImdbCensorRating('TV-14', .mature);
      testGetImdbCensorRating('TV-MA', .mature);
      testGetImdbCensorRating('M', .mature);
      testGetImdbCensorRating('MA', .mature);
      testGetImdbCensorRating('GY', .mature);
      testGetImdbCensorRating('D', .mature);
      testGetImdbCensorRating('LH', .mature);

      testGetImdbCensorRating('PG13', .family);
      testGetImdbCensorRating('VM6', .family);
      testGetImdbCensorRating('T', .family);
      testGetImdbCensorRating('TV-Y', .kids);
      testGetImdbCensorRating('TV-G', .family);
      testGetImdbCensorRating('TV-PG', .family);
      testGetImdbCensorRating('TV-Y7', .family);
      testGetImdbCensorRating('Approved', .family);
      testGetImdbCensorRating('PG-13', .family);
      testGetImdbCensorRating('R13', .family);
      testGetImdbCensorRating('RP13', .family);
      testGetImdbCensorRating('12A', .family);
      testGetImdbCensorRating('PG12', .family);
      testGetImdbCensorRating('12PG', .family);
      testGetImdbCensorRating('TE', .family);
      testGetImdbCensorRating('Teen', .family);
      testGetImdbCensorRating('S', .family);
      testGetImdbCensorRating('G', .family);
      testGetImdbCensorRating('PG', .family);
      testGetImdbCensorRating('T', .family);
      testGetImdbCensorRating('B', .family);

      testGetImdbCensorRating('C', .kids);
      testGetImdbCensorRating('Y', .kids);
      testGetImdbCensorRating('TV-Y', .kids);
      testGetImdbCensorRating('U', .kids);
      testGetImdbCensorRating('Btl', .kids);
      testGetImdbCensorRating('TP', .kids);
      testGetImdbCensorRating('0', .kids);
      testGetImdbCensorRating('0+', .kids);
      testGetImdbCensorRating('A', .kids);
      testGetImdbCensorRating('All', .kids);
      testGetImdbCensorRating('AL', .kids);
      testGetImdbCensorRating('AA', .kids);
    });
  });

  group('getBigImage', () {
    // Ensure conversion between thumnail and full URL yields correct results.
    test('check sample urls', () {
      void testGetBigImage(String input, String expectedOutput) {
        final text = getBigImage(input);
        expect(text, expectedOutput);
      }

      testGetBigImage(
        'https://m.media-amazon.com/images/address/image..jpg',
        'https://m.media-amazon.com/images/address/image.jpg',
      );
      testGetBigImage(
        r'https://m.media-amazon.com/images/address/image.all-this-can-be-ignored-!#[]{};:",@-<>/?\|`~-=_+$%^&*().jpg',
        'https://m.media-amazon.com/images/address/image.jpg',
      );
      testGetBigImage(
        'https://m.media-amazon.com/images/M/MV5BODQxYWM2ODItYjE4ZC00YzAxLTljZDQtMjRjMmE0ZGMwYzZjXkEyXkFqcGdeQXVyODIyOTEyMzY@._V1_UY268_CR9,0,182,268_AL_.jpg',
        'https://m.media-amazon.com/images/M/MV5BODQxYWM2ODItYjE4ZC00YzAxLTljZDQtMjRjMmE0ZGMwYzZjXkEyXkFqcGdeQXVyODIyOTEyMzY@.jpg',
      );
    });
  });

  group('fastParse', () {
    // Ensure conversion between html text and json yields correct results.
    test('check basic html', () {
      const input = '{"props":{"pageProps":{"stuffgoeshere":""}}}</script>';
      final expectedOutput = [
        {
          'props': {
            'pageProps': {'stuffgoeshere': ''},
          },
        },
      ];
      final actualOuput = fastParse(input);
      expect(actualOuput, expectedOutput);
    });
    test('check invalid json', () {
      const input = '{"props":{"pageProps":{"stuffgoeshere"}}}</script>';
      final expectedOutput = throwsA(
        isA<FastParseException>().having(
          (e) => e.cause,
          'cause',
          startsWith('Json decode failed!'),
        ),
      );
      expect(() => fastParse(input), expectedOutput);
    });
    test('check invalid html', () {
      const input = '<script></script>';
      final expectedOutput = throwsA(
        isA<FastParseException>().having(
          (e) => e.cause,
          'cause',
          startsWith('Fast parse unsuccessful, try a slow parse!'),
        ),
      );
      expect(() => fastParse(input), expectedOutput);
    });
  });
}
