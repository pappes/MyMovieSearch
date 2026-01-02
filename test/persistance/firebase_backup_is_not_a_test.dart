import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/models/movie_location.dart';
import 'package:my_movie_search/utilities/web_data/online_offline_search.dart';

void main() {
  group('firebase backup', () {
    // Backup data stored in firebase to /tmp/firebaseBackup<date>.txt
    //
    // backupFirebaseData gets data from firebase,
    // json encodes it and writes it to a file.
    // Any local caches are cleared and data reloaded from source to ensure
    // that the data is up to date.
    test(
      timeout: const Timeout(Duration(minutes: 60)),
      skip: true,
      'backupFirebaseData',
      () async {
        await backupFirebaseData();
      },
    );
  });
}

Future<void> backupFirebaseData() async {
  logger.w(
    'Constant lastFirebaseBackupDate needs to be updated in '
    'lib/movies/models/movie_location.dart',
  );
  const filename = 'assets/newDVDLibrary.json';

  await writeDataFile(filename, _getJsonText);
}

Future<String> _getJsonText() async {
  final fbData = await getFirebaseData();
  final jsonData = const JsonEncoder.withIndent('  ').convert(fbData);
  return jsonData;
}

typedef JsonCallback = Future<String> Function();

Future<void> writeDataFile(String filename, JsonCallback jsonGenerator) async {
  WidgetsFlutterBinding.ensureInitialized();

  logger.w(
    'backup started at timestamp ${DateTime.now().millisecondsSinceEpoch}',
  );

  final data = await jsonGenerator();
  await File(filename).writeAsString(data, flush: true);

  logger.w(
    'Backup written to $filename '
    'file size: ${data.length}',
  );
}

Future<Map<String, dynamic>> getFirebaseData() async {
  WidgetsFlutterBinding.ensureInitialized();
  final fb = MovieLocation();
  final data = await fb.getBackupData();

  logger.w('Database statistics: ${fb.statistics()}');
  return data;
}
