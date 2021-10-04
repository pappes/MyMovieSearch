// database table and column names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const _tableMovie = 'movies';
const _lastAccess = '_lastAccess';

// singleton class to manage the database
class DatabaseHelper {
  // Database helper methods:
  Future<void> addMovie(MovieResultDTO movie) {
    final Map<String, dynamic> map = movie.toMap();
    map[_lastAccess] = FieldValue.serverTimestamp();

    final table = FirebaseFirestore.instance.collection(_tableMovie);
    return table.doc(movie.uniqueId).set(map, SetOptions(merge: true));
  }
}
