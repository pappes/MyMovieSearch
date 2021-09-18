import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:logger/logger.dart';
import '../secret.dart';

/// Read in application settings for the operating system environment.
///
/// Used for settings that vary between production/development environments
/// and for secrets tah cannot be stored in version control.
class EnvironmentVars {
  /// Read setting from the environment into in memory structures.
  ///
  /// To be called once during application initialisation before accessing values.
  static Future<Map<String, String>> init({Logger? logger}) async {
    // Load variable from operating system environmnt or from .env file
    final _logger = logger ?? Logger();
    await DotEnv.testLoad(fileInput: 'OFFLINE=false');
    /*try {
      await DotEnv.load(fileName: '.env');
      await DotEnv.load(mergeWith: Platform.environment);
    } catch (e) {
      if (!kIsWeb) {
        _logger.e('Unexpect Platform.environment lookup error '
            'on non-web platform using dart:io : $e');
      }
    }*/
    secret.forEach((key, value) => DotEnv.env[key] = value);

    return DotEnv.env;
  }
}
