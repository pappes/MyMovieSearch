//import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/firebase_app_state.dart';
////import 'package:my_movie_search/utilities/settings.dart';
//import '../test_helper.dart';

void main() {
  // Wait for api key to be initialised
  // setUpAll(() => Settings.singleton().init());
////////////////////////////////////////////////////////////////////////////////
  /// integration tests
////////////////////////////////////////////////////////////////////////////////

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
    test('fetch', () async {
      final fb = FirebaseApplicationState();
      await fb.addRecord('testing', id: '123456', message: 'addme');
      final result = fb.fetchRecord('testing', id: '123456');

      expect(result, completion('addme'));
    });
    test('update', () async {
      final fb = FirebaseApplicationState();
      await fb.addRecord('testing', id: '123456', message: 'addme');
      var result = fb.fetchRecord('testing', id: '123456');

      expect(result, completion('addme'));

      await fb.addRecord('testing', id: '123456', message: 'updateme');
      result = fb.fetchRecord('testing', id: '123456');

      expect(result, completion('updateme'));
    });
  });
}
