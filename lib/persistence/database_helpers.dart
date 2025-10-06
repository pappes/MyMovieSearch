import 'dart:convert' show json;

import 'package:mutex/mutex.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
// ignore: depend_on_referenced_packages
import 'package:path_provider_linux/path_provider_linux.dart';
//import 'package:sqflite/sqflite.dart' show Database, openDatabase;

//import 'package:sqflite_common/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:universal_io/io.dart';

// database table and column names
const _tableMovie = 'Movie';
const _colMovieUniqueId = 'uniqueId';
const _colMovieJson = 'json';

// data model class
class MovieModel {
  MovieModel({required this.uniqueId, required this.dtoJson});

  String uniqueId;
  String dtoJson;
  // convenience method to create a Map from this MovieModel object
  Map<String, dynamic> toMap() => <String, dynamic>{
    _colMovieUniqueId: uniqueId,
    _colMovieJson: dtoJson,
  };

  MovieResultDTO? toMovieResultDTO() {
    final decoded = json.decode(dtoJson);
    if (decoded is Map) {
      return decoded.toMovieResultDTO();
    }
    return null;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // This is the actual database filename that is saved in the docs directory.
  static const _databaseName = 'MyMovieSearch.db';
  // Increment this version when you need to change the schema.
  static const _databaseVersion = 1;
  static final mutexLock = Mutex();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    await mutexLock.protect(_initDatabase);

    return _database!;
  }

  /// Open the database.
  Future<void> _initDatabase() async {
    if (_database == null) {
      // Init ffi loader if needed.
      databaseFactory = databaseFactoryFfi;
      sqfliteFfiInit();

      // Open the database.
      _database = await openDatabase(
        await _getDbLocation(),
        version: _databaseVersion,
        onCreate: _onCreate,
      );
    }
  }

  /// Get the path to the database.
  Future<String> _getDbLocation() async {
    var location = '/tmp';
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      // When testing the PathProvider is not set up correctly
      // so need special handling.
      final linuxLocation =
          await PathProviderLinux().getApplicationDocumentsPath();
      if (linuxLocation != null) location = linuxLocation;
    } else {
      // for runtime environments use the runtim PathProvider
      final platformDirectory = await getApplicationDocumentsDirectory();
      location = platformDirectory.path;
    }
    return join(location, _databaseName);
  }

  /// Uas a SQL string to create the database.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableMovie (
        $_colMovieUniqueId TEXT PRIMARY KEY,
        $_colMovieJson INTEGER NOT NULL
      )
      ''');
  }

  // Database helper methods:
  /// Insert a movie record into the database.
  Future<int> insert(MovieModel movie) async {
    final Database db = await database;
    return mutexLock.protect(() => _insert(db, movie));
  }

  /// Update a movie record in the database.
  Future<int> update(MovieModel movie) async {
    final Database db = await database;
    return mutexLock.protect(() => _update(db, movie));
  }

  /// Delete a movie record from the database.
  Future<int> delete(MovieModel movie) async {
    final Database db = await database;
    return mutexLock.protect(() => _delete(db, movie));
  }

  /// Query the database for all stored movie records.
  Future<List<Map<dynamic, dynamic>>> queryAllMovies() async {
    final Database db = await database;
    return mutexLock.protect(() => _queryAllMovies(db));
  }

  /// Query the database for a specific movie record based on its unique ID.
  Future<MovieModel?> queryMovieUniqueId(String uniqueId) async {
    final Database db = await database;
    return mutexLock.protect(() => _queryMovieUniqueId(db, uniqueId));
  }

  Future<int> _insert(Database db, MovieModel movie) => db.insert(
    _tableMovie,
    movie.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );

  Future<int> _update(Database db, MovieModel movie) => db.update(
    _tableMovie,
    movie.toMap(),
    where: '$_colMovieUniqueId = ?',
    whereArgs: [movie.uniqueId],
  );

  Future<int> _delete(Database db, MovieModel movie) => db.delete(
    _tableMovie,
    where: '$_colMovieUniqueId = ?',
    whereArgs: [movie.uniqueId],
  );

  Future<List<Map<dynamic, dynamic>>> _queryAllMovies(Database db) =>
      db.query(_tableMovie);

  /// Query the database for a specific movie record based on its unique ID.
  Future<MovieModel?> _queryMovieUniqueId(Database db, String uniqueId) async {
    final movieMap = await db.query(
      _tableMovie,
      columns: [_colMovieUniqueId, _colMovieJson],
      where: '$_colMovieUniqueId = ?',
      whereArgs: [uniqueId],
    );
    // If a movie record is found, return the corresponding MovieModel object.
    if (movieMap.isNotEmpty) {
      final map = movieMap.first;
      return MovieModel(
        uniqueId: map[_colMovieUniqueId]!.toString(),
        dtoJson: map[_colMovieJson]!.toString(),
      );
    }
    return null;
  }
}
