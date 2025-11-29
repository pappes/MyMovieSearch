import 'package:my_movie_search/utilities/web_data/web_json_extractor.dart';

class WebJsonExtractorOther extends WebJsonExtractor {
  WebJsonExtractorOther.internal(
    super.imdbUrl,
    super.jsonCallback,
    super.imdbApi,
  ) : super.internal();

  @override
  Future<void> waitForCompletion() async {
    // Other implementation does not use a web view,
    // so we assume immediate completion.
    return;
  }
}
