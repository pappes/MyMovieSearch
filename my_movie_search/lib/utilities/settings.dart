import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

/// Load application defined settings.
class Settings {
  Settings({Logger? logger, Map<String, String>? override}) {
    unawaited(init(logger: logger, override: override));
  }
  Settings._internal();

  factory Settings.singleton() => _singleton;

  static final Settings _singleton = Settings._internal();
  final Map<String, String> _settingsMap = {};

  String? get(String key) => _settingsMap[key];

  Future<Map<String, dynamic>> _loadFile([
    String location = 'assets/settings.json',
  ]) async {
    final json = await rootBundle.loadString(location);
    return jsonDecode(json) as Map<String, dynamic>
      ..forEach((key, value) => _settingsMap[key] = value as String);
  }

  /// Read setting from files into in memory structures.
  ///
  /// To be called once during application initialisation
  /// before accessing values.

  Future<void> init({Logger? logger, Map<String, String>? override}) async {
    // Manually initalise flutter to ensure setting can be loaded before RunApp
    // and to ensure tests are not prevented from calling real http enpoints
    WidgetsFlutterBinding.ensureInitialized();
    final map = await _loadFile();
    logger?.t('settings loaded : $map');
    final secrets = await _loadFile('assets/secrets.json');
    logger?.t('secrets loaded : $secrets');
  }
}
