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

const String _googleUrlEnvVariable = 'GOOGLE_URL';
const String _googleKeyEnvVariable = 'GOOGLE_KEY';
const String _omdbKeyEnvVariable = 'OMDB_KEY';
const String _tmdbKeyEnvVariable = 'TMDB_KEY';
const String _tvdbKeyEnvVariable = 'TVDB_KEY';
const String _meiliAdminKeyEnvVariable = 'MEILIADMIN_KEY';
const String _meiliSearchKeyEnvVariable = 'MEILISEARCH_KEY';
const String _meiliUrlEnvVariable = 'MEILISEARCH_URL';
const String _seVirtualMachineKeyEnvVariable = 'SE_VM_KEY';
const String _magnetServerEnvVariable = 'MAGNET_SERVER';
const String _magnetPortEnvVariable = 'MAGNET_PORT';
const String _magnetUsernameEnvVariable = 'MAGNET_USERNAME';
const String _magnetPasswordEnvVariable = 'MAGNET_PASSWORD';
const String _loggingKeyEnvVariable = 'LOGGING_KEY';
const String _firebaseSecretsLocationEnvVariable = 'SECRETS_LOCATION';
const String _offlineEnvVariable = 'OFFLINE';

const millisecondsPerSecond = 1000;

typedef SettingsCollection = Map<SettingKey, String>;

/// Stores all secret values.
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
/// 'MAGNET_SERVER': 'xxx.xxx.xxx.xxx'
/// 'MAGNET_PORT': 'xxxxx'
/// 'MAGNET_USERNAME': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'MAGNET_PASSWORD': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'LOGGING_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxx'
/// not applicable to cloud storage:
/// 'SECRETS_LOCATION': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
/// 'OFFLINE': '!true',
///            // Anything other than "true" results in false (case insensitive)
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
/// mms_ms = "xxx.xxx.xxx.xxx"
/// mms_mpo = "xxxxx"
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
/// export MAGNET_SERVER="xxx.xxx.xxx.xxx"
/// export MAGNET_PORT="xxxxx"
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
/// foo@bar:~$ export MAGNET_SERVER="xxx.xxx.xxx.xxx"
/// foo@bar:~$ export MAGNET_PORT="xxxxx"
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
///   --dart-define MAGNET_SERVER="xxx.xxx.xxx.xxx" \
///   --dart-define MAGNET_PORT="xxxxx" \
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
///   --dart-define MAGNET_SERVER="xxx.xxx.xxx.xxx" \
///   --dart-define MAGNET_PORT="xxxxx" \
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
///                 "MAGNET_SERVER=xxx.xxx.xxx.xxx",
///                 "--dart-define",
///                 "MAGNET_PORT=xxxxx",
///                 "--dart-define",
///                 "MAGNET_USERNAME=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "MAGNET_PASSWORD=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "LOGGING_KEY=xxxxxxxxxxxxxxxxxxxxxxxx",
///             ]
///         },
/// ```
class Settings {
  factory Settings() => _singleton;
  Settings._internal();
  static final Settings _singleton = Settings._internal();

  bool enableLogging = false;
  LogLevel logLevel = LogLevel.info;
  String applicationVersion = '';
  String applicationDescription = '';

  // Getters for each setting value.
  String? get googleUrl => _getSettingVal(SettingKey.googleUrl);
  String? get googleKey => _getSettingVal(SettingKey.googleKey);
  String? get omdbKey => _getSettingVal(SettingKey.omdbKey);
  String? get tmdbKey => _getSettingVal(SettingKey.tmdbKey);
  String? get tvdbKey => _getSettingVal(SettingKey.tvdbKey);
  String? get meiliAdminKey => _getSettingVal(SettingKey.meiliAdminKey);
  String? get meiliSearchKey => _getSettingVal(SettingKey.meiliSearchKey);
  String? get meiliUrl => _getSettingVal(SettingKey.meiliUrl);
  String? get seVmKey => _getSettingVal(SettingKey.seVirtualMachineKey);
  String? get magnetServer => _getSettingVal(SettingKey.magnetServer);
  String? get magnetPort => _getSettingVal(SettingKey.magnetPort);
  String? get magnetUsername => _getSettingVal(SettingKey.magnetUsername);
  String? get magnetPassword => _getSettingVal(SettingKey.magnetPassword);
  String? get loggingKey => _getSettingVal(SettingKey.loggingKey);
  String? get firebaseSecretsLocation =>
      _getSettingVal(SettingKey.firebaseSecretsLocation);

  bool get offline =>
      bool.tryParse(
        _resolveSettingValue(SettingKey.offline),
        caseSensitive: false,
      ) ??
      false;
  set offline(bool val) => _localValues[SettingKey.offline] = val.toString();

  // Individual settings source structures
  final SettingsCollection _runtimeEnvValues = {};
  final SettingsCollection _compileTimeValues = {};
  final SettingsCollection _cloudValues = {};
  final SettingsCollection _localValues = {};

  String? cloudValue(SettingKey key) => _cloudValues[key];
  String? localValue(SettingKey key) => _localValues[key];
  String? runtimeEnvValue(SettingKey key) => _runtimeEnvValues[key];

  late FirebaseApplicationState _firebaseData;
  Future<bool> cloudSettingsInitialised = Future.value(false);
  final _cloudSettingsInit = Completer<bool>();
  static final _settingsInitiaisedMutexLock = Mutex();

  bool _firebaseInitialised = false;
  String? _gcpSecretsProject;

  /// Initialize settings from all sources.
  ///
  /// To be called once during application initialisation and in tests
  /// before accessing values.
  /// Some settings are initalised asynchronously.
  @awaitNotRequired
  Future<bool> init() {
    if (!_cloudSettingsInit.isCompleted) {
      cloudSettingsInitialised = _cloudSettingsInit.future;
      AppLogger.instance.init(enabled: enableLogging, level: logLevel);
      // Manually initialise flutter to ensure that
      // settings can be loaded before RunApp
      // and to ensure tests are not prevented from calling real http endpoints.
      WidgetsFlutterBinding.ensureInitialized();
      _firebaseData = FirebaseApplicationState();

      _getSettingsFromRuntimeEnvironment();
      _getSettingsFromCompileTimeEnvironment();
      AppLogger.instance.trace('Settings initialised from env & compile time');
      logValues();
      return asyncInit();
    }
    return cloudSettingsInitialised;
  }

  @awaitNotRequired
  Future<bool> asyncInit() =>
      // Ensure that only one copy of _asyncInit is running at a time.
      _settingsInitiaisedMutexLock.protect(_asyncInit);

  Future<bool> _asyncInit() async {
    // Fire and forget initialisation of independent services.
    MagnetHelper.init();
    _fetchApplicationVersion();

    // Settings retreival that require async calls to complete before use.
    //await clearLocalSettings(); // uncomment to reset all settings!!!
    final pendingFetches = [
      _loadSettingsFromLocalStorage(),
      _updateFromCloud(),
    ];
    await Future.wait(pendingFetches);

    // Fire and forget async initialisation of services that rely on settings.
    unawaited(QueryTVDBCommon.init());

    if (!_cloudSettingsInit.isCompleted) {
      _cloudSettingsInit.complete(true);
    }
    return cloudSettingsInitialised;
  }

  /// Log all settings values.
  void logValues() {
    for (final key in SettingKey.values) {
      final resolvedValue = _getSettingVal(key);
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
        _updateLocalPref(key, value);
      }
    }
    logValues();
  }

  /// Get application version and description from pubspec.yaml
  @awaitNotRequired
  Future<void> _fetchApplicationVersion() async {
    final pubspec = await rootBundle.loadString('pubspec.yaml');
    final parsed = loadYaml(pubspec);
    if (parsed is Map &&
        parsed.containsKey('version') &&
        parsed.containsKey('description')) {
      applicationVersion = parsed['version'].toString();
      applicationDescription = parsed['description'].toString();
    }
  }

  /// Resolves value priority chain:
  ///   1. Local Storage (last user set)
  ///   2. Runtime Environment Variables
  ///   3. Cloud
  ///   4. Compile Time Values
  ///   5. Default values (lowest)
  String _resolveSettingValue(SettingKey key) {
    final localValue = _localValues[key];
    final cloudValue = _cloudValues[key];
    final environmentValue = _runtimeEnvValues[key];
    final compileTimeValue = _compileTimeValues[key];
    final defaultValue = key.defaultValue;
    if (localValue != null && localValue.isNotEmpty) {
      return localValue;
    }
    if (environmentValue != null && environmentValue.isNotEmpty) {
      return environmentValue;
    }
    if (cloudValue != null && cloudValue.isNotEmpty) {
      return cloudValue;
    }
    if (compileTimeValue != null && compileTimeValue.isNotEmpty) {
      return compileTimeValue;
    }
    if (defaultValue != null && defaultValue.isNotEmpty) {
      return defaultValue;
    }
    return '';
  }

  /// Search all sources for a setting value for the [SettingKey].
  ///
  /// Returns null if the setting value is empty.
  String? _getSettingVal(SettingKey key) {
    final val = _resolveSettingValue(key);
    return val.isEmpty ? null : val;
  }

  /// Read values from local storage.
  Future<void> _loadSettingsFromLocalStorage() async {
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

  /// Fetch values from runtime environment.
  void _getSettingsFromRuntimeEnvironment() {
    for (final key in SettingKey.values) {
      if (Platform.environment.containsKey(key.envKey)) {
        final val = Platform.environment[key.envKey];

        if (val != null && val.isNotEmpty && val != 'not set') {
          _runtimeEnvValues[key] = val;
          Secrets().addSecret(val);
        }
      }
    }
  }

  /// Fetch values from the compile time environment.
  void _getSettingsFromCompileTimeEnvironment() {
    for (final key in SettingKey.values) {
      final val = _compileTimeValue(key);

      if (val != null && val.isNotEmpty && val != 'not set') {
        _compileTimeValues[key] = val;
        Secrets().addSecret(val);
      }
    }
  }

  /// Fetch a value from the compile time enviroment.
  String? _compileTimeValue(SettingKey key) => switch (key) {
    SettingKey.googleUrl => const String.fromEnvironment(_googleUrlEnvVariable),
    SettingKey.googleKey => const String.fromEnvironment(_googleKeyEnvVariable),
    SettingKey.omdbKey => const String.fromEnvironment(_omdbKeyEnvVariable),
    SettingKey.tmdbKey => const String.fromEnvironment(_tmdbKeyEnvVariable),
    SettingKey.tvdbKey => const String.fromEnvironment(_tvdbKeyEnvVariable),
    SettingKey.meiliAdminKey => const String.fromEnvironment(
      _meiliAdminKeyEnvVariable,
    ),
    SettingKey.meiliSearchKey => const String.fromEnvironment(
      _meiliSearchKeyEnvVariable,
    ),
    SettingKey.meiliUrl => const String.fromEnvironment(_meiliUrlEnvVariable),
    SettingKey.magnetServer => const String.fromEnvironment(
      _magnetServerEnvVariable,
    ),
    SettingKey.magnetPort => const String.fromEnvironment(
      _magnetPortEnvVariable,
    ),
    SettingKey.magnetUsername => const String.fromEnvironment(
      _magnetUsernameEnvVariable,
    ),
    SettingKey.magnetPassword => const String.fromEnvironment(
      _magnetPasswordEnvVariable,
    ),
    SettingKey.loggingKey => const String.fromEnvironment(
      _loggingKeyEnvVariable,
    ),
    SettingKey.firebaseSecretsLocation => const String.fromEnvironment(
      _firebaseSecretsLocationEnvVariable,
    ),
    SettingKey.offline => const String.fromEnvironment(_offlineEnvVariable),
    _ => null,
  };

  /// Fetch values from GCP secrets manager.
  Future<void> _updateFromCloud() async {
    final client = await _getGCPClient();
    if (client != null) {
      try {
        final secretApi = SecretManagerApi(client);

        for (final key in SettingKey.values) {
          final secret = await _fetchSecretFromCloud(secretApi, key);
          if (secret != null) {
            _cloudValues[key] = secret;
            Secrets().addSecret(secret);
          }
        }
      } catch (e) {
        AppLogger.instance.error('Error fetching secrets from cloud: $e');
      } finally {
        client.close();
      }
      AppLogger.instance.trace('Settings reinitialised');
      logValues();
    }
  }

  /// Initialise GCP client for fetching secrets from cloud.
  Future<AutoRefreshingAuthClient?> _getGCPClient() async {
    if (!_firebaseInitialised) {
      _firebaseInitialised = true;
      await _firebaseData.init();
    }

    final location = firebaseSecretsLocation;
    if (location != null) {
      final account = await getSecretsServiceAccount(_firebaseData, location);
      if (account != null) {
        final credentials = ServiceAccountCredentials.fromJson(account);
        _gcpSecretsProject = (jsonDecode(account) as Map)['project_id']
            .toString();
        return clientViaServiceAccount(credentials, [
          SecretManagerApi.cloudPlatformScope,
        ]);
      }
    }
    return null;
  }

  /// Fetch values from cloud.
  Future<String?> _fetchSecretFromCloud(
    SecretManagerApi secrets,
    SettingKey key,
  ) async {
    try {
      final name =
          'projects/$_gcpSecretsProject/secrets/${key.cloudKey}/versions/latest';
      // Attempt to retrieve the secret from the cloud.
      final secret = await secrets.projects.secrets.versions.access(name);
      // If the secret is found, decode it and add to cloud settings.
      final data = secret.payload?.dataAsBytes;

      if (data != null) {
        final decoded = utf8.decode(data);
        if (decoded.isNotEmpty) {
          return decoded;
        }
      }
    } catch (e) {
      // Log any errors that occur during retrieval.
      AppLogger.instance.error(
        'Cloud lookup missing or rejected for key ${key.cloudKey}: $e',
      );
    }
    return null;
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
  @visibleForTesting
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

  /// Update a single preference.
  @awaitNotRequired
  Future<void> _updateLocalPref(SettingKey key, String? value) async {
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

  /// Clear all local settings.
  Future<void> _clearLocalSettings() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in SettingKey.values) {
      await prefs.remove(key.envKey);
    }
    _localValues.clear();
  }
}

/// Supported application settings identifiers.
///
/// Each source of settings (local preferences, remote cloud storage,
/// environment variables, compile-time defaults)
/// may have a value for each setting.
enum SettingKey {
  googleUrl(
    _googleUrlEnvVariable,
    'mms_gc',
    'https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=',
  ),
  googleKey(_googleKeyEnvVariable, 'mms_gk'),
  omdbKey(_omdbKeyEnvVariable, 'mms_o'),
  tmdbKey(_tmdbKeyEnvVariable, 'mms_t'),
  tvdbKey(_tvdbKeyEnvVariable, 'mms_tv'),
  meiliAdminKey(_meiliAdminKeyEnvVariable, 'mms_s'),
  meiliSearchKey(_meiliSearchKeyEnvVariable, 'mms_sk'),
  meiliUrl(_meiliUrlEnvVariable, 'mms_su', 'https://cloud.meilisearch.com/'),
  seVirtualMachineKey(_seVirtualMachineKeyEnvVariable, 'mms_se'),
  magnetServer(_magnetServerEnvVariable, 'mms_ms'),
  magnetPort(_magnetPortEnvVariable, 'mms_mpo'),
  magnetUsername(_magnetUsernameEnvVariable, 'mms_mu'),
  magnetPassword(_magnetPasswordEnvVariable, 'mms_mpw'),
  loggingKey(_loggingKeyEnvVariable, 'mms_l'),
  firebaseSecretsLocation(_firebaseSecretsLocationEnvVariable, ''),
  offline(_offlineEnvVariable, '');

  const SettingKey(this.envKey, this.cloudKey, [this.defaultValue]);

  final String envKey;
  final String cloudKey;
  final String? defaultValue;
}
