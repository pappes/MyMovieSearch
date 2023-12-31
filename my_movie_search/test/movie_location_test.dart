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
        final actualOutput = MovieLocation().getLocationsForMovie('tt1111422');
        final expectedOutput = [
          StackerAddress(libNum: '007', location: '008'),
          StackerAddress(libNum: '007', location: '009'),
        ];
        expect(actualOutput.toString(), expectedOutput.toString());
      },
    );
    test(
      'getLocationsForMovie',
      () {
        final contents = StackerContents(
          uniqueId: 'tt111111111',
          titleName: 'Batman',
        );
        final address = StackerAddress(libNum: '007', location: '001');
        MovieLocation().clear();
        MovieLocation().storeMovieAtLocation(contents, address);
        final actualOutput =
            MovieLocation().getLocationsForMovie(contents.uniqueId);
        final expectedOutput = [address];
        expect(actualOutput.toString(), expectedOutput.toString());
      },
    );
    test(
      'getMoviesAtLocation',
      () {
        final contents =
            StackerContents(uniqueId: 'tt111111111', titleName: 'Batman');
        final address = StackerAddress(libNum: '007', location: '002');
        MovieLocation().clear();
        MovieLocation().storeMovieAtLocation(contents, address);
        final actualOutput = MovieLocation().getMoviesAtLocation(address);
        final expectedOutput = [contents];
        expect(actualOutput.toString(), expectedOutput.toString());
      },
    );
    test(
      'add second record',
      () {
        final contents = StackerContents(
          uniqueId: 'tt111111111',
          titleName: 'Batman',
        );
        final address1 = StackerAddress(libNum: '007', location: '003');
        final address2 = StackerAddress(libNum: '007', location: '004');
        MovieLocation().clear();
        MovieLocation().storeMovieAtLocation(contents, address1);
        MovieLocation().storeMovieAtLocation(contents, address2);
        final actualOutput =
            MovieLocation().getLocationsForMovie(contents.uniqueId);
        final expectedOutput = [address1, address2];
        expect(actualOutput.toString(), expectedOutput.toString());
      },
    );
  });
}
