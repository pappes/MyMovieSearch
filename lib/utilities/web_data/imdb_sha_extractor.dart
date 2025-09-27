import 'dart:async';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/platform_android/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/imdb_sha_extractor.dart';

const imdbAddressMale = 'https://www.imdb.com/name/nm0000078';
const imdbAddressFemale = 'https://www.imdb.com/name/nm0000149';
const imdbAddressDirector = 'https://www.imdb.com/name/nm0000033';
const imdbAddressWriter = 'https://www.imdb.com/name/nm0000697';
const imdbAddressProducer = 'https://www.imdb.com/name/nm0000229';

/// Extract the sha from a web page
/// using a platform specific implementation to drive a web browser.
abstract class IMDBShaExtractor {
  /// Constructor to create a new instance
  /// of the appropriate platform specific implementation.
  factory IMDBShaExtractor(
    Map<ImdbJsonSource, String> imdbShaMap,
    ImdbJsonSource imdbSource,
  ) {
    // TODO: Use environemnt variable to drive platform specific implementation
    // so that the compiler can tree shake unused code.
    if (Platform.isAndroid) {
      return WebPageShaExtractorAndroid.internal(imdbShaMap, imdbSource);
    }
    if (Platform.isLinux) {
      return WebPageShaExtractorLinux.internal(imdbShaMap, imdbSource);
    }

    return WebPageShaExtractorOther.internal(imdbShaMap, imdbSource);
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
    ImdbJsonSource.director => Uri.parse(imdbAddressDirector),
    ImdbJsonSource.producer => Uri.parse(imdbAddressProducer),
    ImdbJsonSource.writer => Uri.parse(imdbAddressWriter),
    ImdbJsonSource.credits => Uri.parse(imdbAddressMale)
  };

  // Expand all credits for the role.
  String getClickOnCostumeDepartment() =>
  getClickOnButton('Costume Department');

  // Expand all credits for the role.
  String getClickOnSeeAll() =>
  getClickOnButton('See all');

  // Get the CSS selector for the page element to click on.
  String getClickOnButton(String text) =>
  '''
  // The XPath expression `//button[contains(., "show all")]` means:
  // //         - Search anywhere in the document
  // button     - for a <button> element
  // [contains(., "text")] - where its text content (represented by '.') contains the given text.
  const xpath = `//button[contains(., '$text')]`;

  const result = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
  result.singleNodeValue.click();
''';

  bool setShaValue(String? newSha) {
    if (newSha != null) {
      Logger().i('Extracted sha for $imdbSource: $newSha');
      imdbShaMap[imdbSource] = newSha;
      return true;
    }
    return false;
  }
}
