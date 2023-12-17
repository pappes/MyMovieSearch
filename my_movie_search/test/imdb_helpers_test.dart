import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
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
      testGetImdbCensorRating('Unrated', CensorRatingType.none);

      testGetImdbCensorRating('Banned', CensorRatingType.adult);
      testGetImdbCensorRating('X', CensorRatingType.adult);
      testGetImdbCensorRating('XXX', CensorRatingType.adult);
      testGetImdbCensorRating('R21', CensorRatingType.adult);
      testGetImdbCensorRating('SOA', CensorRatingType.adult);

      testGetImdbCensorRating('R', CensorRatingType.restricted);
      testGetImdbCensorRating('R(A)', CensorRatingType.restricted);
      testGetImdbCensorRating('RP18', CensorRatingType.restricted);
      testGetImdbCensorRating('Mature', CensorRatingType.restricted);
      testGetImdbCensorRating('Adult', CensorRatingType.restricted);
      testGetImdbCensorRating('GA', CensorRatingType.restricted);
      testGetImdbCensorRating('M18', CensorRatingType.restricted);
      testGetImdbCensorRating('VM18', CensorRatingType.restricted);
      testGetImdbCensorRating('18+', CensorRatingType.restricted);
      testGetImdbCensorRating('RP18', CensorRatingType.restricted);
      testGetImdbCensorRating('NC17', CensorRatingType.restricted);
      testGetImdbCensorRating('NC-17', CensorRatingType.restricted);

      testGetImdbCensorRating('21', CensorRatingType.adult);
      testGetImdbCensorRating('19', CensorRatingType.restricted);
      testGetImdbCensorRating('18', CensorRatingType.restricted);
      testGetImdbCensorRating('17', CensorRatingType.restricted);
      testGetImdbCensorRating('16', CensorRatingType.mature);
      testGetImdbCensorRating('15', CensorRatingType.mature);
      testGetImdbCensorRating('14', CensorRatingType.mature);
      testGetImdbCensorRating('13', CensorRatingType.family);
      testGetImdbCensorRating('12', CensorRatingType.family);
      testGetImdbCensorRating('11', CensorRatingType.family);
      testGetImdbCensorRating('10', CensorRatingType.family);
      testGetImdbCensorRating('9', CensorRatingType.family);
      testGetImdbCensorRating('8', CensorRatingType.family);
      testGetImdbCensorRating('7', CensorRatingType.family);
      testGetImdbCensorRating('6', CensorRatingType.family);
      testGetImdbCensorRating('15+', CensorRatingType.mature);
      testGetImdbCensorRating('14+', CensorRatingType.mature);
      testGetImdbCensorRating('13+', CensorRatingType.family);
      testGetImdbCensorRating('12+', CensorRatingType.family);
      testGetImdbCensorRating('9+', CensorRatingType.family);
      testGetImdbCensorRating('7+', CensorRatingType.family);
      testGetImdbCensorRating('6+', CensorRatingType.family);

      testGetImdbCensorRating('NC16', CensorRatingType.mature);
      testGetImdbCensorRating('R16', CensorRatingType.mature);
      testGetImdbCensorRating('RP16', CensorRatingType.mature);
      testGetImdbCensorRating('VM16', CensorRatingType.mature);
      testGetImdbCensorRating('VM 16', CensorRatingType.mature);
      testGetImdbCensorRating('R15', CensorRatingType.mature);
      testGetImdbCensorRating('R15+', CensorRatingType.mature);
      testGetImdbCensorRating('15A', CensorRatingType.mature);
      testGetImdbCensorRating('15PG', CensorRatingType.mature);
      testGetImdbCensorRating('VM14', CensorRatingType.mature);
      testGetImdbCensorRating('TV-14', CensorRatingType.mature);
      testGetImdbCensorRating('TV-MA', CensorRatingType.mature);
      testGetImdbCensorRating('M', CensorRatingType.mature);
      testGetImdbCensorRating('MA', CensorRatingType.mature);
      testGetImdbCensorRating('GY', CensorRatingType.mature);
      testGetImdbCensorRating('D', CensorRatingType.mature);
      testGetImdbCensorRating('LH', CensorRatingType.mature);

      testGetImdbCensorRating('PG13', CensorRatingType.family);
      testGetImdbCensorRating('VM6', CensorRatingType.family);
      testGetImdbCensorRating('T', CensorRatingType.family);
      testGetImdbCensorRating('TV-Y', CensorRatingType.kids);
      testGetImdbCensorRating('TV-G', CensorRatingType.family);
      testGetImdbCensorRating('TV-PG', CensorRatingType.family);
      testGetImdbCensorRating('TV-Y7', CensorRatingType.family);
      testGetImdbCensorRating('Approved', CensorRatingType.family);
      testGetImdbCensorRating('PG-13', CensorRatingType.family);
      testGetImdbCensorRating('R13', CensorRatingType.family);
      testGetImdbCensorRating('RP13', CensorRatingType.family);
      testGetImdbCensorRating('12A', CensorRatingType.family);
      testGetImdbCensorRating('PG12', CensorRatingType.family);
      testGetImdbCensorRating('12PG', CensorRatingType.family);
      testGetImdbCensorRating('TE', CensorRatingType.family);
      testGetImdbCensorRating('Teen', CensorRatingType.family);
      testGetImdbCensorRating('S', CensorRatingType.family);
      testGetImdbCensorRating('G', CensorRatingType.family);
      testGetImdbCensorRating('PG', CensorRatingType.family);
      testGetImdbCensorRating('T', CensorRatingType.family);
      testGetImdbCensorRating('B', CensorRatingType.family);

      testGetImdbCensorRating('C', CensorRatingType.kids);
      testGetImdbCensorRating('Y', CensorRatingType.kids);
      testGetImdbCensorRating('TV-Y', CensorRatingType.kids);
      testGetImdbCensorRating('U', CensorRatingType.kids);
      testGetImdbCensorRating('Btl', CensorRatingType.kids);
      testGetImdbCensorRating('TP', CensorRatingType.kids);
      testGetImdbCensorRating('0', CensorRatingType.kids);
      testGetImdbCensorRating('0+', CensorRatingType.kids);
      testGetImdbCensorRating('A', CensorRatingType.kids);
      testGetImdbCensorRating('All', CensorRatingType.kids);
      testGetImdbCensorRating('AL', CensorRatingType.kids);
      testGetImdbCensorRating('AA', CensorRatingType.kids);
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
          startsWith(
            'Json decode failed!',
          ),
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
          startsWith(
            'Fast parse unsuccessful, try a slow parse!',
          ),
        ),
      );
      expect(() => fastParse(input), expectedOutput);
    });
  });
}
