import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_movie_search/movies/data_model/movie_result_dto.dart';

// database table and column names
final String tableMovie = 'Movie';
final String colMovieId = '_id';
final String colMovieUniqueId = 'uniqueId';
final String colMovieJson = 'json';

// data model class
class MovieModel {
  int id;
  String uniqueId;
  String dtoJson;

  MovieModel({required this.id, required this.uniqueId, required this.dtoJson});

  // convenience method to create a Map from this MovieModel object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colMovieUniqueId: uniqueId,
      colMovieJson: dtoJson,
      colMovieId: id,
    };
    return map;
  }

  MovieResultDTO toMovieResultDTO() {
    var map = json.decode(dtoJson);
    return map.ToMovieResultDTO;
  }
}

extension ModelConversion on Map {
  MovieModel toMovieModel() => MovieModel(
        id: this[colMovieId]!,
        uniqueId: this[colMovieUniqueId]!,
        dtoJson: this[colMovieJson]!,
      );
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyMovieSearch.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

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
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableMovie (
                $colMovieId INTEGER PRIMARY KEY,
                $colMovieUniqueId TEXT NOT NULL,
                $colMovieJson INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(MovieModel movie) async {
    Database db = await database;
    int id = await db.insert(tableMovie, movie.toMap());
    return id;
  }

  Future<int> update(MovieModel movie) async {
    Database db = await database;
    int id = await db.update(
      tableMovie,
      movie.toMap(),
      where: '$colMovieId = ?',
      whereArgs: [movie.id],
    );
    return id;
  }

  Future<int> delete(MovieModel movie) async {
    Database db = await database;
    int id = await db.delete(
      tableMovie,
      where: '$colMovieId = ?',
      whereArgs: [movie.id],
    );
    return id;
  }

  Future<MovieModel?> queryMovie(int id) async {
    Database db = await database;
    //db.query(tableMovie) can be used to return a list of every row as a Map.
    List<Map> movieMap = await db.query(
      tableMovie,
      columns: [colMovieId, colMovieUniqueId, colMovieJson],
      where: '$colMovieId = ?',
      whereArgs: [id],
    );
    if (movieMap.length > 0) {
      return movieMap.first.toMovieModel();
    }
    return null;
  }

  Future<List<Map>> queryAllMovies() async {
    Database db = await database;
    List<Map> movieMap = await db.query(tableMovie);
    return movieMap;
  }
}
