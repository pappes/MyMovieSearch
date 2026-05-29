import 'package:logger/logger.dart';

enum LogLevel { all, trace, debug, info, warning, error, fatal, off }

/// Centralized application logger
class AppLogger {
  AppLogger._internal();

  /// Singleton instance
  static final AppLogger instance = AppLogger._internal();

  Logger? _logger;
  bool _enabled = false;

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

    // fallback if package:logger Level.off doesn't exist in this version
    // We just rely on _enabled flag for now.
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
  void trace(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_enabled) {
      // using positional arguments for broad compatibility
      _logger?.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at debug level
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_enabled) {
      _logger?.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at info level
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_enabled) {
      _logger?.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at warning level
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_enabled) {
      _logger?.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at error level
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_enabled) {
      _logger?.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log a message at fatal level
  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_enabled) {
      _logger?.f(message, error: error, stackTrace: stackTrace);
    }
  }
}
