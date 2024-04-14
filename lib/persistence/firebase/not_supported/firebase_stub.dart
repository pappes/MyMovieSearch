import 'dart:async';

import 'package:my_movie_search/persistence/firebase/firebase_common.dart';

class FirebaseApplicationStateStub extends FirebaseApplicationState {
  FirebaseApplicationStateStub() : super.internal() {
    throw MMSFirebaseException('platform not supported');
  }

  @override
  Future<bool> platformLogin() async {
    throw MMSFirebaseException('platform not supported');
  }

  @override
  Future<String?> fetchRecord(
    String collectionPath, {
    required String id,
  }) async {
    throw MMSFirebaseException('platform not supported');
  }

  @override
  Stream<Map<String, String>> fetchRecords(
    String collectionPath, {
    String? filterFieldPath,
    dynamic isEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? whereIn,
    bool isNull = false,
    Completer<bool>? initalDataLoadComplete,
  }) async* {
    throw MMSFirebaseException('platform not supported');
  }

  @override
  Future<bool> addRecord(
    String collectionPath, {
    String? message,
    String? id,
  }) async {
    throw MMSFirebaseException('platform not supported');
  }
}
