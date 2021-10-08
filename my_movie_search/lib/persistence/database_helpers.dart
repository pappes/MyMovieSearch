import 'dart:convert' show json;

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:sqflite/sqflite.dart' show Database, openDatabase;

// database table and column names
const _tableMovie = 'Movie';
const _colMovieId = '_id';
const _colMovieUniqueId = 'uniqueId';
const _colMovieJson = 'json';

// data model class
class MovieModel {
  int id;
  String uniqueId;
  String dtoJson;

  MovieModel({required this.id, required this.uniqueId, required this.dtoJson});

  // convenience method to create a Map from this MovieModel object
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      _colMovieUniqueId: uniqueId,
      _colMovieJson: dtoJson,
      _colMovieId: id,
    };
  }

  MovieResultDTO? xtoMovieResultDTO() {
    final decoded = json.decode(dtoJson);
    if (decoded is Map) {
      return decoded.toMovieResultDTO();
    }
  }
}

extension ModelConversion on Map {
  MovieModel toMovieModel() => MovieModel(
        id: this[_colMovieId]! as int,
        uniqueId: this[_colMovieUniqueId]!.toString(),
        dtoJson: this[_colMovieJson]!.toString(),
      );
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static const _databaseName = "MyMovieSearch.db";
  // Increment this version when you need to change the schema.
  static const _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // open the database
  Future<Database> _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE $_tableMovie (
        $_colMovieId INTEGER PRIMARY KEY,
        $_colMovieUniqueId TEXT NOT NULL,
        $_colMovieJson INTEGER NOT NULL
      )
      ''',
    );
  }

  // Database helper methods:

  Future<int> insert(MovieModel movie) async {
    final Database db = await database;
    final id = await db.insert(_tableMovie, movie.toMap());
    return id;
  }

  Future<int> update(MovieModel movie) async {
    final Database db = await database;
    final int id = await db.update(
      _tableMovie,
      movie.toMap(),
      where: '$_colMovieId = ?',
      whereArgs: [movie.id],
    );
    return id;
  }

  Future<int> delete(MovieModel movie) async {
    final Database db = await database;
    final int id = await db.delete(
      _tableMovie,
      where: '$_colMovieId = ?',
      whereArgs: [movie.id],
    );
    return id;
  }

  Future<MovieModel?> queryMovie(int id) async {
    final Database db = await database;
    //db.query(tableMovie) can be used to return a list of every row as a Map.
    final List<Map> movieMap = await db.query(
      _tableMovie,
      columns: [_colMovieId, _colMovieUniqueId, _colMovieJson],
      where: '$_colMovieId = ?',
      whereArgs: [id],
    );
    if (movieMap.isNotEmpty) {
      return movieMap.first.toMovieModel();
    }
    return null;
  }

  Future<List<Map>> queryAllMovies() async {
    final Database db = await database;
    return db.query(_tableMovie);
  }
}
