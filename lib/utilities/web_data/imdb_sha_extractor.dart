import 'dart:async';
import 'package:logger/logger.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
//import 'package:my_movie_search/utilities/web_data/platform_android/imdb_sha_extractor.dart' if (Platform.isAndroid) 'android_specific.dart'
//  else 'package:my_movie_search/utilities/web_data/platform_other/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/imdb_sha_extractor.dart'
    if (Platform.isLinux) 'package:my_movie_search/utilities/web_data/platform_linux/imdb_sha_extractor.dart'
    if (Platform.isAndroid) 'package:my_movie_search/utilities/web_data/platform_android/imdb_sha_extractor.dart';

const imdbAddressMale = 'https://www.imdb.com/name/nm0000095';
const imdbAddressFemale = 'https://www.imdb.com/name/nm0000149';

/// Extract the sha from a web page
/// using a platform specific implementation to drive a web browser.
abstract class IMDBShaExtractor {
  /// Constructor to create a new instance
  /// of the appropriate platform specific implementation.
  factory IMDBShaExtractor(
    Map<ImdbJsonSource, String> imdbShaMap,
    ImdbJsonSource imdbSource,
  ) {
    // Use environemnt variable to drive platform specific implementation
    // so that the compiler can tree shake unused code.
    // ignore: do_not_use_environment
    if (const bool.fromEnvironment('IS_ANDROID')) {
      final init = WebPageShaExtractorPlatform.internal(imdbShaMap, imdbSource);
    }

    return WebPageShaExtractorPlatform.internal(imdbShaMap, imdbSource);
  }

  /// Internal constructor to setup internal state for the instance.
  IMDBShaExtractor.internal(this.imdbShaMap, this.imdbSource);

  /// Updatable map of IMDB sources to their corresponding sha values.
  Map<ImdbJsonSource, String> imdbShaMap;

  /// The IMDB source to extract the sha for.
  ImdbJsonSource imdbSource;

  /// Fetch the updated sha from IMDB.
  Future<void> updateSha();

  /// Extract the sha from the given [url] text.
  String? extractShaFromWebText(String url) {
    const shaName = 'NameMainFilmographyPaginatedCredits';
    const shaPrefix = '%22sha256Hash%22%3A%22';
    const shaSuffix = '%22';
    const shaChars = 'a-fA-F0-9';
    const shaLength = 64;
    const regex = '$shaName.*?$shaPrefix([$shaChars]{$shaLength})$shaSuffix';
    final match = RegExp(regex).firstMatch(url);
    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    }
    return null;
  }

  // Get the address of the IMDB page that contains the sha
  // based on the [imdbSource].
  Uri? getImdbAddress() => switch (imdbSource) {
    ImdbJsonSource.actor => Uri.parse(imdbAddressMale),
    ImdbJsonSource.actress => Uri.parse(imdbAddressFemale),
    ImdbJsonSource.director => Uri.parse(imdbAddressFemale),
    ImdbJsonSource.producer => Uri.parse(imdbAddressFemale),
    ImdbJsonSource.writer => Uri.parse(imdbAddressMale),
  };

  void setShaValue(String? newSha) {
    if (newSha != null) {
      Logger().i('Extracted sha for $imdbSource: $newSha');
      imdbShaMap[imdbSource] = newSha;
    }
  }
}
