import 'package:flutter/material.dart';
import 'package:my_movie_search/app.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  try {
    await DotEnv.load(fileName: ".env");
    // Platform.environment will fail if deployment target is web
    await DotEnv.load(mergeWith: Platform.environment);
  } catch (e) {}
  runApp(MyApp());
}
