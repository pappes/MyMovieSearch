import 'dart:async';

import 'package:my_movie_search/utilities/web_data/imdb_sha_extractor.dart';

class WebPageShaExtractorLinux extends IMDBShaExtractor {
  WebPageShaExtractorLinux.internal(super.imdbShaMap, super.imdbSource)
    : super.internal();

  // TODO: use a a linux capable web view like flutter_linux_webview.
  @override
  Future<void> updateSha() async {  }

}
