import 'dart:async';
import 'dart:io';

//import 'package:firebase_ui_auth/firebase_ui_auth.dart'; //does not compile on linux
import 'package:flutter/material.dart';

import 'package:my_movie_search/persistence/firebase/android/firebase_android.dart';
import 'package:my_movie_search/persistence/firebase/linux/firebase_linux.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

/*export 'android/firebase_android.dart' // Stub implementation
    if (Platform.isAndroid) 'android/firebase_android.dart' // dart:io implementation
    if (Platform.isLinux) 'linux/firebase_linux.dart'; // package:web implementation*/

enum Fields { devices, text }

const runtimeDevices = {
  'android.Google.Pixel 8 Pro': 'dave', // Google Pixel 8 Pro
  'android.samsung.SM-F926B': 'dave', // Samsung Fold 3
  'linux.Ubuntu.': 'dave', // development VM
  'android.samsung.SM-G950F': 'dave', // Samsung S8
  'android.Microsoft Corporation.Subsystem for Android(TM)': 'dave', // Chair
  'TBD': 'tash',
};

/// Grants access to firebase persistent data
abstract class FirebaseApplicationState extends ChangeNotifier {
  /// Singleton for the current platform
  factory FirebaseApplicationState() {
    instance ??= Platform.isLinux
        ? FirebaseApplicationStateLinux()
        : FirebaseApplicationStateAndriod();
    return instance!;
  }

  FirebaseApplicationState.internal() {
    unawaited(init());
  }
  static FirebaseApplicationState? instance;

  Future<bool> loggedIn = Future<bool>.value(false);
  String? userDisplayName;
  String? userId;
  String? deviceType;

  /// Initialise firebase ready for use.
  Future<void> init() async => loggedIn = login();

  Future<bool> login() async {
    try {
      final success = await platformLogin();
      return success;
    } catch (e) {
      logger.t('firebase initialisation failure $e');
      return false;
    }
  }

  /// Connect to firebase anonymously
  Future<bool> platformLogin();

  /// Extract data from Firebase
  Future<dynamic> fetchRecord(
    String collectionPath, {
    required String id,
  }) async {
    if (!await loggedIn) {
      logger.t('Must be logged in');
      return false;
    }

    logger.t('Fetching Message $id from collection $collectionPath');
    return true;
  }

  /// Extract data from Firebase
  ///
  /// Implimentations need to ensure superclass has successfully completed
  /// by calling
  /// await super.fetchRecords(collectionPath).drain<dynamic>(
  Stream<dynamic> fetchRecords(
    String collectionPath,
  ) async* {
    if (!await loggedIn) {
      logger.t('Must be logged in');
      throw MMSFirebaseException('not logged in');
    }

    logger.t('Fetching collection $collectionPath');
  }

  /// Insert data into Firebase.
  Future<dynamic>? addRecord(
    String collectionPath, {
    String? message,
    String? id,
  }) async {
    if (!await loggedIn) {
      logger.t('Must be logged in');
      return false;
    }

    logger.t('Logging Message $message to collection $collectionPath');
    return true;
  }

  Map<String, dynamic> newRecord(String message) => {
        Fields.text.name: message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userName': userDisplayName,
        'userId': userId,
        Fields.devices.name: [deviceType],
      };

  String derivedUser(String? device) => runtimeDevices[device] ?? 'tash';
  bool derivedUserMatch(String? device, dynamic devices) {
    if (devices is Iterable) {
      final currentUser = derivedUser(device);
      for (final storedDevice in devices) {
        if (currentUser == derivedUser(storedDevice.toString())) {
          return true;
        }
      }
    }
    return false;
  }
}

/// Exception used in FirebaseApplicationState.
class MMSFirebaseException implements Exception {
  MMSFirebaseException(this.cause);
  String cause;

  @override
  String toString() => cause;
}
