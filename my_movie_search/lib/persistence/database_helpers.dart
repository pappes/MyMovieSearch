import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableMovie = 'Movie';
final String colMovieId = '_id';
final String colMovieUniqueId = 'uniqueId';
final String colMovieJson = 'json';

// data model class
class MovieModel extends MovieDetailsDTO {
  int id;
  String uniqueId;
  String json;

  MovieModel();

  // convenience constructor to create a Word object
  MovieModel.fromMap(Map<String, dynamic> map) {
    id = map[colMovieId];
    uniqueId = map[colMovieUniqueId];
    json = map[colMovieJson];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colMovieUniqueId: uniqueId,
      colMovieJson: json,
    };
    if (id != null) {
      map[colMovieId] = id;
    }
    return map;
  }
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
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
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

  Future<int> insert(MovieModel word) async {
    Database db = await database;
    int id = await db.insert(tableMovie, word.toMap());
    return id;
  }

  Future<MovieModel> queryWord(int id) async {
    Database db = await database;
    //db.query(tableMovie) returns a list of every row as a Map.
    List<Map> movieMap = await db.query(tableMovie,
        columns: [colMovieId, colMovieUniqueId, colMovieJson],
        where: '$colMovieId = ?',
        whereArgs: [id]);
    if (movieMap.length > 0) {
      return MovieModel.fromMap(movieMap.first);
    }
    return null;
  }

  // TODO: queryAllWords()
  // TODO: delete(int id)
  // TODO: update(Word word)
}
