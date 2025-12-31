import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:quiver/iterables.dart';
import 'package:universal_io/io.dart';

/// Cache of movies and locations to allow location data to be easily displayed.
class MovieLocation {
  /// Public constructor returns a singleton.
  factory MovieLocation() => _instance ??= MovieLocation._internal();

  MovieLocation._internal() {
    unawaited(init());
  }
  static MovieLocation? _instance;

  Future<void>? _initialised;
  final _movies = <String, List<StackerAddress>>{};
  final _locations = <StackerAddress, List<StackerContents>>{};
  final _initCompleter = Completer<bool>();

  /// Load data from the cloud only once.
  Future<void> init() async {
    _initialised ??= Platform.isLinux
        ? _loadLinuxLocationData(_initCompleter)
        : _loadAndroidLocationData(_initCompleter);
    await _initCompleter.future;
  }

  /// Removes all entries from the cache.
  void clear() {
    _movies.clear();
    _locations.clear();
  }

  /// Removes all entries from the cache.
  Map<String, num> statistics() => {
    'movies': _movies.length,
    'locations': _locations.length,
  };

  /// [List] of movies known to be stored at [location]
  List<StackerContents> getMoviesAtLocation(StackerAddress location) =>
      _locations[location] ?? [];

  /// [List] of locations known to hold movie keyed by uniqueId
  List<StackerAddress> getLocationsForMovie(String uniqueId) =>
      _movies[uniqueId] ?? [];

  /// Remove a movie from a specific location
  ///
  /// May be prolematic if used when looping through locations or movies!
  Future<bool> deleteLocationForMovie(
    StackerAddress location,
    String movieTtile,
  ) async {
    final movies = getMoviesAtLocation(location);
    for (final movie in movies) {
      if (movie.titleName == movieTtile) {
        _locations[location]?.remove(movie);
        _movies[movie.uniqueId]?.remove(location);
        await _writeToCloud(movie);
        return true;
      }
    }
    return false;
  }

  /// Remove all locations associated with a movie
  Future<dynamic> deleteAllLocationsForMovie(String uniqueId) async {
    if (_movies.containsKey(uniqueId) && _movies[uniqueId]!.isNotEmpty) {
      for (final location in getLocationsForMovie(uniqueId)) {

        void deleteMovie(StackerContents contents) =>
            _locations[location]?.remove;

        // build up list of deletions while iterating,
        // then delete when not iterating.
        final deletions = <StackerContents>[];
        for (final movie in getMoviesAtLocation(location)) {
          if (movie.uniqueId == uniqueId) deletions.add(movie);
        }
        deletions.forEach(deleteMovie);
      }

      _movies[uniqueId]!.clear();
      final id = StackerContents(uniqueId: uniqueId, titleName: '');
      return _writeToCloud(id);
    }
    return false;
  }

  /// Store location of movie.
  void storeMovieAtLocation(StackerContents movie, StackerAddress location) {
    if (_writeToCache(movie, location)) unawaited(_writeToCloud(movie));
  }

  Future<List<MovieResultDTO>> getUnmatchedDvds() async {
    // Wait for stream to be populated with data.
    await init();
    // Wait for data to be consumed from the stream.
    await Future<void>.delayed(const Duration(seconds: 1));

    final dtos = <MovieResultDTO>[];
    for (final dvd in await _getDvds()) {
      if (!_locations.keys.contains(dvd['location'])) {
        dtos.add(dvd['dto'] as MovieResultDTO);
      }
    }
    return dtos;
  }

  /// [StackerAddress] location values
  /// not used to store any movies in [libNum].
  Iterable<StackerAddress> emptyLocations(String libNum) sync* {
    for (final i in range(1, 151)) {
      final str = i.toString().padLeft(3, '0');
      final location = StackerAddress(libNum: libNum, location: str);
      if (!_locations.containsKey(location)) yield location;
    }
  }

  /// [StackerAddress] location values
  /// currently used to store movies in [libNum].
  Map<String, String> usedLocations(String libNum) {
    // final locations = SplayTreeSet<String>();
    final locations = SplayTreeMap<String, String>(); // Sorted map keys.
    for (final address in _locations.keys) {
      if (address.libNum == libNum) {
        final movies = getMoviesAtLocation(address);
        if (movies.isNotEmpty) {
          locations[address.location] = movies.first.titleName;
        }
      }
    }

    return locations;
  }

  /// [StackerAddress] LibNum values not used to store any movies.
  Iterable<String> emptyLibNums() sync* {
    final used = usedLibNums();
    for (final i in range(1, 101)) {
      final str = i.toString().padLeft(3, '0');
      if (!used.contains(str)) yield str;
    }
  }

  /// [StackerAddress] LibNum values currently used to store movies.
  Iterable<String> usedLibNums() {
    final locations = SplayTreeSet<String>(); // Sorted Set
    for (final address in _locations.keys) {
      if (!locations.contains(address.libNum)) locations.add(address.libNum);
    }

    return locations;
  }

  /// Reload in-memory cache ready for exporting
  ///
  /// To update backup data and search engine data run tests in
  /// test/persistance/firebase_backup_is_not_a_test.dart
  Future<Map<String, dynamic>> getBackupData({bool clearCache = true}) async {
    // Wait for stream to be populated with initial data.
    await init();
    // Wait for data to be consumed from the stream.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (clearCache) {
      clear();

      final streamSubscription = FirebaseApplicationState()
          .fetchRecords('/dvds')
          .listen(_cloudDataReceived);

      await Future<void>.delayed(const Duration(seconds: 10));
      await streamSubscription.cancel();
    }
    final movies = <String, dynamic>{};
    for (final uniqueId in _movies.keys) {
      movies[uniqueId] = getTitlesForMovie(uniqueId);
    }
    return movies;
  }

  /// Find all titles associated with [uniqueId]
  /// and the loactions where they are stored.
  List<DenomalizedLocation> getTitlesForMovie(String uniqueId) {
    final titles = <DenomalizedLocation>[];
    for (final location in getLocationsForMovie(uniqueId)) {
      for (final content in getMoviesAtLocation(location)) {
        if (content.uniqueId == uniqueId) {
          titles.add(
            DenomalizedLocation(
              uniqueId: uniqueId,
              libNum: location.libNum,
              location: location.location,
              dvdId: location.dvdId,
              title: content.titleName,
            ),
          );
        }
      }
    }
    return titles;
  }

  /// Insert a record into the memory cache.
  ///
  /// Returns false if the movie title was already in the cache.
  bool _writeToCache(StackerContents movie, StackerAddress location) {
    _movies[movie.uniqueId] ??= [];
    _locations[location] ??= [];
    if (!_movies[movie.uniqueId]!.contains(location)) {
      _movies[movie.uniqueId]!.add(location);
    }
    if (!_locations[location]!.contains(movie)) {
      _locations[location]!.add(movie);
      return true;
    }
    return false;
  }

  /// Insert a record into the cloud datastore.
  Future<dynamic>? _writeToCloud(StackerContents movie) {
    final locations = <String>[];
    for (final location in getLocationsForMovie(movie.uniqueId)) {
      locations.add(DvdLocation(location, movie).encode());
    }
    return FirebaseApplicationState().addRecord(
      '/dvds',
      id: movie.uniqueId,
      message: jsonEncode(locations),
    );
  }

  Future<void> _loadAndroidLocationData(Completer<bool> completer) async {
    await _loadBackupLocationData();
    unawaited(_loadCloudLocationData(completer));
  }

  Future<void> _loadLinuxLocationData(Completer<bool> completer) async {
    await _loadBackupLocationData();
    completer.complete(true);
  }

  // To update backup data run createBackupData() in
  // test/persistance/firebase_backup_is_not_a_test.dart
  // then copy data from /tmp/firebaseBackupXXXX.txt to
  // assets/newDVDLibrary.json
  // and update lastFirebaseBackupDate with 
  // the new timestamp that is printed to console during execution of the test.
  static const lastFirebaseBackupDate = 1719017443517;
  // DateTime().millisecondsSinceEpoch

  Future<void> _loadBackupLocationData() async {
    // Manually initalise flutter to ensure setting can be loaded before RunApp
    // and to ensure tests are not prevented from calling real http enpoints
    WidgetsFlutterBinding.ensureInitialized();

    const location = 'assets/newDVDLibrary.json';
    final json = await rootBundle.loadString(location);
    final movies = jsonDecode(json) as Map<String, dynamic>;

    for (final movie in movies.entries) {
      final locations = movie.value;
      if (locations is Iterable) {
        for (final location in locations) {
          if (location is Map) {
            final address = StackerAddress(
              libNum: location[Fields.libnum.name].toString(),
              location: location[Fields.location.name].toString(),
              dvdId: location[Fields.dvdId.name]?.toString(),
            );
            final contents = StackerContents(
              uniqueId: location[Fields.id.name].toString(),
              titleName: location[Fields.title.name].toString(),
            );
            _writeToCache(contents, address);
          }
        }
      }
    }
  }

  Future<void> _loadCloudLocationData(Completer<bool> completer) async {
    final streamSubscription = FirebaseApplicationState()
        .fetchRecords(
          '/dvds',
          filterFieldPath: 'timestamp',
          isGreaterThan: lastFirebaseBackupDate,
          initalDataLoadComplete: completer,
        )
        .listen(_cloudDataReceived);
    await streamSubscription.asFuture<dynamic>();
    await streamSubscription.cancel();
  }

  void _cloudDataReceived(dynamic event) {
    if (event is Map && event.isNotEmpty) {
      final locations = jsonDecode(event.values.first.toString());
      if (locations is Iterable) {
        for (final encodedLocation in locations) {
          final location = DvdLocation()..decode(encodedLocation.toString());
          if (location.movie != null && location.address != null) {
            _writeToCache(location.movie!, location.address!);
          }
        }
      }
    }
  }

  /// Returns a [List] containing a map with keys:
  ///    'location':[StackerAddress],
  ///    'title':[String]
  ///    'dto':[MovieResultDTO]
  Future<List<Map<String, dynamic>>> _getDvds() async {
    final allDvds = <Map<String, dynamic>>[];
    final rawContent = await _loadDvdFile();
    final table = rawContent.last as Map;
    final cdlib = table['data'] as List;

    for (final oldDvd in cdlib) {
      oldDvd as List;

      final newDvd = <String, dynamic>{};
      newDvd['location'] = StackerAddress(
        libNum: oldDvd[DvdColumns.libnum.index].toString().padLeft(3, '0'),
        location: oldDvd[DvdColumns.location.index].toString().padLeft(3, '0'),
        dvdId: oldDvd[DvdColumns.id.index].toString(),
      );
      newDvd['title'] = oldDvd[DvdColumns.title.index].toString();
      newDvd['dto'] = MovieResultDTO().init(
        uniqueId: oldDvd[DvdColumns.id.index].toString(),
        title: oldDvd[DvdColumns.title.index].toString(),
        alternateTitle: oldDvd[DvdColumns.artist.index].toString(),
        creditsOrder: oldDvd[DvdColumns.libnum.index].toString(), // Stacker
        userRatingCount: oldDvd[DvdColumns.location.index].toString(), // Disk
        type: MovieContentType.searchprompt.name,
        yearRange: oldDvd[DvdColumns.year.index].toString(),
      );
      allDvds.add(newDvd);
    }

    return allDvds;
  }

  Future<List<dynamic>> _loadDvdFile() async {
    // Manually initalise flutter to ensure setting can be loaded before RunApp
    // and to ensure tests are not prevented from calling real http enpoints
    WidgetsFlutterBinding.ensureInitialized();

    const location = 'assets/OldCDLibrary.json';
    final json = await rootBundle.loadString(location);
    return jsonDecode(json) as List<dynamic>;
  }
}

enum DvdColumns {
  id,
  libnum,
  location,
  title,
  artist,
  disctype,
  genre,
  year,
  rootname,
  details,
  frontimg,
  cdkey,
  comments,
}

enum Fields { libnum, location, dvdId, id, title }

/// Combination of all movie and location data.
class DenomalizedLocation {
  DenomalizedLocation({
    required this.uniqueId,
    required this.title,
    required this.libNum,
    required this.location,
    required this.dvdId,
  });
  DenomalizedLocation.combine(
    StackerContents contents,
    StackerAddress address,
  ) {
    uniqueId = contents.uniqueId;
    title = contents.titleName;
    libNum = address.libNum;
    location = address.location;
    dvdId = address.dvdId;
  }

  late String uniqueId;
  late String title;
  late String libNum;
  late String location;
  String? dvdId;

  /// Convert a [StackerAddress] to a json encodeable primitive.
  ///
  Map<String, String?> toJson() => {
    Fields.id.name: uniqueId,
    Fields.title.name: title,
    Fields.libnum.name: libNum,
    Fields.location.name: location,
    Fields.dvdId.name: dvdId,
  };
}

/// Position of the movie
///
/// including stacker [libNum], slot [location] and sometimes dvdId[dvdId].
///
@immutable
class StackerAddress implements Comparable<StackerAddress> {
  const StackerAddress({
    required this.libNum,
    required this.location,
    this.dvdId,
  });
  final String libNum;
  final String location;
  final String? dvdId;

  @override
  String toString() => 'libNum:$libNum, location:$location, dvdId:$dvdId';

  @override
  int compareTo(StackerAddress other) {
    // Do not include dvdId in comparison!
    final libcompare = libNum.compareTo(other.libNum);
    return (libcompare != 0) ? libcompare : location.compareTo(other.location);
  }

  // Override hashCode using the static hashing methods
  // provided by the `Object` class.
  //
  // Do not include dvdId in hash!
  @override
  int get hashCode => Object.hash(libNum, location);

  // You should generally implement operator `==` if you
  // override `hashCode`.
  @override
  bool operator ==(Object other) =>
      // Do not include dvdId in comparison!
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

/// Position of the movie including stacker/slot [address] and id/title [movie].
///
class DvdLocation {
  DvdLocation([this.address, this.movie]);
  StackerAddress? address;
  StackerContents? movie;

  @override
  String toString() => 'address:{$address}, movie:{$movie}';

  String encode() {
    if (address == null || movie == null) return '';
    return jsonEncode({
      Fields.libnum.name: address!.libNum,
      Fields.location.name: address!.location,
      Fields.dvdId.name: address!.dvdId,
      Fields.id.name: movie!.uniqueId,
      Fields.title.name: movie!.titleName,
    });
  }

  void decode(String json) {
    final map = jsonDecode(json) as Map;
    address = StackerAddress(
      libNum: map[Fields.libnum.name] as String,
      location: map[Fields.location.name] as String,
      dvdId: map[Fields.dvdId.name] as String?,
    );
    movie = StackerContents(
      uniqueId: map[Fields.id.name] as String,
      titleName: map[Fields.title.name] as String,
    );
  }
}
