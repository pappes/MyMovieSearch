import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';

////////////////////////////////////////////////////////////////////////////////
/// Unit tests
////////////////////////////////////////////////////////////////////////////////

Future<void> main() async {
  group('Movie location test data', () {
    // Formatted time includes the correct values.
    test(
      'default test data',
      () {
        const contents = StackerContents(
          uniqueId: 'tt1111422',
          titleName: 'Batman',
        );
        final actualOutput = MovieLocation().getLocationsForMovie(contents);
        const expectedOutput = [
          StackerAddress(libNum: '007', location: '008'),
          StackerAddress(libNum: '007', location: '009'),
        ];
        expect(actualOutput[0], expectedOutput[0]);
        expect(actualOutput[1], expectedOutput[1]);
      },
    );
    test(
      'getLocationsForMovie',
      () {
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
      () {
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
      () {
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
      () {
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
        final expectedOutput = [address1.location, address2.location];
        expect(actualOutput, expectedOutput);
      },
    );
    test(
      'dvdlocations',
      () async {
        final data = await MovieLocation().getUnmatchedDvds();
        expect(data.length, 1440);
      },
    );
  });
}
