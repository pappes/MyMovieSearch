import 'dart:async';

//import 'package:firebase_ui_auth/firebase_ui_auth.dart'; //does not compile on linux
import 'package:firedart/firedart.dart';
import 'package:grpc/grpc.dart';
import 'package:my_movie_search/firebase_options.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

class FirebaseApplicationStateLinux extends FirebaseApplicationState {
  FirebaseApplicationStateLinux() : super.internal();

  // TODO(pappes): reuse tokens. https://github.com/pappes/MyMovieSearch/issues/70
  final _sessionStore = VolatileStore();

  @override
  Future<bool> platformLogin() async {
    // When native firebase APIs are unavailable due to plaform
    // falling back to https://pub.dev/packages/firedart
    if (!FirebaseAuth.initialized) {
      FirebaseAuth.initialize(DefaultFirebaseOptions.web.apiKey, _sessionStore);
    }
    await FirebaseAuth.instance.signInAnonymously();
    // await firedart.FirebaseAuth.instance.signIn(email, password);
    final user = await FirebaseAuth.instance.getUser();
    if (!Firestore.initialized) {
      Firestore.initialize(DefaultFirebaseOptions.web.projectId);
    }

    userDisplayName = user.displayName;

    userId = user.id;

    deviceType = 'linux.Ubuntu.';

    return true;
  }

  @override
  Future<String?> fetchRecord(
    String collectionPath, {
    required String id,
  }) async {
    try {
      if (await super.fetchRecord(collectionPath, id: id) as bool) {
        final fbcollection = Firestore.instance.collection(collectionPath);
        // Get reference to supplied ID
        final doc = fbcollection.document(id);
        final msg = await doc.get();
        // Check the currentuser

        final recordedDevices =
            msg[Fields.devices.name] ??
            [runtimeDevices.keys.first]; // assume dave
        if (derivedUserMatch(deviceType, recordedDevices)) {
          return msg[Fields.text.name]?.toString() ?? '';
        }

        return '';
      }
    } on GrpcError catch (exception) {
      if (exception.code == StatusCode.notFound) {
        return null; // record does not exist, ignore
      } else {
        logger.t('Unable to fetch record to Firebase exception: $exception');
      }
    }
    return null;
  }

  @override
  Stream<Map<String, String>> fetchRecords(
    String collectionPath, {
    String? filterFieldPath,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    dynamic isLessThan,
    dynamic isLessThanOrEqualTo,
    dynamic isGreaterThan,
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    List<dynamic>? arrayContainsAny,
    List<dynamic>? whereIn,
    List<dynamic>? whereNotIn,
    bool isNull = false,
    Completer<bool>? initalDataLoadComplete,
  }) async* {
    try {
      // Let parent class prepare for data.
      await super.fetchRecords(collectionPath).drain<dynamic>();
      final fbcollection = Firestore.instance.collection(collectionPath);
      if (filterFieldPath == null) {
        // For Linux we can accept an ongoing stream if there is no filtering.
        yield* fbcollection.stream.asyncExpand(_collectionConverter);
      } else {
        // For Linux we cannot access an ongoing stream for filtered data.
        final val = await fbcollection
            .where(
              filterFieldPath,
              isEqualTo: isEqualTo,
              isLessThan: isLessThan,
              isLessThanOrEqualTo: isLessThanOrEqualTo,
              isGreaterThan: isGreaterThan,
              isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
              arrayContains: arrayContains,
              arrayContainsAny: arrayContainsAny,
              whereIn: whereIn,
              isNull: isNull,
            )
            .get();

        yield* _collectionConverter(val);
        initalDataLoadComplete?.complete(true);
      }
    } on GrpcError catch (exception) {
      logger.t('Unable to fetch collection Firebase exception: $exception');
      rethrow;
    }
    if (initalDataLoadComplete != null && !initalDataLoadComplete.isCompleted) {
      // Do not know when initial data load is completre
      // so just wait a fixed amount of time then notify the caller.
      unawaited(
        Future<void>.delayed(
          const Duration(seconds: 5),
        ).then((_) => initalDataLoadComplete.complete(true)),
      );
    }
    return;
  }

  Stream<Map<String, String>> _collectionConverter(
    List<Document> documents,
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
        final map = newRecord(message ?? 'blank');
        final fbcollection = Firestore.instance.collection(collectionPath);
        if (id == null) {
          // Generate random ID
          final fbrecord = fbcollection.add(map);
          await fbrecord;
          return true;
        } else {
          final newDevices = [deviceType];

          // Get reference to supplied ID
          final doc = fbcollection.document(id);
          try {
            final msg = await doc.get();
            // Preserve existing data.
            if (await doc.exists) {
              final existingDevices = msg[Fields.devices.name];
              if (existingDevices != null && existingDevices is Iterable) {
                // Define unique list of devices.
                map[Fields.devices.name] = {
                  ...existingDevices,
                  ...newDevices,
                }.toList();
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
      logger.t(
        'Unable to add record to Firebase exception: $exception '
        'collection: $collectionPath id: $id message: $message',
      );
    }
    return false;
  }
}
