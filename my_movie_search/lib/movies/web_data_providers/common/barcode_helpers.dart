// Default hard coded known barcode for linux testing
// defaults to dexter season 1
//const dexterSeason1 = '9324915073425';
//const whileWereYoung = '9398711522494';
const testingBarcode = '9324915073425';

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
      .replaceAll(RegExp(r'\s+'), ' '); // remove repeated spaces.
}
