import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_ui_auth/firebase_ui_auth.dart'; //does not compile on linux
import 'package:firedart/firedart.dart' as firedart;
import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';

import 'package:my_movie_search/firebase_options.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';
//import 'package:provider/provider.dart';

abstract class FirebaseApplicationState extends ChangeNotifier {
  factory FirebaseApplicationState() {
    instance ??= Platform.isLinux
        ? _WebFirebaseApplicationState()
        : _NativeFirebaseApplicationState();
    return instance!;
  }

  FirebaseApplicationState._internal() {
    init();
  }
  static FirebaseApplicationState? instance;

  Future<bool> _loggedIn = Future.value(false);
  String? _userDisplayName;
  String? _userId;

  Future<bool> get loggedIn => _loggedIn;
  String? get userDisplayName => _userDisplayName;
  String? get userId => _userId;

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

  Future<bool> login();

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

  Map<String, dynamic> newRecord(String message) => {
        'text': message,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'userName': _userDisplayName,
        'userId': _userId,
      };
}

class _WebFirebaseApplicationState extends FirebaseApplicationState {
  _WebFirebaseApplicationState() : super._internal();

  // TODO: To keep token across sessions create a TokenStore
  // that persists the token e.g. using hive
  final _sessionStore = firedart.VolatileStore();

  @override
  Future<bool> login() async {
    // When native firebase APIs are unavailable due to plaform
    // falling back to https://pub.dev/packages/firedart
    if (!firedart.FirebaseAuth.initialized) {
      firedart.FirebaseAuth.initialize(
        DefaultFirebaseOptions.web.apiKey,
        _sessionStore,
      );
    }
    await firedart.FirebaseAuth.instance.signInAnonymously();
    // await firedart.FirebaseAuth.instance.signIn(email, password);
    final user = await firedart.FirebaseAuth.instance.getUser();
    if (!firedart.Firestore.initialized) {
      firedart.Firestore.initialize(DefaultFirebaseOptions.web.projectId);
    }
    _userDisplayName = user.displayName;
    _userId = user.id;

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
            firedart.Firestore.instance.collection(collectionPath);
        // Get reference to supplied ID
        final doc = fbcollection.document(id);
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
        final map = newRecord(message ?? 'blank');
        final fbcollection =
            firedart.Firestore.instance.collection(collectionPath);
        if (id == null) {
          // Generate random ID
          final fbrecord = fbcollection.add(map);
          await fbrecord;
          return true;
        } else {
          // Get reference to supplied ID
          final doc = fbcollection.document(id);
          await doc.update(map);
          return true;
        }
      }
    } catch (exception) {
      logger.t('Unable to add record to Firebase exception: $exception');
    }
    return false;
  }
}

class _NativeFirebaseApplicationState extends FirebaseApplicationState {
  _NativeFirebaseApplicationState() : super._internal();

  @override
  Future<bool> login() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth.instance.signInAnonymously();
    // TODO: link anonymous accounts to authenticated accounts
    // when FirebaseIUAuth supports linux applications
    // see https://firebase.google.com/docs/auth/android/anonymous-auth
    // could be resoved when firebase_auth_desktop issue 130 is fixed via PR 131
    // https://github.com/FirebaseExtended/flutterfire_desktop/issues/130
    // https://github.com/FirebaseExtended/flutterfire_desktop/pull/131
    // also https://stackoverflow.com/questions/73989832/flutterfire-cli-not-showing-windows-and-linux-as-an-option-for-platform-to-suppo

    /*FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);*/

    final stream = FirebaseAuth.instance.userChanges().asBroadcastStream();

    final user = await stream.first;
    loginStatusEvent(user);
    stream.listen(loginStatusEvent);
    return user != null;
  }

  void loginStatusEvent(User? user) {
    if (user != null) {
      _loggedIn = Future.value(true);
      _userDisplayName = user.displayName;
      _userId = user.uid;
    } else {
      _loggedIn = Future.value(false);
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
        final map = newRecord(message ?? 'blank');

        if (id == null) {
          // Generate random ID
          final fbrecord = fbcollection.add(map);
          await fbrecord;
          return true;
        } else {
          // Get reference to supplied ID
          final doc = fbcollection.doc(id);
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

  /// Defines known routes handled by Firebase UI.
  ///
  /*List<RouteBase> getRoutes() => [  
    GoRoute(
      path: 'sign-in',
      builder: (context, state) {
        return SignInScreen(
          actions: [
            ForgotPasswordAction((context, email) {
              final uri = Uri(
                path: '/sign-in/forgot-password',
                queryParameters: <String, String?>{
                  'email': email,
                },
              );
              context.push(uri.toString());
            }),
            AuthStateChangeAction((context, state) {
              final user = switch (state) {
                final SignedIn state => state.user,
                final UserCreated state => state.credential.user,
                _ => null
              };
              if (user == null) {
                return;
              }
              if (state is UserCreated) {
                user.updateDisplayName(user.email!.split('@')[0]);
              }
              if (!user.emailVerified) {
                user.sendEmailVerification();
                const snackBar = SnackBar(
                    content: Text(
                        'Please check your email to verify your email address'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              context.pushReplacement('/');
            }),
          ],
        );
      },
      routes: [
        GoRoute(
          path: 'forgot-password',
          builder: (context, state) {
            final arguments = state.uri.queryParameters;
            return ForgotPasswordScreen(
              email: arguments['email'],
              headerMaxExtent: 200,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: 'profile',
      builder: (context, state) {
        return ProfileScreen(
          providers: const [],
          actions: [
            SignedOutAction((context) {
              context.pushReplacement('/');
            }),
          ],
        );
      },
    ),
      ];*/
