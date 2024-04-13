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

extension ModelConversion on Map<dynamic, dynamic> {
  MovieModel toMovieModel() => MovieModel(
        uniqueId: this[_colMovieUniqueId]!.toString(),
        dtoJson: this[_colMovieJson]!.toString(),
      );
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

  // open the database
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

  Future<String> _getDbLocation() async {
    var location = '/tmp';
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      // For testing the PathProvider is not set up correctly
      // so need special handling
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

  // SQL string to create the database
  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $_tableMovie (
        $_colMovieUniqueId TEXT PRIMARY KEY,
        $_colMovieJson INTEGER NOT NULL
      )
      ''',
    );
  }

  // Database helper methods:

  Future<int> insert(MovieModel movie) async {
    final Database db = await database;
    final id = await db.insert(
      _tableMovie,
      movie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> update(MovieModel movie) async {
    final Database db = await database;
    final int id = await db.update(
      _tableMovie,
      movie.toMap(),
      where: '$_colMovieUniqueId = ?',
      whereArgs: [movie.uniqueId],
    );
    return id;
  }

  Future<int> delete(MovieModel movie) async {
    final Database db = await database;
    final int id = await db.delete(
      _tableMovie,
      where: '$_colMovieUniqueId = ?',
      whereArgs: [movie.uniqueId],
    );
    return id;
  }

  Future<MovieModel?> queryMovieUniqueId(String uniqueId) async {
    final Database db = await database;
    //db.query(tableMovie) can be used to return a list of every row as a Map.
    final List<Map<dynamic, dynamic>> movieMap = await db.query(
      _tableMovie,
      columns: [_colMovieUniqueId, _colMovieJson],
      where: '$_colMovieUniqueId = ?',
      whereArgs: [uniqueId],
    );
    if (movieMap.isNotEmpty) {
      return movieMap.first.toMovieModel();
    }
    return null;
  }

  Future<List<Map<dynamic, dynamic>>> queryAllMovies() async {
    final Database db = await database;
    return db.query(_tableMovie);
  }
}
