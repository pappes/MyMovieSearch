import 'dart:async';
import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';

class WebPageShaExtractorOther extends IMDBShaExtractor {
  WebPageShaExtractorOther.internal(super.imdbShaMap, super.imdbSource)
    : super.internal() ;

  // Functionality unavailable.
  @override
  Future<void> updateSha() async {}
}
