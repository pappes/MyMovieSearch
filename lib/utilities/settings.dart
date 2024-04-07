// ignore_for_file: do_not_use_environment

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:universal_io/io.dart';

/// Load application defined settings.
///
/// currently supported settings are:
/// 'OMDB_KEY': 'xxxxxxxx',
/// 'TMDB_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'GOOGLE_KEY': 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
/// 'GOOGLE_URL': 'https://customsearch.googleapis.com/customsearch/v1?cx=xxxxxxxxxxxx&key='
/// 'OFFLINE': '!true', // defaults to null (hence online)
///
///
/// This can be configured from the command line at compile time (recommended)
/// ```shell
/// foo@bar:~$ flutter run \
///   --dart-define OMDB_KEY="xxxxxxxx" \
///   --dart-define TMDB_KEY="xxxxxxxx" \
///   --dart-define GOOGLE_KEY="xxxxxxxx" \
///   --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key=" \
///   --dart-define OFFLINE="true"
/// ```
///
/// or from the command line at build time (recommended)
/// ```shell
/// foo@bar:~$ flutter build apk \
///   --dart-define OMDB_KEY="xxxxxxxx" \
///   --dart-define TMDB_KEY="xxxxxxxx" \
///   --dart-define GOOGLE_KEY="xxxxxxxx" \
///   --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// ```
///
/// or from the linux .profile/.bashrc at login time (recommended)
/// ```shell
/// export OMDB_KEY="xxxxxxxx"
/// export GOOGLE_KEY="xxxxxxxx"
/// export GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// export OMDB_KEY="xxxxxxxx"
/// ```
///
///
/// or from the command line at run time
/// ```shell
/// foo@bar:~$ export OMDB_KEY="xxxxxxxx"
/// foo@bar:~$ export GOOGLE_KEY="xxxxxxxx"
/// foo@bar:~$ export GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
/// foo@bar:~$ export OMDB_KEY="xxxxxxxx"
/// foo@bar:~$ export OFFLINE="true"
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
///                 "OMDB_KEY=xxxxxxxx",
///                 "--dart-define",
///                 "TMDB_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "GOOGLE_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
///                 "--dart-define",
///                 "GOOGLE_URL=https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
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
  // ignore: prefer_const_constructors
  String? omdbkey;
  // ignore: prefer_const_constructors
  String? tmdbkey;
  // ignore: prefer_const_constructors
  String? googlekey;
  // ignore: prefer_const_constructors
  String? googleurl;

  String? offlineText = const String.fromEnvironment('OFFLINE');
  bool get offline => 'true' == (offlineText?.toLowerCase() ?? '');
  set offline(bool val) => offlineText = val ? 'true' : 'false';

  /// Establish logger for use at runtime.
  ///
  /// To be called once during application initialisation
  /// before accessing values.
  void init([Logger? logger]) {
    this.logger = logger ?? this.logger;

    omdbkey = _getDynamicEnvOrCompiledEnv(
      'OMDB_KEY',
      const String.fromEnvironment('OMDB_KEY'),
    );
    tmdbkey = _getDynamicEnvOrCompiledEnv(
      'TMDB_KEY',
      const String.fromEnvironment('TMDB_KEY'),
    );
    googlekey = _getDynamicEnvOrCompiledEnv(
      'GOOGLE_KEY',
      const String.fromEnvironment('GOOGLE_KEY'),
    );
    googleurl = _getDynamicEnvOrCompiledEnv(
      'GOOGLE_URL',
      const String.fromEnvironment('GOOGLE_URL'),
    );

    // Manually initalise flutter to ensure setting can be loaded before RunApp
    // and to ensure tests are not prevented from calling real http enpoints
    WidgetsFlutterBinding.ensureInitialized();
    logger?.t('settings Initialised');
    if (omdbkey == '') logger?.t('OMDB_KEY is empty');
    if (omdbkey == null) logger?.t('OMDB_KEY is null');
    logger?.t('settings fetched OMDB_KEY: $omdbkey');
    logger?.t('settings fetched TMDB_KEY: $tmdbkey');
    logger?.t('settings fetched GOOGLE_KEY: $googlekey');
    logger?.t('settings fetched GOOGLE_URL: $googleurl');
    logger?.t('settings fetched OFFLINE: $offline');
  }

  // Allow compiler to supply a value for [compiledEnv] e.g.
  // const String.fromEnvironment('OMDB_KEY')
  // if the runtime environemnt does not define [environmentVar] e.g. 'OMDB_KEY'
  String? _getDynamicEnvOrCompiledEnv(
    String environmentVar,
    String? compiledEnv,
  ) {
    final dynamicEnv = Platform.environment[environmentVar];
    if (dynamicEnv == null || dynamicEnv.isEmpty || dynamicEnv == 'not set') {
      if (compiledEnv == null ||
          compiledEnv.isEmpty ||
          compiledEnv == 'not set') {
        return null;
      }
      return compiledEnv;
    }
    return dynamicEnv;
  }
}
