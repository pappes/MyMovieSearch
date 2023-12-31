/// Position of the movie including stacker [libNum] and slot [location].
class StackerAddress {
  StackerAddress({required this.libNum, required this.location});
  String libNum;
  String location;

  @override
  String toString() => 'libNum:$libNum, location:$location';
}

/// Contents of the location including key [uniqueId]
/// and description [titleName].
class StackerContents {
  StackerContents({required this.uniqueId, required this.titleName});
  String uniqueId;
  String titleName;

  @override
  String toString() => 'uniqueId:$uniqueId, titleName:$titleName';
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

  /// [List] of locations known to hold movie keyed by [uniqueId]
  List<StackerAddress> getLocationsForMovie(String uniqueId) =>
      _movies[uniqueId] ?? [];
  void storeMovieAtLocation(StackerContents movie, StackerAddress location) {
    _movies[movie.uniqueId] ??= [];
    _movies[movie.uniqueId]!.add(location);
    _locations[location] ??= [];
    _locations[location]!.add(movie);
  }

  // will be deleted.
  void _loadTestData() {
    storeMovieAtLocation(
      StackerContents(
        uniqueId: 'tt1111422',
        titleName: 'The taking of Pelham 123 [box set]',
      ),
      StackerAddress(libNum: '007', location: '008'),
    );
    storeMovieAtLocation(
      StackerContents(
        uniqueId: 'tt1111422',
        titleName: 'The taking of Pelham 123 [directors cut]',
      ),
      StackerAddress(libNum: '007', location: '009'),
    );
  }
}
