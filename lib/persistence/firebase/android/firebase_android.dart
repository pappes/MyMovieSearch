import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart' as android_firebase
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_ui_auth/firebase_ui_auth.dart'; //does not compile on linux

import 'package:my_movie_search/firebase_options.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

class FirebaseApplicationStateAndriod extends FirebaseApplicationState {
  FirebaseApplicationStateAndriod() : super.internal();

  @override
  Future<bool> platformLogin() async {
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
    deviceType = 'android.'
        '${androidInfo.manufacturer}.${androidInfo.model}';

    return user != null;
  }

  void loginStatusEvent(android_firebase.User? user) {
    if (user != null) {
      loggedIn = Future<bool>.value(true);
      userDisplayName = user.displayName;
      userId = user.uid;
    } else {
      loggedIn = Future<bool>.value(false);
      userDisplayName = null;
      userId = null;
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
          if (derivedUserMatch(deviceType, recordedDevices)) {
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
        final map = newRecord(message ?? 'blank');

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
          final newDevices = [deviceType];
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
