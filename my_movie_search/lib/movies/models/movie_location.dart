import 'package:meta/meta.dart';

/// Position of the movie including stacker [libNum] and slot [location].
///
@immutable
class StackerAddress implements Comparable<StackerAddress> {
  const StackerAddress({required this.libNum, required this.location});
  final String libNum;
  final String location;

  @override
  String toString() => 'libNum:$libNum, location:$location';

  @override
  int compareTo(StackerAddress other) {
    final libcompare = libNum.compareTo(other.libNum);
    return (libcompare != 0) ? libcompare : location.compareTo(other.location);
  }

  // Override hashCode using the static hashing methods
  // provided by the `Object` class.
  @override
  int get hashCode => Object.hash(libNum, location);

  // You should generally implement operator `==` if you
  // override `hashCode`.
  @override
  bool operator ==(Object other) =>
      other is StackerAddress &&
      other.libNum == libNum &&
      other.location == location;
}

/// Contents of the location including key [uniqueId]
/// and description [titleName].
@immutable
class StackerContents implements Comparable<StackerContents> {
  const StackerContents({required this.uniqueId, required this.titleName});
  final String uniqueId;
  final String titleName;

  @override
  String toString() => 'uniqueId:$uniqueId, titleName:$titleName';

  @override
  int compareTo(StackerContents other) {
    final idcompare = uniqueId.compareTo(other.uniqueId);
    return (idcompare != 0) ? idcompare : titleName.compareTo(other.titleName);
  }

  // Override hashCode using the static hashing methods
  // provided by the `Object` class.
  @override
  int get hashCode => Object.hash(uniqueId, titleName);

  // You should generally implement operator `==` if you
  // override `hashCode`.
  @override
  bool operator ==(Object other) =>
      other is StackerContents &&
      other.uniqueId == uniqueId &&
      other.titleName == titleName;
}

/// Cache of movies and locations to allow location data to be easily displayed.
class MovieLocation {
  /// Public constructor returns a singleton.
  factory MovieLocation() => _instance ??= MovieLocation._internal();

  MovieLocation._internal() {
    _loadTestData();
  }
  static MovieLocation? _instance;

  final _movies = <String, List<StackerAddress>>{};
  final _locations = <StackerAddress, List<StackerContents>>{};

  /// Removes all entries from the cache.
  void clear() {
    _movies.clear();
    _locations.clear();
  }

  /// [List] of movies known to be stroed at
  List<StackerContents> getMoviesAtLocation(StackerAddress location) =>
      _locations[location] ?? [];

  /// [List] of locations known to hold movie keyed by [movie].uniqueId
  List<StackerAddress> getLocationsForMovie(StackerContents movie) =>
      _movies[movie.uniqueId] ?? [];

  void storeMovieAtLocation(StackerContents movie, StackerAddress location) {
    _movies[movie.uniqueId] ??= [];
    _movies[movie.uniqueId]!.add(location);
    _locations[location] ??= [];
    _locations[location]!.add(movie);
  }

  List<StackerAddress> emptyLocations(String libNum) {
    final locations = <StackerAddress>[];
    for (int i = 1; i <= 150; i++) {
      final location = StackerAddress(
        libNum: libNum,
        location: i.toString().padLeft(3, '0'),
      );
      if (!_locations.containsKey(location)) locations.add(location);
    }

    return locations;
  }

  List<StackerAddress> usedLocations(String libNum) {
    final locations = <StackerAddress>[];
    for (final address in _locations.keys) {
      if (address.libNum == libNum) locations.add(address);
    }

    return locations;
  }

  String customTitleForMovieAtLocation(
    StackerAddress location,
    StackerContents movie,
  ) {
    final descriptions = MovieLocation().getMoviesAtLocation(location);
    String title = movie.titleName;
    for (final description in descriptions) {
      if (description.uniqueId == movie.uniqueId) {
        title = description.titleName;
      }
    }
    return title;
  }

  // will be deleted.
  void _loadTestData() {
    storeMovieAtLocation(
      const StackerContents(
        uniqueId: 'tt1111422',
        titleName: 'The taking of Pelham 123 [box set]',
      ),
      const StackerAddress(libNum: '007', location: '008'),
    );
    storeMovieAtLocation(
      const StackerContents(
        uniqueId: 'tt1111422',
        titleName: 'The taking of Pelham 123 [directors cut]',
      ),
      const StackerAddress(libNum: '007', location: '009'),
    );
  }
}
