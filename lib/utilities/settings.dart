// ignore_for_file: do_not_use_environment

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_secret_manager/google_secret_manager.dart';
import 'package:logger/logger.dart';
import 'package:mutex/mutex.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:universal_io/io.dart';

/// Load application defined settings.
///
/// currently supported setting locations are:
/// 0) source code
/// 1) compiled dart-define values
/// 2) google secrets (cloud)
/// 3) runtime environment variables
/// it is recommended to use 2) for API keys and other sensitive information
/// it is recommended to use 3) for test environments
///
///
/// currently supported settings are:
/// 'GOOGLE_URL': 'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&key='
/// 'GOOGLE_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'OMDB_KEY': 'xxxxxxxx',
/// 'TMDB_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'MEILIADMIN_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'MEILISEARCH_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'MEILISEARCH_URL': 'https://cloud.meilisearch.com/',
/// not applicable to cloud storage:
/// 'SECRETS_LOCATION': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'OFFLINE': '!true', // defaults to null (hence online)
/// not applicable to non-cloud storage:
/// 'SE_VM_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
///
///
/// This can be configured from google secrets (cloud)
/// mms_gc = "https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// mms_gk = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_o = "xxxxxxxx"
/// mms_t = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_s = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_sk = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_su = "https://cloud.meilisearch.com/"
/// mms_se = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// SECRETS_LOCATION and OFFLINE are not applicable to cloud storage.
///
/// or from the linux .profile/.bashrc at login time
/// ```shell
/// export GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// export GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export OMDB_KEY="xxxxxxxx"
/// export TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MEILISEARCH_URL="https://cloud.meilisearch.com/"
/// export SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export OFFLINE="true"
/// ```
///
///
/// or from the command line at run time
/// ```shell
/// foo@bar:~$ export GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// foo@bar:~$ export GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export OMDB_KEY="xxxxxxxx"
/// foo@bar:~$ export TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MEILISEARCH_URL="https://cloud.meilisearch.com/"
/// foo@bar:~$ export SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export OFFLINE="true"
///
///
/// or from the command line at compile time
/// ```shell
/// foo@bar:~$ flutter run \
///   --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=" \
///   --dart-define GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OMDB_KEY="xxxxxxxx" \
///   --dart-define TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///   --dart-define MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///   --dart-define MEILISEARCH_URL="https://cloud.meilisearch.com/",
///   --dart-define SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OFFLINE="true"
/// ```
///
/// or from the command line at build time
/// ```shell
/// foo@bar:~$ flutter build apk \
///   --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
///   --dart-define GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OMDB_KEY="xxxxxxxx" \
///   --dart-define TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///   --dart-define MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///   --dart-define MEILISEARCH_URL="https://cloud.meilisearch.com/",
///   --dart-define SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
///   --dart-define OFFLINE="true"
/// ```
///
/// or configured in vscode; but it should be noted
/// you need to explicitly select this launch configuration when running,
/// like this:
/// ```json
///     "configurations": [
///         {
///             "name": "my_movie_search_custom_launch_config",
///             "request": "launch",
///             "type": "dart",
///             "toolArgs": [
///                 "--dart-define",
///                 "GOOGLE_URL=https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
///                 "--dart-define",
///                 "GOOGLE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "OMDB_KEY=xxxxxxxx",
///                 "--dart-define",
///                 "TMDB_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MEILIADMIN_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MEILISEARCH_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MEILISEARCH_URL=https://cloud.meilisearch.com/",
///                 "--dart-define",
///                 "SECRETS_LOCATION=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "OFFLINE=true"
///             ]
///         },
/// ```
class Settings {
  factory Settings() => _singleton;

  Settings._internal();
  static final Settings _singleton = Settings._internal();

  Logger? logger;
  String googleurl =
      'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=';
  String? googlekey;
  String? omdbkey;
  String? tmdbkey;
  String? meiliadminkey;
  String? meilisearchkey;
  String meiliurl = 'https://cloud.meilisearch.com/';
  String? secretsLocation;
  String? seVmKey;

  String? _offlineText = '!true';
  bool get offline => 'true' == (_offlineText?.toLowerCase() ?? '');
  set offline(bool val) => _offlineText = val ? 'true' : '!true';

  late FirebaseApplicationState _firebaseData;
  bool _firebaseInitialised = false;

  Future<bool> cloudSettingsInitialised = Future.value(false);
  final _cloudSettingsInit = Completer<bool>();
  bool secretsManagerInitialised = false;

  static final secretsManagerMutexLock = Mutex();
  static final secretsInitiaisedMutexLock = Mutex();

  /// Establish logger for use at runtime and schedules cloud retrieval.
  ///
  /// To be called once during application initialisation and in tests
  /// before accessing values.
  void init([Logger? logger]) {
    if (!_cloudSettingsInit.isCompleted) {
      cloudSettingsInitialised = _cloudSettingsInit.future;
      this.logger = logger ?? this.logger;
      // Manually initialise flutter to ensure that
      // settings can be loaded before RunApp
      // and to ensure tests are not prevented from calling real http endpoints.
      WidgetsFlutterBinding.ensureInitialized();
      _firebaseData = FirebaseApplicationState();

      getSecretsFromEnvironment();
      logger?.t('Settings initialised');
      logValues();

      // Ensure that only one copy of _asyncInit is running at a time.
      unawaited(secretsInitiaisedMutexLock.protect(_asyncInit));
    }
  }

  Future<void> _asyncInit() async {
    if (!_firebaseInitialised) {
      _firebaseInitialised = true;
      await _firebaseData.init();
    }
    return _updateFromCloud();
  }

  // Update secrets from runtime environment or compiled environment.
  void getSecretsFromEnvironment() {
    googleurl = googleurl.orBetterYet(
      getSecretFromEnv(
        'GOOGLE_URL',
        const String.fromEnvironment('GOOGLE_URL'),
      ),
    );
    googlekey = getSecretFromEnv(
      'GOOGLE_KEY',
      const String.fromEnvironment('GOOGLE_KEY'),
    );
    omdbkey = getSecretFromEnv(
      'OMDB_KEY',
      const String.fromEnvironment('OMDB_KEY'),
    );
    tmdbkey = getSecretFromEnv(
      'TMDB_KEY',
      const String.fromEnvironment('TMDB_KEY'),
    );
    meiliadminkey = getSecretFromEnv(
      'MEILIADMIN_KEY',
      const String.fromEnvironment('MEILIADMIN_KEY'),
    );
    meilisearchkey = getSecretFromEnv(
      'MEILISEARCH_KEY',
      const String.fromEnvironment('MEILISEARCH_KEY'),
    );
    meiliurl = meiliurl.orBetterYet(
      getSecretFromEnv(
        'MEILISEARCH_URL',
        const String.fromEnvironment('MEILISEARCH_URL'),
      ),
    );
    // Environment only values.
    secretsLocation = getSecretFromEnv(
      'SECRETS_LOCATION',
      const String.fromEnvironment('SECRETS_LOCATION'),
    );
    _offlineText = getSecretFromEnv(
      'OFFLINE',
      const String.fromEnvironment('OFFLINE'),
    );
  }

  // Update secrets from the cloud if available.
  Future<void> updateSecretsFromCloud(GoogleSecretManager secrets) async {
    googleurl = googleurl.orBetterYet(
      await getSecretFromCloud(secrets, 'mms_gc', googleurl, 'GOOGLE_URL'),
    );
    googlekey =
        await getSecretFromCloud(secrets, 'mms_gk', googlekey, 'GOOGLE_KEY');
    omdbkey = await getSecretFromCloud(secrets, 'mms_o', omdbkey, 'OMDB_KEY');
    tmdbkey = await getSecretFromCloud(secrets, 'mms_t', tmdbkey, 'TMDB_KEY');
    meiliadminkey = await getSecretFromCloud(
      secrets,
      'mms_s',
      meiliadminkey,
      'MEILIADMIN_KEY',
    );
    meilisearchkey = await getSecretFromCloud(
      secrets,
      'mms_sk',
      meilisearchkey,
      'MEILISEARCH_KEY',
    );
    meiliurl = meiliurl.orBetterYet(
      await getSecretFromCloud(secrets, 'mms_su', meiliurl, 'MEILISEARCH_URL'),
    );
    seVmKey = await getSecretFromCloud(secrets, 'mms_se', seVmKey, '');
  }

  void logValues() {
    logValue('GOOGLE_URL', googleurl);
    logValue('GOOGLE_KEY', googlekey);
    logValue('OMDB_KEY', omdbkey);
    logValue('TMDB_KEY', tmdbkey);
    logValue('MEILIADMIN_KEY', meiliadminkey);
    logValue('MEILISEARCH_KEY', meilisearchkey);
    logValue('MEILISEARCH_URL', meiliurl);
    logValue('SECRETS_LOCATION', secretsLocation);
    logValue('OFFLINE', _offlineText);
  }

  void logValue(String label, String? value) {
    logger?.t('settings fetched $label: $value');
    if (value == '') logger?.t('$label is empty');
    if (value == null) logger?.t('$label is null');
  }

  // Retrieve the secret from the best location available.
  //
  // 1) retrieve from the cloud (most up to date)
  // 2) retrieve from the runtime environment [environmentVar] e.g. 'OMDB_KEY'
  // 3) Allow compiler to supply a default value for [compiledEnv] e.g.
  //    const String.fromEnvironment('OMDB_KEY')
  String? getSecretFromEnv(
    String environmentVar,
    String? compiledEnv,
  ) {
    // Check if the runtime environment variable is set and not empty.
    final dynamicEnv = Platform.environment[environmentVar];
    if (dynamicEnv != null &&
        dynamicEnv.isNotEmpty &&
        dynamicEnv != 'not set') {
      return dynamicEnv;
    }

    // If the environment variable is not set, use the compiled value.
    if (compiledEnv != null &&
        compiledEnv.isNotEmpty &&
        compiledEnv != 'not set') {
      return compiledEnv;
    }

    // If neither value is set, return null.
    return null;
  }

// Retrieves a secret from the cloud.
//
// Takes four arguments:
//
// * [secrets]: An instance of the [GoogleSecretManager] class,
//         for interacting with the Google Secret Manager service.
// * [secretName]: The name of the secret to retrieve.
// * [originalValue]: The original value of the setting.
// * [environmentVar]: The name of the environment variable to check
//                     for a better value.
//
// Returns a `Future` that resolves to the secret value if it is found,
// or `null` if the secret is not found or there is an error.
  Future<String?> getSecretFromCloud(
    GoogleSecretManager secrets,
    String secretName,
    String? originalValue,
    String? environmentVar,
  ) async {
    if (Platform.environment.containsKey(environmentVar)) return originalValue;
    try {
      // Attempt to retrieve the secret from the cloud.
      final secret = await secrets.get(secretName);

      // If the secret is found, decode it and return the value.
      final decoded = utf8.decode(base64.decode(secret?.payload?.data ?? ''));
      return decoded.isEmpty ? originalValue : decoded;
    } catch (exception) {
      // Log any errors that occur during retrieval.
      logger?.e(exception.toString());
      return originalValue;
    }
  }

  // Update secrets from the cloud.
  Future<void> _updateFromCloud() async {
    if (secretsLocation != null) {
      final account =
          await getSecretsServiceAccount(_firebaseData, secretsLocation!);
      if (account != null) {
        // Ensure that only one copy of initSecretsManager is running at a time.
        await secretsManagerMutexLock
            .protect(() => initSecretsManager(account));
        await updateSecretsFromCloud(GoogleSecretManager.instance);
        logger?.t('Settings reinitialised');
        logValues();
      }
    }
    if (!_cloudSettingsInit.isCompleted) {
      _cloudSettingsInit.complete(true);
    }
  }

  // Initialise google secrets manager (only once!)
  Future<void> initSecretsManager(String account) async {
    if (!secretsManagerInitialised) {
      secretsManagerInitialised = true;
      await GoogleSecretManagerInitializer.initViaServiceAccountJson(
        account,
      );
    }
  }

  // Retrieves a service account from a specified location in firebase.
  //
  // Takes two arguments:
  //
  // * [fb]: An instance of the [FirebaseApplicationState] class,
  //         for interacting with the Firebase cloud storage service.
  // * [secretsLocation]: The path to the secret in Firebase.
  //
  // Returns a `Futurethe secret value if it is found,
  // or `null` if the secret is not found or there is an error.
  Future<String?> getSecretsServiceAccount(
    FirebaseApplicationState fb,
    String secretsLocation,
  ) async {
    // Extract collection and id from the secretsLocation.
    final match = RegExp(r'(.*)/([^/]*)$').firstMatch(secretsLocation);
    if (match == null || match.groupCount != 2) {
      return null; // Invalid secretsLocation format.
    }
    final collection = match.group(1)!;
    final id = match.group(2)!;

    // Fetch the record from the cloud storage.
    final record = await fb.fetchRecord(collection, id: id);

    return record?.toString();
  }
}
