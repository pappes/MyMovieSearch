import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

void testContent(
  MovieContentType? type,
  String suffix,
  int? duration,
  String id,
) {
  final info = 'movie name$suffix';
  const title = 'movie name';
  expect(
    findImdbMovieContentTypeFromTitle(info, title, duration, id),
    type,
    reason: 'unexpected value returned from findImdbMovieContentTypeFromTitle',
  );
  expect(
    getImdbMovieContentType(suffix, duration, id),
    type ?? MovieContentType.movie,
    reason: 'unexpected value returned from getImdbMovieContentType',
  );
}

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

  group('findImdbMovieContentTypeFromTitle movie', () {
    test(
      'normal movie',
      () => testContent(null, '', null, 'tt1234'),
    );
    test(
      'unknown movie',
      () => testContent(null, 'info', null, 'tt1234'),
    );
    test(
      'concise movie',
      () => testContent(MovieContentType.movie, 'movie', null, 'tt1234'),
    );
    test(
      'verbose movie',
      () => testContent(MovieContentType.movie, '(funMovie!)', null, 'tt1234'),
    );
    test(
      'video',
      () => testContent(MovieContentType.movie, 'vhs video', null, 'tt1234'),
    );
    test(
      'feature',
      () => testContent(MovieContentType.movie, 'feature film', null, 'tt1234'),
    );
  });

  group('findImdbMovieContentTypeFromTitle misc', () {
    test('empty string', () => testContent(null, '', null, ''));
    test(
      '30 mins title',
      () => testContent(MovieContentType.short, 'info', 30, ''),
    );
    test(
      'short title',
      () => testContent(MovieContentType.short, 'short', null, ''),
    );
    test(
      'normal person',
      () => testContent(MovieContentType.person, 'info', null, 'nm1234'),
    );
  });

  group('findImdbMovieContentTypeFromTitle not a movie ie game', () {
    test(
      'error',
      () => testContent(MovieContentType.custom, 'info', null, '-1'),
    );
    test(
      'game',
      () => testContent(MovieContentType.custom, 'game', null, 'tt1234'),
    );
    test(
      'creativeWork',
      () =>
          testContent(MovieContentType.custom, 'creativeWork', null, 'tt1234'),
    );
  });

  group('findImdbMovieContentTypeFromTitle episodic', () {
    test(
      'miniseries',
      () => testContent(
        MovieContentType.miniseries,
        'mini series',
        null,
        'tt1234',
      ),
    );
    test(
      'series episode',
      () => testContent(MovieContentType.episode, 'episode', null, 'tt1234'),
    );
    test(
      'tv series',
      () => testContent(MovieContentType.series, 'series', null, 'tt1234'),
    );
    test(
      'tv series special',
      () => testContent(MovieContentType.series, 'special', null, 'tt1234'),
    );
  });
}
