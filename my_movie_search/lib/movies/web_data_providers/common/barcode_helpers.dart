import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:universal_io/io.dart';

typedef BarcodeAction = void Function(String barcode);

// Default hard coded known barcode for linux testing
// defaults to dexter season 1
//const dexterSeason1 = '9324915073425';
//const whileWereYoung = '9398711522494';
const testingBarcode = '9324915073425';

class DVDBarcodeScanner {
  late BuildContext context;
  late BarcodeAction action;

  bool _useBarcode(dynamic barcode) {
    if (barcode == null || barcode.toString().isEmpty) {
      // Assume the user requested cancelation
      return true;
    } else if (barcode is String && !barcode.startsWith(webAddressPrefix)) {
      action(barcode);
      return true;
    }
    return false;
  }

  Future<dynamic> _showScanner() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ),
      );

  void _retryScanIfFailed(bool success) {
    if (!success) {
      _scan();
    }
  }

  void _scan() => _showScanner()
      .then((scannedBarcode) => _useBarcode(scannedBarcode))
      .then(_retryScanIfFailed);

  /// Uses camera to read 2D Barcodes.
  ///
  /// Ignores any detected QRcodes
  /// Requires [context] to draw the page with the camera contents and cancel button.
  /// Invokes callback [action] with the string encoded in the barcode.
  void scanBarcode(BuildContext context, BarcodeAction action) {
    this.context = context;
    this.action = action;
    if (Platform.isAndroid) {
      _scan();
    } else {
      _useBarcode(testingBarcode);
    }
  }
}

/// Determin if the barcode search site sources data from Ebay.
///
/// ```dart
/// isEbay(DataSourceType.picclickBarcode);
/// ```
bool isEbay(DataSourceType source) =>
    DataSourceType.picclickBarcode == source ||
    DataSourceType.uhttBarcode == source;

/// Extract the DVDtitle from a DTO.
///
/// ```dart
/// getCleanDvdTitle('Dexter : Season 1 2006 Box Set DVD 8 discs Like New');
/// //returns 'Dexter 2006 8 '
/// ```
String getSearchTitle(MovieResultDTO movie) {
  if (movie.title.isEmpty) {
    return movie.alternateTitle;
  }
  return '${movie.title} ${movie.year}';
}

/// Extract the DVDtitle from a sales pitch.
///
/// ```dart
/// getCleanDvdTitle('Dexter : Season 1 2006 Box Set DVD 8 discs Like New');
/// //returns 'Dexter 2006 8 '
/// ```
String getCleanDvdTitle(String? title) {
  if (null == title || title.isEmpty) {
    return '';
  }

  return '$title '
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s\d]+'), ' ') // Strip all punctuation
      .replaceAll('dvd', '')
      .replaceAll('bluray', '')
      .replaceAll('blueray', '')
      .replaceAll('boxset', '')
      .replaceAll(RegExp(r'region\s*\d'), ' ') // region 1, region 2 , etc
      .replaceAll(RegExp(r'season\s*\d'), ' ') // season 1, season 2 , etc
      .replaceAll(RegExp(r'series\s*\d'), ' ') // series 1, series 2 , etc
      .replaceAll('first season', '')
      .replaceAll('1st season', '')
      .replaceAll('first series', '')
      .replaceAll('1st series', '')
      .replaceAll('second season', '')
      .replaceAll('2nd season', '')
      .replaceAll('second series', '')
      .replaceAll('2nd series', '')
      .replaceAll('third season', '')
      .replaceAll('3rd season', '')
      .replaceAll('third series', '')
      .replaceAll('3rd series', '')
      .replaceAll(' complete ', ' ')
      .replaceAll(' box sets ', '')
      .replaceAll(' box set ', '')
      .replaceAll(' boxed sets ', '')
      .replaceAll(' season ', ' ')
      .replaceAll(' seasons ', ' ')
      .replaceAll(' tv series ', ' ')
      .replaceAll(' collectors edition ', ' ')
      .replaceAll(' pal ', ' ')
      .replaceAll(' discs ', ' ')
      .replaceAll(' disc ', ' ')
      .replaceAll(' disk ', ' ')
      .replaceAll(' like new ', ' ')
      .replaceAll(' new condition ', ' ')
      .replaceAll(' excellent condition ', ' ')
      .replaceAll(' new ', ' ')
      .replaceAll(' free postage ', ' ')
      .reduceWhitespace(); // remove repeated spaces.
}
