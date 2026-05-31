// settings are supported from multiple locations
// ignore_for_file: do_not_use_environment

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/secretmanager/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:meta/meta.dart';
import 'package:mutex/mutex.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_helper.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/tvdb_common.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';
import 'package:yaml/yaml.dart';

/// Supported application settings identifiers.
enum SettingKey {
  googleUrl(
    'GOOGLE_URL',
    'mms_gc',
    'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=',
  ),
  googleKey('GOOGLE_KEY', 'mms_gk'),
  omdbKey('OMDB_KEY', 'mms_o'),
  tmdbKey('TMDB_KEY', 'mms_t'),
  tvdbKey('TVDB_KEY', 'mms_tv'),
  meiliAdminKey('MEILIADMIN_KEY', 'mms_s'),
  meiliSearchKey('MEILISEARCH_KEY', 'mms_sk'),
  meiliUrl('MEILISEARCH_URL', 'mms_su', 'https://cloud.meilisearch.com/'),
  seVirtualMachineKey('SE_VM_KEY', 'mms_se'),
  magnetServer('MAGNET_SERVER', 'mms_ms'),
  magnetPort('MAGNET_PORT', 'mms_mpo'),
  magnetUsername('MAGNET_USERNAME', 'mms_mu'),
  magnetPassword('MAGNET_PASSWORD', 'mms_mpw'),
  loggingKey('LOGGING_KEY', 'mms_l'),
  firebaseSecretsLocation('SECRETS_LOCATION', ''),
  offline('OFFLINE', '');

  const SettingKey(this.envKey, this.cloudKey, [this.defaultValue]);

  final String envKey;
  final String cloudKey;
  final String? defaultValue;
}

typedef SettingsCollection = Map<SettingKey, String>;

/// Load application defined settings.
///
/// currently supported setting locations are:
/// 0) source code
/// 1) compiled dart-define values
/// 2) google secrets (cloud)
/// 3) runtime environment variables
/// 4) local settings stored in shared preferences
/// it is recommended to use 2) or 4) for API keys and other sensitive info
/// it is recommended to use 3) for test environments
///
///
/// currently supported settings are:
/// 'GOOGLE_URL': 'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&key='
/// 'GOOGLE_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'OMDB_KEY': 'xxxxxxxx',
/// 'TMDB_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'TVDB_KEY': 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
/// 'MEILIADMIN_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'MEILISEARCH_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'MEILISEARCH_URL': 'https://cloud.meilisearch.com/',
/// 'MAGNET_SERVER': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'MAGNET_PORT': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'MAGNET_USERNAME': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'MAGNET_PASSWORD': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'LOGGING_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxx'
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
/// mms_ms = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_mpo = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_mu = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_mpw = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// mms_l = "xxxxxxxxxxxxxxxxxxxxxxxx"
/// SECRETS_LOCATION and OFFLINE are not applicable to cloud storage.
///
/// or from the linux .profile/.bashrc at login time
/// ```shell
/// export GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// export GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export OMDB_KEY="xxxxxxxx"
/// export TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export TVDB_KEY="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
/// export MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MEILISEARCH_URL="https://cloud.meilisearch.com/"
/// export SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export OFFLINE="true"
/// export MAGNET_SERVER="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MAGNET_PORT="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MAGNET_USERNAME="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export MAGNET_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// export LOGGING_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
/// ```
///
///
/// or from the command line at run time
/// ```shell
/// foo@bar:~$ export GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// foo@bar:~$ export GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export OMDB_KEY="xxxxxxxx"
/// foo@bar:~$ export TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export TVDB_KEY="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
/// foo@bar:~$ export MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MEILISEARCH_URL="https://cloud.meilisearch.com/"
/// foo@bar:~$ export SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export OFFLINE="true"
/// foo@bar:~$ export MAGNET_SERVER="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MAGNET_PORT="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MAGNET_USERNAME="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export MAGNET_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
/// foo@bar:~$ export LOGGING_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
/// ```
///
///
/// or from the command line at compile time
/// ```shell
/// foo@bar:~$ flutter run \
///   --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=" \
///   --dart-define GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OMDB_KEY="xxxxxxxx" \
///   --dart-define TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define TVDB_KEY="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
///   --dart-define MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MEILISEARCH_URL="https://cloud.meilisearch.com/" \
///   --dart-define SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OFFLINE="true" \
///   --dart-define MAGNET_SERVER="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MAGNET_PORT="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MAGNET_USERNAME="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MAGNET_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define LOGGING_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
/// ```
///
/// or from the command line at build time
/// ```shell
/// foo@bar:~$ flutter build apk \
///   --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
///   --dart-define GOOGLE_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OMDB_KEY="xxxxxxxx" \
///   --dart-define TMDB_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define TVDB_KEY="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" \
///   --dart-define MEILIADMIN_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MEILISEARCH_KEY="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MEILISEARCH_URL="https://cloud.meilisearch.com/" \
///   --dart-define SECRETS_LOCATION="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define OFFLINE="true" \
///   --dart-define MAGNET_SERVER="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MAGNET_PORT="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MAGNET_USERNAME="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define MAGNET_PASSWORD="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
///   --dart-define LOGGING_KEY="xxxxxxxxxxxxxxxxxxxxxxxx"
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
///                 "TVDB_KEY=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
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
///                 "--dart-define",
///                 "MAGNET_SERVER=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MAGNET_PORT=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MAGNET_USERNAME=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MAGNET_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "LOGGING_KEY=xxxxxxxxxxxxxxxxxxxxxxxx",
///             ]
///         },
/// ```

const millisecondsPerSecond = 1000;

class Settings {
  factory Settings() => _singleton;
  Settings._internal();
  static final Settings _singleton = Settings._internal();

  bool enableLogging = false;
  LogLevel logLevel = LogLevel.info;
  String applicationVersion = '';
  String applicationDescription = '';
  String? gcpSecretsProject;

  // Concentrated settings structures
  final SettingsCollection _environmentValues = {};
  final SettingsCollection _cloudValues = {};
  final SettingsCollection _localValues = {};

  String? cloudValue(SettingKey key) => _cloudValues[key];
  String? localValue(SettingKey key) => _localValues[key];
  String? environmentValue(SettingKey key) => _environmentValues[key];

  // Hierarchy Cascading Getters
  String get googleUrl => _resolve(SettingKey.googleUrl);
  String? get googleKey => _resolveNullable(SettingKey.googleKey);
  String? get omdbKey => _resolveNullable(SettingKey.omdbKey);
  String? get tmdbKey => _resolveNullable(SettingKey.tmdbKey);
  String? get tvdbKey => _resolveNullable(SettingKey.tvdbKey);
  String? get meiliAdminKey => _resolveNullable(SettingKey.meiliAdminKey);
  String? get meiliSearchKey => _resolveNullable(SettingKey.meiliSearchKey);
  String get meiliUrl => _resolve(SettingKey.meiliUrl);
  String? get seVmKey => _resolveNullable(SettingKey.seVirtualMachineKey);
  String? get magnetServer => _resolveNullable(SettingKey.magnetServer);
  String? get magnetPort => _resolveNullable(SettingKey.magnetPort);
  String? get magnetUsername => _resolveNullable(SettingKey.magnetUsername);
  String? get magnetPassword => _resolveNullable(SettingKey.magnetPassword);
  String? get loggingKey => _resolveNullable(SettingKey.loggingKey);
  String? get firebaseSecretsLocation =>
      _resolveNullable(SettingKey.firebaseSecretsLocation);

  bool get offline => 'true' == _resolve(SettingKey.offline).toLowerCase();
  set offline(bool val) =>
      _localValues[SettingKey.offline] = val ? 'true' : '!true';

  late FirebaseApplicationState _firebaseData;
  bool _firebaseInitialised = false;
  Future<bool> cloudSettingsInitialised = Future.value(false);
  final _cloudSettingsInit = Completer<bool>();
  static final secretsInitiaisedMutexLock = Mutex();

  /// Resolves value priority chain: Local Storage overrides Cloud, Cloud overrides Env/Defaults.
  String _resolve(SettingKey key) {
    final localValue = _localValues[key];
    final cloudValue = _cloudValues[key];
    final environmentValue = _environmentValues[key];
    final defaultValue = key.defaultValue;
    if (localValue != null && localValue.isNotEmpty) {
      return localValue;
    }
    if (cloudValue != null && cloudValue.isNotEmpty) {
      return cloudValue;
    }
    if (environmentValue != null && environmentValue.isNotEmpty) {
      return environmentValue;
    }
    if (defaultValue != null && defaultValue.isNotEmpty) {
      return defaultValue;
    }
    return '';
  }

  String? _resolveNullable(SettingKey key) {
    final val = _resolve(key);
    return val.isEmpty ? null : val;
  }

  /// Initialize settings from all sources.
  ///
  /// To be called once during application initialisation and in tests
  /// before accessing values.
  void init() {
    if (!_cloudSettingsInit.isCompleted) {
      cloudSettingsInitialised = _cloudSettingsInit.future;
      AppLogger.instance.init(enabled: enableLogging, level: logLevel);
      // Manually initialise flutter to ensure that
      // settings can be loaded before RunApp
      // and to ensure tests are not prevented from calling real http endpoints.
      WidgetsFlutterBinding.ensureInitialized();
      _firebaseData = FirebaseApplicationState();

      getSecretsFromEnvironment();
      AppLogger.instance.trace('Settings initialised');
      logValues();
      asyncInit();
    }
  }

  @awaitNotRequired
  Future<void> asyncInit() =>
      // Ensure that only one copy of _asyncInit is running at a time.
      secretsInitiaisedMutexLock.protect(_asyncInit);

  Future<void> _asyncInit() async {
    MagnetHelper.init();
    _getApplicationVersion();
    if (!_firebaseInitialised) {
      _firebaseInitialised = true;
      await _firebaseData.init();
    }
    await _updateFromCloud();
    //await clearLocalSettings(); // uncomment to reset all settings!!!
    await _loadFromLocal();
    unawaited(QueryTVDBCommon.init());
  }

  @awaitNotRequired
  Future<void> _getApplicationVersion() async {
    final pubspec = await rootBundle.loadString('pubspec.yaml');
    final parsed = loadYaml(pubspec);
    if (parsed is Map &&
        parsed.containsKey('version') &&
        parsed.containsKey('description')) {
      applicationVersion = parsed['version'].toString();
      applicationDescription = parsed['description'].toString();
    }
  }

  /// Fetch values from runtime environment or compile time environment.
  void getSecretsFromEnvironment() {
    for (final key in SettingKey.values) {
      String? val;
      // Fetch platform environment variables safely
      if (Platform.environment.containsKey(key.envKey)) {
        val = Platform.environment[key.envKey];
      }

      // Fallback matching your compile-time String.fromEnvironment assignments
      val ??= _compileTimeFallback(key);

      if (val != null && val.isNotEmpty && val != 'not set') {
        _environmentValues[key] = val;
        Secrets().addSecret(val);
      }
    }
  }

  /// Fetch a value from the compile time enviroment.
  String? _compileTimeFallback(SettingKey key) => switch (key) {
    SettingKey.googleUrl => const String.fromEnvironment('GOOGLE_URL'),
    SettingKey.googleKey => const String.fromEnvironment('GOOGLE_KEY'),
    SettingKey.omdbKey => const String.fromEnvironment('OMDB_KEY'),
    SettingKey.tmdbKey => const String.fromEnvironment('TMDB_KEY'),
    SettingKey.tvdbKey => const String.fromEnvironment('TVDB_KEY'),
    SettingKey.meiliAdminKey => const String.fromEnvironment('MEILIADMIN_KEY'),
    SettingKey.meiliSearchKey => const String.fromEnvironment(
      'MEILISEARCH_KEY',
    ),
    SettingKey.meiliUrl => const String.fromEnvironment('MEILISEARCH_URL'),
    SettingKey.magnetServer => const String.fromEnvironment('MAGNET_SERVER'),
    SettingKey.magnetPort => const String.fromEnvironment('MAGNET_PORT'),
    SettingKey.magnetUsername => const String.fromEnvironment(
      'MAGNET_USERNAME',
    ),
    SettingKey.magnetPassword => const String.fromEnvironment(
      'MAGNET_PASSWORD',
    ),
    SettingKey.loggingKey => const String.fromEnvironment('LOGGING_KEY'),
    SettingKey.firebaseSecretsLocation => const String.fromEnvironment(
      'SECRETS_LOCATION',
    ),
    SettingKey.offline => const String.fromEnvironment('OFFLINE'),
    _ => null,
  };

  /// Fetch values from cloud.
  Future<void> updateSecretsFromCloud(SecretManagerApi secrets) async {
    for (final key in SettingKey.values) {
      if (key.cloudKey.isEmpty ||
          Platform.environment.containsKey(key.envKey)) {
        continue;
      }

      try {
        final name =
            'projects/$gcpSecretsProject/secrets/${key.cloudKey}/versions/latest';
        // Attempt to retrieve the secret from the cloud.
        final secret = await secrets.projects.secrets.versions.access(name);
        // If the secret is found, decode it and add to cloud settings.
        final data = secret.payload?.dataAsBytes;

        if (data != null) {
          final decoded = utf8.decode(data);
          if (decoded.isNotEmpty) {
            _cloudValues[key] = decoded;
            Secrets().addSecret(decoded);
          }
        }
      } catch (e) {
        // Log any errors that occur during retrieval.
        AppLogger.instance.error(
          'Cloud lookup missing or rejected for key ${key.cloudKey}: $e',
        );
      }
    }
  }

  void logValues() {
    for (final key in SettingKey.values) {
      final resolvedValue = _resolveNullable(key);
      AppLogger.instance.trace(
        'settings fetched ${key.envKey}: $resolvedValue',
      );
      if (resolvedValue == '') {
        AppLogger.instance.trace('${key.envKey} is empty');
      }
      if (resolvedValue == null) {
        AppLogger.instance.trace('${key.envKey} is null');
      }
    }
  }

  /// Fetch values from Firebase Firestore.
  Future<void> _updateFromCloud() async {
    final location = firebaseSecretsLocation;
    if (location != null) {
      final account = await getSecretsServiceAccount(_firebaseData, location);
      if (account != null) {
        final credentials = ServiceAccountCredentials.fromJson(account);
        gcpSecretsProject = (jsonDecode(account) as Map)['project_id']
            .toString();
        final client = await clientViaServiceAccount(credentials, [
          SecretManagerApi.cloudPlatformScope,
        ]);
        final secretApi = SecretManagerApi(client);

        await updateSecretsFromCloud(secretApi);
        client.close();
        AppLogger.instance.trace('Settings reinitialised');
        logValues();
      }
    }
    if (!_cloudSettingsInit.isCompleted) {
      _cloudSettingsInit.complete(true);
    }
  }

  // Retrieves a service account from a specified location in firebase.
  //
  // Takes two arguments:
  //
  // * [fb]: An instance of the [FirebaseApplicationState] class,
  //         for interacting with the Firebase cloud storage service.
  // * [firebaseSecretsLocation]: The path to the secret in Firebase.
  //
  // Returns a `Future` that resolves to e secret value if it is found,
  // or `null` if the secret is not found or there is an error.
  Future<String?> getSecretsServiceAccount(
    FirebaseApplicationState fb,
    String firebaseSecretsLocation,
  ) async {
    // Extract collection and id from the firebaseSecretsLocation.
    final match = RegExp(r'(.*)/([^/]*)$').firstMatch(firebaseSecretsLocation);
    if (match == null || match.groupCount != 2) {
      return null; // Invalid firebaseSecretsLocation format.
    }
    final collection = match.group(1)!;
    final id = match.group(2)!;

    // Fetch the record from the cloud storage.
    final record = await fb.fetchRecord(collection, id: id);

    final secret = record?.toString();
    Secrets().addSecret(secret);
    return secret;
  }

  /// Read values from local storage.
  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      for (final key in SettingKey.values) {
        final val = prefs.getString(key.envKey);
        if (val != null && val.isNotEmpty) {
          _localValues[key] = val;
          Secrets().addSecret(val);
        }
      }
      logValues();
    } catch (e) {
      AppLogger.instance.error('Failed to load local settings: $e');
    }
  }

  /// Save new values to local storage.
  void saveToLocal(SettingsCollection newValues) {
    for (final key in SettingKey.values) {
      final value = newValues[key];
      if (value != _localValues[key]) {
        if (value != null) {
          _localValues[key] = value;
        } else {
          _localValues.remove(key);
        }
        updateLocalPref(key, value);
      }
    }
    logValues();
  }

  /// Update a single preference.
  @awaitNotRequired
  Future<void> updateLocalPref(SettingKey key, String? value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value != null && value.isNotEmpty) {
        Secrets().addSecret(value);
        await prefs.setString(key.envKey, value);
      } else {
        await prefs.remove(key.envKey);
      }
    } catch (e) {
      AppLogger.instance.error('Failed to update local setting: $e');
    }
  }

  Future<void> clearLocalSettings() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in SettingKey.values) {
      await prefs.remove(key.envKey);
    }
    _localValues.clear();
  }
}

class Secrets {
  factory Secrets() => _singleton;
  Secrets._internal();
  static final Secrets _singleton = Secrets._internal();

  final secretStore = <String>{};

  void addSecret(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      secretStore.add(value);
    }
  }
}
