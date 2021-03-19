import 'package:flutter/material.dart';
import 'package:my_movie_search/app.dart';
//import 'dart:io';
import 'package:universal_io/io.dart'
    show Platform; // limit inclusions to reduce size
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:my_movie_search/search_providers/online_offline_search.dart';

Future main() async {
  // Load variable from operating system environmnt or from .env file
  try {
    await DotEnv.load(fileName: ".env");
    await DotEnv.load(mergeWith: Platform.environment);
  } catch (e) {
    logger.e(
        "Expecting Platform.environment lookup error on web platform if using dart:io : $e");
  }

  // Set global state to control web access or offline cached files
  // If OFFLINE environment variable is not set behavior defaults to online
  OnlineOffline.offline =
      DotEnv.env["OFFLINE"].toLowerCase() == "true" ? true : false;
  logger.i("Offline status initialised to: ${OnlineOffline.offline}");

  runApp(MyApp());
}
