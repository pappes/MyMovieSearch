import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart'
    show Platform; // limit inclusions to reduce size

import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:logger/logger.dart';

class EnvironmentVars {
  static Future<Map<String, String>> init({Logger? logger}) async {
    // Load variable from operating system environmnt or from .env file
    final _logger = logger ?? Logger();
    await DotEnv.testLoad(fileInput: 'OFFLINE=true');
    try {
      await DotEnv.load(fileName: '.env');
      await DotEnv.load(mergeWith: Platform.environment);
    } catch (e) {
      if (!kIsWeb) {
        _logger.e('Unexpect Platform.environment lookup error '
            'on non-web platform using dart:io : $e');
      }
    }
    return DotEnv.env;
  }
}
