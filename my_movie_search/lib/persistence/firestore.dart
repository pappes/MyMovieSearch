// database table and column names
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final String tableMovie = 'movies';
final String lastAccess = 'lastAccess';

// singleton class to manage the database
class DatabaseHelper {
  // Database helper methods:
  Future<void> addMovie(MovieResultDTO movie) {
    Map<String, dynamic> map = movie.toMap();
    map[lastAccess] = FieldValue.serverTimestamp();

    var table = FirebaseFirestore.instance.collection(tableMovie);
    return table.doc(movie.uniqueId).set(map, SetOptions(merge: true));
  }
}
