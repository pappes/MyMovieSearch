import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_movie_search/firebase_app_state.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

enum Fields {
  libnum,
  location,
  dvdId,
  id,
  title,
}

/// Position of the movie including stacker [libNum] and slot [location].
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

  /// Load data from the cloud only once.
  Future<void> init() async {
    _initialised ??= _loadCloudLocationData();
    await _initialised;
  }

  /// Removes all entries from the cache.
  void clear() {
    _movies.clear();
    _locations.clear();
  }

  /// [List] of movies known to be stored at [location]
  List<StackerContents> getMoviesAtLocation(StackerAddress location) =>
      _locations[location] ?? [];

  /// [List] of locations known to hold movie keyed by [movie].uniqueId
  List<StackerAddress> getLocationsForMovie(StackerContents movie) =>
      _movies[movie.uniqueId] ?? [];

  /// Remove a movie from a specific location
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

  /// Store location of movie.
  void storeMovieAtLocation(
    StackerContents movie,
    StackerAddress location,
  ) {
    if (_writeToCache(movie, location)) unawaited(_writeToCloud(movie));
  }

  Future<List<MovieResultDTO>> getUnmatchedDvds() async {
    await init();
    final dtos = <MovieResultDTO>[];
    for (final dvd in await _getDvds()) {
      if (!_locations.keys.contains(dvd['location'])) {
        dtos.add(dvd['dto'] as MovieResultDTO);
      }
    }
    return dtos;
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
    for (final location in getLocationsForMovie(movie)) {
      locations.add(DvdLocation(location, movie).encode());
    }
    return FirebaseApplicationState().addRecord(
      '/dvds',
      id: movie.uniqueId,
      message: jsonEncode(locations),
    );
  }

  /// [StackerAddress] location values
  /// not used to store any movies in [libNum].
  Iterable<StackerAddress> emptyLocations(String libNum) sync* {
    for (int i = 1; i <= 150; i++) {
      final str = i.toString().padLeft(3, '0');
      final location = StackerAddress(
        libNum: libNum,
        location: str,
      );
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
    for (int i = 1; i < 100; i++) {
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

  /// Retrieve the title used for a specific movie at a specifica location.
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

  Future<void> _loadCloudLocationData() async {
    final streamSubscription = FirebaseApplicationState()
        .fetchRecords('/dvds')
        .timeout(
          const Duration(seconds: 5),
          onTimeout: (sink) => sink.close(),
        )
        .listen((event) {
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
    });
    await streamSubscription.asFuture<dynamic>();
    await streamSubscription.cancel();
  }

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
  //MovieResultDTO _dvdToDto(dvd) {}
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
