import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/utilities/settings.dart';

enum LogLevel { all, trace, debug, info, warning, error, fatal, off }

typedef LogOutputFunc =
    void Function(dynamic message, {dynamic error, StackTrace? stackTrace});

/// Centralized application logger with asynchronous Better Stack cloud syncing
///
/// cloud logs can be viewed at:
/// https://telemetry.betterstack.com/team/t550725/tail?s=2476806
class AppLogger {
  AppLogger._internal();

  /// Singleton instance
  static final AppLogger instance = AppLogger._internal();

  Logger? _logger;
  bool _enabled = false;

  // Better Stack logging endpoint
  final String _ingestUrl = 'https://s2476806.eu-fsn-3.betterstackdata.com';

  /// Initialize the logger
  void init({required bool enabled, required LogLevel level}) {
    _enabled = enabled;

    Level loggerLevel;
    switch (level) {
      case LogLevel.all:
        loggerLevel = Level.all;
      case LogLevel.trace:
        loggerLevel = Level.trace;
      case LogLevel.debug:
        loggerLevel = Level.debug;
      case LogLevel.info:
        loggerLevel = Level.info;
      case LogLevel.warning:
        loggerLevel = Level.warning;
      case LogLevel.error:
        loggerLevel = Level.error;
      case LogLevel.fatal:
        loggerLevel = Level.fatal;
      case LogLevel.off:
        loggerLevel = Level.off;
    }

    _logger = Logger(
      level: loggerLevel,
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 80,
      ),
    );
  }

  /// Log a message at trace level
  void trace(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud = false,
  }) {
    _outputLog(
      LogLevel.trace,
      _logger?.t,
      message,
      error,
      stackTrace,
      surpressCloud,
    );
  }

  /// Log a message at debug level
  void debug(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud = false,
  }) {
    _outputLog(
      LogLevel.debug,
      _logger?.d,
      message,
      error,
      stackTrace,
      surpressCloud,
    );
  }

  /// Log a message at info level
  void info(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud = false,
  }) {
    _outputLog(
      LogLevel.info,
      _logger?.i,
      message,
      error,
      stackTrace,
      surpressCloud,
    );
  }

  /// Log a message at warning level
  void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud = false,
  }) {
    _outputLog(
      LogLevel.warning,
      _logger?.w,
      message,
      error,
      stackTrace,
      surpressCloud,
    );
  }

  /// Log a message at error level
  void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud = false,
  }) {
    _outputLog(
      LogLevel.error,
      _logger?.e,
      message,
      error,
      stackTrace,
      surpressCloud,
    );
  }

  /// Log a message at fatal level
  void fatal(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud = false,
  }) {
    _outputLog(
      LogLevel.fatal,
      _logger?.f,
      message,
      error,
      stackTrace,
      surpressCloud,
    );
  }

  /// Output log to console only
  void _outputLog(
    LogLevel level,
    LogOutputFunc? func,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
    bool surpressCloud,
  ) {
    if (_enabled) {
      func?.call(message, error: error, stackTrace: stackTrace);
      if (!surpressCloud) {
        _sendToCloud(level.name.toUpperCase(), message, error, stackTrace);
      }
    }
  }

  /// Hide secret keys from log messages
  String _hideSecrets(dynamic message) {
    var newMessage = message.toString();
    for (final key in Secrets().secretStore) {
      newMessage = _hideSpecificSecret(newMessage, key);
    }
    return newMessage;
  }

  String _hideSpecificSecret(String message, String? secret) {
    if (secret == null) return message;
    return message.replaceAll(secret, '*' * secret.length);
  }

  /// Prepare log messages to be sent to Better Stack cloud
  void _sendToCloud(
    String level,
    dynamic message,
    dynamic error,
    StackTrace? stackTrace,
  ) {
    if (!_enabled) return;

    // Formats timestamp exactly as Better Stack expects
    final String timestamp = DateTime.now().toUtc().toString().replaceAll(
      'Z',
      ' UTC',
    );

    final Map<String, dynamic> payload = {
      'dt': timestamp,
      'level': level,
      'message': _hideSecrets(message),
      'platform': 'Android',
      if (error != null || stackTrace != null)
        'metadata': {
          if (error != null) 'error': error.toString(),
          if (stackTrace != null) 'stack_trace': stackTrace.toString(),
        },
    };

    _sendToCloudAsync(payload);
  }

  /// Send log messages to Better Stack cloud
  @awaitNotRequired
  Future<void> _sendToCloudAsync(Map<String, dynamic> logs) async {
    if (!_enabled) return;

    try {
      final response = await http.post(
        Uri.parse(_ingestUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Settings().loggingKey}',
        },
        body: jsonEncode(logs),
      );

      if (response.statusCode != 202 && response.statusCode != 200) {
        warning(
          'Better Stack rejected logs: ${response.body}',
          surpressCloud: true,
        );
      }
    } catch (e) {
      warning('Failed to send log to Better Stack: $e', surpressCloud: true);
    }
  }
}
