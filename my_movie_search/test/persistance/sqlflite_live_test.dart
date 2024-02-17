import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/persistence/database_helpers.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_linux/path_provider_linux.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

// if running on a fresh linux machine requires sqllite to be installed
// sudo apt-get -y install libsqlite3-0 libsqlite3-dev
////////////////////////////////////////////////////////////////////////////////
  /// integration tests
////////////////////////////////////////////////////////////////////////////////

  group('sqlflite', () {
    final db = DatabaseHelper.instance;
    setUp(() async {
      PathProviderPlatform.instance = PathProviderLinux();
    });
    // Confirm anonymous login is successful.
    test('Run login', () async {
      expect(db.database, isNotNull);
    });
    test('add', () async {
      final model = MovieModel(uniqueId: 'tt123', dtoJson: 'myjson');
      final result = db.insert(model);

      expect(result, completion(isPositive));
    });
    test('upsert', () async {
      final model1 = MovieModel(uniqueId: 'tt12345', dtoJson: 'myjsonresult1');
      final model2 = MovieModel(uniqueId: 'tt12345', dtoJson: 'myjsonresult2');
      await db.insert(model1);
      await db.insert(model2);
      final result = await db.queryMovieUniqueId('tt12345');

      expect(result!.dtoJson, model2.dtoJson);
    });
    test('fetch', () async {
      final json = MovieResultDTO()
          .init(uniqueId: 'tt123', title: 'fetch test')
          .toJsonText();
      final model = MovieModel(uniqueId: 'tt1234', dtoJson: json);
      await db.insert(model);
      final result = await db.queryMovieUniqueId('tt1234');

      expect(result!.dtoJson, model.dtoJson);
    });
    test('update', () async {
      final model1 = MovieModel(uniqueId: 'tt12345', dtoJson: 'myjsonresult1');
      final model2 = MovieModel(uniqueId: 'tt12345', dtoJson: 'myjsonresult2');
      await db.insert(model1);
      await db.update(model2);
      final result = await db.queryMovieUniqueId('tt12345');

      expect(result!.dtoJson, model2.dtoJson);
    });
  });
}
