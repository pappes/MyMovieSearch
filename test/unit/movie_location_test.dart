import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:quiver/iterables.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  group('Movie location test data', () {
    // Formatted time includes the correct values.
    test(
      'default backup data',
      () async {
        await MovieLocation().init();
        final actualOutput = MovieLocation().getLocationsForMovie('tt0033467');
        const expectedOutput = [
          StackerAddress(libNum: '002', location: '044', dvdId: '1254'),
          StackerAddress(libNum: '002', location: '045', dvdId: '1255'),
        ];
        expect(actualOutput[0], expectedOutput[0]);
        expect(actualOutput[1], expectedOutput[1]);
      },
    );
    test(
      'getLocationsForMovie',
      () async {
        await MovieLocation().init();
        const contents = StackerContents(
          uniqueId: 'tt111111111',
          titleName: 'Batman',
        );
        const address = StackerAddress(libNum: '007', location: '001');
        MovieLocation().clear();
        MovieLocation().storeMovieAtLocation(contents, address);
        final actualOutput =
            MovieLocation().getLocationsForMovie(contents.uniqueId);
        final expectedOutput = [address];
        expect(actualOutput, expectedOutput);
      },
    );
    test(
      'getMoviesAtLocation',
      () async {
        await MovieLocation().init();
        const contents =
            StackerContents(uniqueId: 'tt111111111', titleName: 'Batman');
        const address = StackerAddress(libNum: '007', location: '002');
        MovieLocation().clear();
        MovieLocation().storeMovieAtLocation(contents, address);
        final actualOutput = MovieLocation().getMoviesAtLocation(address);
        final expectedOutput = [contents];
        expect(actualOutput, expectedOutput);
      },
    );
    test(
      'add second record',
      () async {
        await MovieLocation().init();
        const contents = StackerContents(
          uniqueId: 'tt111111111',
          titleName: 'Batman',
        );
        const address1 = StackerAddress(libNum: '007', location: '003');
        const address2 = StackerAddress(libNum: '007', location: '004');
        MovieLocation().clear();
        MovieLocation().storeMovieAtLocation(contents, address1);
        MovieLocation().storeMovieAtLocation(contents, address2);
        final actualOutput =
            MovieLocation().getLocationsForMovie(contents.uniqueId);
        final expectedOutput = [address1, address2];
        expect(actualOutput, expectedOutput);
      },
    );
    test(
      'usedLocations',
      () async {
        await MovieLocation().init();
        const contents = StackerContents(
          uniqueId: 'tt111111111',
          titleName: 'Batman',
        );
        const address1 = StackerAddress(libNum: '007', location: '001');
        const address2 = StackerAddress(libNum: '007', location: '150');
        MovieLocation().clear();

      for (final i in range(2, 150)) {
          MovieLocation().storeMovieAtLocation(
            contents,
            StackerAddress(
              libNum: '007',
              location: i.toString().padLeft(3, '0'),
            ),
          );
        }
        final actualOutput = MovieLocation().emptyLocations('007');
        final expectedOutput = [address1, address2];
        expect(actualOutput, expectedOutput);
      },
    );
    test(
      'dvdlocations',
      () async {
        await MovieLocation().init();
        MovieLocation().clear();
        final data = await MovieLocation().getUnmatchedDvds();
        expect(data.length, 1440);
      },
    );

    test('getTitlesForMovie returns empty list for non-existent movie', () {
      final movieLocation = MovieLocation();
      MovieLocation().clear();
      expect(movieLocation.getTitlesForMovie('non-existent-movie'), isEmpty);
    });

    test('getTitlesForMovie returns matching titles for existing movie', () {
      final movieLocation = MovieLocation();

      const title1 = StackerContents(
        uniqueId: 'existing-movie',
        titleName: 'Movie Title 1',
      );
      const title2 = StackerContents(
        uniqueId: 'existing-movie',
        titleName: 'Movie Title 2',
      );
      const title3 = StackerContents(
        uniqueId: 'existing-movie',
        titleName: 'Movie Title 2',
      );
      const address1 = StackerAddress(libNum: '123', location: '456');
      const address2 = StackerAddress(libNum: '789', location: '012');
      MovieLocation().clear();
      MovieLocation().storeMovieAtLocation(title1, address1);
      MovieLocation().storeMovieAtLocation(title2, address2);
      MovieLocation().storeMovieAtLocation(title3, address2);

      final titles = movieLocation.getTitlesForMovie('existing-movie');
      expect(titles.length, equals(2));
      expect(titles.first.uniqueId, equals('existing-movie'));
      expect(titles.first.libNum, equals('123'));
      expect(titles.first.location, equals('456'));
      expect(titles.first.title, equals('Movie Title 1'));
      expect(titles.last.uniqueId, equals('existing-movie'));
      expect(titles.last.libNum, equals('789'));
      expect(titles.last.location, equals('012'));
      expect(titles.last.title, equals('Movie Title 2'));
    });
  });
}
