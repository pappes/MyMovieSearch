import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';

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
        const contents = StackerContents(
          uniqueId: 'tt0033467',
          titleName: 'Batman',
        );
        final actualOutput = MovieLocation().getLocationsForMovie(contents);
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
        final actualOutput = MovieLocation().getLocationsForMovie(contents);
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
        final actualOutput = MovieLocation().getLocationsForMovie(contents);
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

        for (int i = 2; i <= 149; i++) {
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
  });
}
