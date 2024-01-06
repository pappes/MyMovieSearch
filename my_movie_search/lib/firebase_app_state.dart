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
//import 'package:go_router/go_router.dart';
import 'package:grpc/grpc.dart' as linux_firedartstatus;

import 'package:my_movie_search/firebase_options.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
//import 'package:provider/provider.dart';

/// Grants access to firebase persistent data
abstract class FirebaseApplicationState extends ChangeNotifier {
  /// Singleton for the current platform
  factory FirebaseApplicationState() {
    _instance ??= Platform.isLinux
        ? _WebLinuxFirebaseApplicationState()
        : _NativeAndroidFirebaseApplicationState();
    return _instance!;
  }

  FirebaseApplicationState._internal() {
    unawaited(init());
  }
  static FirebaseApplicationState? _instance;

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
        'text': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userName': _userDisplayName,
        'userId': _userId,
        'devices': [_userDevice],
      };
}

class _WebLinuxFirebaseApplicationState extends FirebaseApplicationState {
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

    final linuxInfo = await DeviceInfoPlugin().linuxInfo;
    // code4 = 'linux.Ubuntu.'
    _userDevice = 'linux.${linuxInfo.name}.'
        '${linuxInfo.variant ?? ""}';

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
        // Check the surrentuser
        if (_derivedUser(_userDevice) ==
            _derivedUser(msg['devices']?.toString())) {
          return msg['text']?.toString() ?? '';
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
          // Get reference to supplied ID
          final doc = fbcollection.document(id);
          final msg = await doc.get();
          // Preserve existing data.
          final existingDevices = msg['devices'];
          final newDevices = map['devices'] as List<dynamic>;
          if (existingDevices != null && existingDevices is Iterable) {
            // Define unique list of devices.
            map['devices'] = {...existingDevices, ...newDevices}.toList();
          }
          // Write data to0 firestore.
          await doc.update(map);
          return true;
        }
      }
    } catch (exception) {
      logger.t('Unable to add record to Firebase exception: $exception');
    }
    return false;
  }

  _checkOwner(DocumentReference msg) {}
}

class _NativeAndroidFirebaseApplicationState extends FirebaseApplicationState {
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
        return msg['text']?.toString() ?? '';
      }
    } catch (exception) {
      logger.t('Unable to fetch record to Firebase exception: $exception');
    }
    return null;
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
          final existingDevices = msg['devices'];
          final newDevices = map['devices'] as List<dynamic>;
          if (existingDevices != null && existingDevices is Iterable) {
            // Define unique list of devices.
            map['devices'] = {...existingDevices, ...newDevices}.toList();
          }

          // Write data to firestore.
          await doc.set(map, SetOptions(merge: true));
          return true;
        }
      }
    } catch (exception) {
      logger.t('Unable to add record to Firebase exception: $exception');
    }
    return false;
  }
}

String _derivedUser(String? device) =>
    (device == 'android.Google.Pixel 8 Pro' ||
            device == 'android.samsung.SM-F926B' ||
            // samsung s8 = 'android.samsung.SM-G950F'
            device == 'linux.Ubuntu.' ||
            device == 'android.samsung.SM-G950F' ||
            // samsung s8 = 'android.samsung.SM-G950F'
            device == null)
        ? 'dave'
        : 'tash';
