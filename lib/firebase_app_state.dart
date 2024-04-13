import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as android_firebase
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_ui_auth/firebase_ui_auth.dart'; //does not compile on linux
import 'package:firedart/firedart.dart' as linux_firedart;
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart' as linux_firedartstatus;

import 'package:my_movie_search/firebase_options.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

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
abstract class FirebaseApplicationState_old extends ChangeNotifier {
  /// Singleton for the current platform
  factory FirebaseApplicationState_old() {
    _instance ??= Platform.isLinux
        ? _WebLinuxFirebaseApplicationState()
        : _NativeAndroidFirebaseApplicationState();
    return _instance!;
  }

  FirebaseApplicationState_old._internal() {
    unawaited(init());
  }
  static FirebaseApplicationState_old? _instance;

  Future<bool> _loggedIn = Future<bool>.value(false);
  String? _userDisplayName;
  String? _userId;
  String? _userDevice;

  /// Determine if the current user is authenticated against Firebase.
  Future<bool> get loggedIn => _loggedIn;

  /// The user name according to Firebase.
  String? get userDisplayName => _userDisplayName;

  /// The userId in Firebase.
  String? get userId => _userId;

  /// The userId in Firebase.
  String? get deviceType => _userDevice;

  /// Initialise firebase ready for use.
  Future<void> init() async => _loggedIn = _login();

  Future<bool> _login() async {
    try {
      final success = await login();
      return success;
    } catch (e) {
      logger.t('firebase initialisation failure $e');
      return false;
    }
  }

  /// Connect to firebase anonymously
  Future<bool> login();

  /// Extract data from Firebase
  Future<dynamic> fetchRecord(
    String collectionPath, {
    required String id,
  }) async {
    if (!await _loggedIn) {
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
    if (!await _loggedIn) {
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
    if (!await _loggedIn) {
      logger.t('Must be logged in');
      return false;
    }

    logger.t('Logging Message $message to collection $collectionPath');
    return true;
  }

  Map<String, dynamic> _newRecord(String message) => {
        Fields.text.name: message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userName': _userDisplayName,
        'userId': _userId,
        Fields.devices.name: [_userDevice],
      };
}

//MARK: - Linux
class _WebLinuxFirebaseApplicationState extends FirebaseApplicationState_old {
  _WebLinuxFirebaseApplicationState() : super._internal();

  // TODO(pappes): reuse tokens. https://github.com/pappes/MyMovieSearch/issues/70
  final _sessionStore = linux_firedart.VolatileStore();

  @override
  Future<bool> login() async {
    // When native firebase APIs are unavailable due to plaform
    // falling back to https://pub.dev/packages/firedart
    if (!linux_firedart.FirebaseAuth.initialized) {
      linux_firedart.FirebaseAuth.initialize(
        DefaultFirebaseOptions.web.apiKey,
        _sessionStore,
      );
    }
    await linux_firedart.FirebaseAuth.instance.signInAnonymously();
    // await firedart.FirebaseAuth.instance.signIn(email, password);
    final user = await linux_firedart.FirebaseAuth.instance.getUser();
    if (!linux_firedart.Firestore.initialized) {
      linux_firedart.Firestore.initialize(DefaultFirebaseOptions.web.projectId);
    }
    _userDisplayName = user.displayName;
    _userId = user.id;

    _userDevice = 'linux.Ubuntu.';

    return true;
  }

  @override
  Future<String?> fetchRecord(
    String collectionPath, {
    required String id,
  }) async {
    try {
      if (await super.fetchRecord(collectionPath, id: id) as bool) {
        final fbcollection =
            linux_firedart.Firestore.instance.collection(collectionPath);
        // Get reference to supplied ID
        final doc = fbcollection.document(id);
        final msg = await doc.get();
        // Check the currentuser

        final recordedDevices = msg[Fields.devices.name] ??
            [runtimeDevices.keys.first]; // assume dave
        if (_derivedUserMatch(_userDevice, recordedDevices)) {
          return msg[Fields.text.name]?.toString() ?? '';
        }
        return '';
      }
    } on linux_firedart.GrpcError catch (exception) {
      if (exception.code == linux_firedartstatus.StatusCode.notFound) {
        return null; // record does not exist, ignore
      } else {
        logger.t('Unable to fetch record to Firebase exception: $exception');
      }
    }
    return null;
  }

  @override
  Stream<Map<String, String>> fetchRecords(
    String collectionPath,
  ) async* {
    try {
      await super.fetchRecords(collectionPath).drain<dynamic>();
      final fbcollection =
          linux_firedart.Firestore.instance.collection(collectionPath);

      yield* fbcollection.stream.asyncExpand(_collectionConverter);
    } on linux_firedart.GrpcError catch (exception) {
      logger.t('Unable to fetch collection Firebase exception: $exception');
      rethrow;
    } catch (exception) {
      logger.t('Unable to fetch collection unknown Firebase exception: '
          '$exception');
      rethrow;
    }
    return;
  }

  Stream<Map<String, String>> _collectionConverter(
    List<linux_firedart.Document> documents,
  ) async* {
    for (final document in documents) {
      final message = document[Fields.text.name]?.toString();
      yield {document.id: message ?? ''};
    }
  }

  @override
  Future<bool> addRecord(
    String collectionPath, {
    String? message,
    String? id,
  }) async {
    try {
      if (await super.addRecord(collectionPath, message: message, id: id)
          as bool) {
        final map = _newRecord(message ?? 'blank');
        final fbcollection =
            linux_firedart.Firestore.instance.collection(collectionPath);
        if (id == null) {
          // Generate random ID
          final fbrecord = fbcollection.add(map);
          await fbrecord;
          return true;
        } else {
          final newDevices = [_userDevice];

          // Get reference to supplied ID
          final doc = fbcollection.document(id);
          try {
            final msg = await doc.get();
            // Preserve existing data.
            if (await doc.exists) {
              final existingDevices = msg[Fields.devices.name];
              if (existingDevices != null && existingDevices is Iterable) {
                // Define unique list of devices.
                map[Fields.devices.name] =
                    {...existingDevices, ...newDevices}.toList();
              }
            }
          } catch (_) {
            map[Fields.devices.name] = newDevices;
          }
          // Write data to0 firestore.
          await doc.update(map);
          return true;
        }
      }
    } catch (exception) {
      logger.t('Unable to add record to Firebase exception: $exception '
          'collection: $collectionPath id: $id message: $message');
    }
    return false;
  }
}

//MARK: - Android
class _NativeAndroidFirebaseApplicationState
    extends FirebaseApplicationState_old {
  _NativeAndroidFirebaseApplicationState() : super._internal();

  @override
  Future<bool> login() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await android_firebase.FirebaseAuth.instance.signInAnonymously();
    // TODO(pappes): User based auth (not anaonymous) https://github.com/pappes/MyMovieSearch/issues/71

    final stream = android_firebase.FirebaseAuth.instance
        .userChanges()
        .asBroadcastStream();

    final user = await stream.first;
    loginStatusEvent(user);
    stream.listen(loginStatusEvent);

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    // Pixel 8 = 'android.Google.Pixel 8 Pro'
    // samsung fold = 'android.samsung.SM-F926B'
    // samsung s8 = 'android.samsung.SM-G950F'
    _userDevice = 'android.'
        '${androidInfo.manufacturer}.${androidInfo.model}';

    return user != null;
  }

  void loginStatusEvent(android_firebase.User? user) {
    if (user != null) {
      _loggedIn = Future<bool>.value(true);
      _userDisplayName = user.displayName;
      _userId = user.uid;
    } else {
      _loggedIn = Future<bool>.value(false);
      _userDisplayName = null;
      _userId = null;
    }
    notifyListeners();
  }

  @override
  Future<String?> fetchRecord(
    String collectionPath, {
    required String id,
  }) async {
    try {
      if (await super.fetchRecord(collectionPath, id: id) as bool) {
        final fbcollection =
            FirebaseFirestore.instance.collection(collectionPath);

        // Get reference to supplied ID
        final doc = fbcollection.doc(id);
        final msg = await doc.get();

        // Check the currentuser
        if (msg.exists && msg.data()!.containsKey(Fields.text.name)) {
          dynamic recordedDevices = runtimeDevices.keys.first; // assume dave
          if (msg.data()!.containsKey(Fields.devices.name)) {
            recordedDevices = msg[Fields.devices.name];
          } else {
            recordedDevices = [runtimeDevices.keys.first];
          }
          if (_derivedUserMatch(_userDevice, recordedDevices)) {
            return msg[Fields.text.name]?.toString() ?? '';
          }
        }
        return '';
      }
    } catch (exception) {
      logger.e('Unable to fetch record to Firebase exception: $exception');
    }
    return null;
  }

  @override
  Stream<Map<String, String>> fetchRecords(
    String collectionPath,
  ) async* {
    try {
      await super.fetchRecords(collectionPath).drain<dynamic>();
      final fbcollection =
          FirebaseFirestore.instance.collection(collectionPath);

      yield* fbcollection.snapshots().asyncExpand(_collectionConverter);
    } catch (exception) {
      logger.t('Unable to fetch collection Firebase exception: $exception');
      rethrow;
    }
    return;
  }

  Stream<Map<String, String>> _collectionConverter(
    QuerySnapshot<Map<String, dynamic>> documents,
  ) async* {
    for (final document in documents.docs) {
      final message = document[Fields.text.name]?.toString();
      yield {document.id: message ?? ''};
    }
  }

  @override
  Future<bool> addRecord(
    String collectionPath, {
    String? message,
    String? id,
  }) async {
    try {
      if (await super.addRecord(collectionPath, message: message, id: id)
          as bool) {
        final fbcollection =
            FirebaseFirestore.instance.collection(collectionPath);
        final map = _newRecord(message ?? 'blank');

        if (id == null) {
          // Generate random ID
          final fbrecord = fbcollection.add(map);
          await fbrecord;
          return true;
        } else {
          // Get reference to supplied ID
          final fbcollection =
              FirebaseFirestore.instance.collection(collectionPath);
          // Get reference to supplied ID
          final doc = fbcollection.doc(id);
          final msg = await doc.get();

          // Preserve existing data.
          final newDevices = [_userDevice];
          if (msg.exists && msg.data()!.containsKey(Fields.devices.name)) {
            final existingDevices = msg[Fields.devices.name];
            if (existingDevices != null && existingDevices is Iterable) {
              // Define unique list of devices.
              map[Fields.devices.name] =
                  {...existingDevices, ...newDevices}.toList();
            }
          } else {
            map[Fields.devices.name] = newDevices;
          }

          // Write data to firestore.
          await doc.set(map, SetOptions(merge: true));
          return true;
        }
      }
    } catch (exception) {
      logger.e('Unable to add record to Firebase exception: $exception');
    }
    return false;
  }
}

String _derivedUser(String? device) => runtimeDevices[device] ?? 'tash';
bool _derivedUserMatch(String? device, dynamic devices) {
  if (devices is Iterable) {
    final currentUser = _derivedUser(device);
    for (final storedDevice in devices) {
      if (currentUser == _derivedUser(storedDevice.toString())) {
        return true;
      }
    }
  }
  return false;
}

/// Exception used in FirebaseApplicationState_old.
class MMSFirebaseException implements Exception {
  MMSFirebaseException(this.cause);
  String cause;

  @override
  String toString() => cause;
}
