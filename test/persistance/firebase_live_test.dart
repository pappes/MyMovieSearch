import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

Future<void> createBackupData() async {
  WidgetsFlutterBinding.ensureInitialized();

  logger
      .w('backup started at timestamp ${DateTime.now().millisecondsSinceEpoch}'
          '\nConstant lastFirebaseBackupDate needs to be updated in '
          'lib/movies/models/movie_location.dart');
  final fb = MovieLocation();
  await fb.init();
  final data = fb.getBackupData();

  final filename = '/tmp/firebaseBackup${DateTime.now().toIso8601String()}.txt';

  await File(filename).writeAsString(data, flush: true);
  logger.w('Backup written to $filename');
}

void main() async {
  // Wait for api key to be initialised
  //setUpAll(() async => Settings());
////////////////////////////////////////////////////////////////////////////////
  /// integration tests
////////////////////////////////////////////////////////////////////////////////

  await createBackupData();

  group('firebase', () {
    // Confirm anonymous login is successful.
    test('Run login', () async {
      final fb = FirebaseApplicationState();
      final result = fb.login();

      expect(result, completion(true));
    });
    test('add', () async {
      final fb = FirebaseApplicationState();
      final result = fb.addRecord('testing', id: '123456', message: 'addme');

      expect(result, completion(true));
    });
    test('fetch single record', () async {
      final fb = FirebaseApplicationState();
      await fb.addRecord('testing', id: '123456', message: 'addme');
      final result = fb.fetchRecord('testing', id: '123456');

      expect(result, completion('addme'));
    });
    test('update', () async {
      final fb = FirebaseApplicationState();
      await fb.addRecord('testing', id: '123456', message: 'startme');
      var result = fb.fetchRecord('testing', id: '123456');

      expect(result, completion('startme'));

      await fb.addRecord('testing', id: '123456', message: 'updateme');
      result = fb.fetchRecord('testing', id: '123456');

      expect(result, completion('updateme'));
    });
    test('fetch multiple records', () async {
      final expected = {'123456': 'addme', '123457': 'addmetoo'};
      final actual = <String, String>{};
      final fb = FirebaseApplicationState();
      await fb.addRecord('testing', id: '123456', message: 'addme');
      await fb.addRecord('testing', id: '123457', message: 'addmetoo');
      final result = await fb
          .fetchRecords('testing')
          .timeout(
            const Duration(seconds: 1),
            onTimeout: (sink) => sink.close(),
          )
          .toList();
      expect(result, isA<List<Map<String, String>>>());
      // Combine list of maps into a single map
      for (final m in result as List<Map<String, String>>) {
        actual[m.entries.first.key] = m.entries.first.value;
      }

      expect(actual, expected);
    });
  });
}
