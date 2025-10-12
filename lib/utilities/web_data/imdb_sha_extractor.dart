import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:logger/logger.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_json.dart';
import 'package:my_movie_search/utilities/web_data/platform_android/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_linux/imdb_sha_extractor.dart';
import 'package:my_movie_search/utilities/web_data/platform_other/imdb_sha_extractor.dart';

const imdbAddressBase = 'https://www.imdb.com/name/';
const imdbCritera = {
  ImdbJsonSource.actor: 'nm0000078',
  ImdbJsonSource.actress: 'nm0000149',
  ImdbJsonSource.director: 'nm0000033',
  ImdbJsonSource.producer: 'nm0000229',
  ImdbJsonSource.writer: 'nm0000697',
  ImdbJsonSource.credits: 'nm0000078',
};

/// Defines the three possible outcomes of an interception request,
enum InterceptionAction { delegateRequest, syntheticResponse, executeRequest }

/// Represents the decision made by the orchestration layer using standard types.
class InterceptionDecision {
  InterceptionDecision.delegateRequest()
    : action = InterceptionAction.delegateRequest,
      statusCode = null,
      contentType = null,
      body = null;

  InterceptionDecision.executeRequest()
    : action = InterceptionAction.executeRequest,
      statusCode = null,
      contentType = null,
      body = null;

  InterceptionDecision.syntheticResponse({
    required this.statusCode,
    required this.contentType,
    required this.body,
  }) : action = InterceptionAction.syntheticResponse;
  final InterceptionAction action;
  final int? statusCode;
  final String? contentType;
  final Uint8List? body;
}

/// Extract the sha from a web page
/// using a platform specific implementation to drive a web browser.
abstract class IMDBShaExtractor {
  /// Constructor to create a new instance
  /// of the appropriate platform specific implementation.
  factory IMDBShaExtractor(
    Map<ImdbJsonSource, String> imdbShaMap,
    Map<ImdbJsonSource, String> imdbUrlMap,
    ImdbJsonSource imdbSource,
  ) {
    // TODO: Use environemnt variable to drive platform specific implementation
    // so that the compiler can tree shake unused code.
    if (Platform.isAndroid) {
      return WebPageShaExtractorAndroid.internal(
        imdbShaMap,
        imdbUrlMap,
        imdbSource,
      );
    }
    if (Platform.isLinux) {
      return WebPageShaExtractorLinux.internal(
        imdbShaMap,
        imdbUrlMap,
        imdbSource,
      );
    }

    return WebPageShaExtractorOther.internal(
      imdbShaMap,
      imdbUrlMap,
      imdbSource,
    );
  }

  /// Internal constructor to setup internal state for the instance.
  IMDBShaExtractor.internal(this.imdbShaMap, this.imdbUrlMap, this.imdbSource);

  /// Updatable map of IMDB sources to their corresponding sha values.
  Map<ImdbJsonSource, String> imdbShaMap;

  /// Updatable map of IMDB sources to their corresponding url values.
  Map<ImdbJsonSource, String> imdbUrlMap;

  /// The IMDB source to extract the sha for.
  ImdbJsonSource imdbSource;

  /// Fetch the updated sha from IMDB.
  Future<void> updateSha();

  /// Extract the sha from the given [url] text.
  String? extractShaFromWebText(String url) {
    const filmographyIndicator = 'Filmography';
    const shaPrefix = '%22sha256Hash%22%3A%22';

    if (url.contains(filmographyIndicator) &&
        url.contains(shaPrefix) &&
        url.contains(imdbCritera[imdbSource]!)) {
      imdbUrlMap[imdbSource] = url.replaceAll(
        imdbCritera[imdbSource]!,
        urlPlaceholder,
      );
    }
    //const shaName = 'NameMainFilmographyPaginatedCredits';
    const shaName = filmographyIndicator;
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
  Uri? getImdbAddress() =>
      Uri.parse(imdbAddressBase + imdbCritera[imdbSource]!);

  // Expand all credits for the role.
  String getClickOnCostumeDepartment() =>
      getClickOnButton('Costume Department');

  // Expand all credits for the role.
  String getClickOnSeeAll() => getClickOnButton('See all');

  // Get the CSS selector for the page element to click on.
  String getClickOnButton(String text) => '''
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

  InterceptionDecision getInterceptionDecision(String url, String? method) {
    if (discardImageRequests(url)) {
      // Decision: Block the request with a synthetic 404.
      return InterceptionDecision.syntheticResponse(
        statusCode: 404,
        contentType: 'text/plain',
        body: Uint8List(0),
      );
    }

    if (shouldPassthroughRequest(url, method)) {
      // Decision: Let the WebView handle it.
      return InterceptionDecision.delegateRequest();
    }

    // Decision: Proxy the request over Dart network.
    return InterceptionDecision.executeRequest();
  }

  /// Determines if a request should be executed by the WebView without Dart interception.
  /// Returns `true` to skip interception (return null from _handleIntercept).
  bool shouldPassthroughRequest(String url, String? method) {
    // Pass through scripts, styles, and fonts
    const passedExtensions = ['.js', '.css', '.woff2'];

    if (passedExtensions.any((ext) => url.endsWith(ext))) {
      return true;
    }
    // Pass through non-API URLs
    if (!url.contains('/api/')) {
      return true;
    }
    // Pass through non-GET requests
    if (method != 'GET') {
      return true;
    }

    return false; // Intercept all other requests.
  }

  /// Determines if a request targets a static image and should be blocked.
  bool discardImageRequests(String url) {
    const blockedExtensions = ['.png', '.gif', '.jpg', '.jpeg'];
    return blockedExtensions.any((ext) => url.endsWith(ext));
  }
}
