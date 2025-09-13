import 'dart:async';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';

class WebPageShaExtractorPlatform extends IMDBShaExtractor {
  WebPageShaExtractorPlatform.internal(super.imdbShaMap, super.imdbSource)
    : super.internal() {
    print("***************************initialized for Other***************");
  }

  // Functionality unavailable.
  @override
  Future<void> updateSha() async {}
}
