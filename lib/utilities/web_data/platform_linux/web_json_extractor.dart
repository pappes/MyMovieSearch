import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

class WebJsonExtractorLinux extends WebJsonExtractor {
  WebJsonExtractorLinux.internal(
    super.imdbUrl,
    super.jsonCallback,
    super.imdbApi,
  ) : super.internal();

  @override
  Future<void> waitForCompletion() async {
    // Linux implementation does not use a web view,
    // so we assume immediate completion.
    return;
  }
}
