
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/imdb_cast.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_json_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_more_keywords.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_name_converter.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_title_converter.dart';

class ImdbSearchConverter extends ImdbJsonConverter {

  /// Take a [Map] of IMDB data and create a [MovieResultDTO] from it.
  ImdbConverterBase getConverter(Map<dynamic, dynamic> map) {
    if (getDeepContent(map, outerElementIdentity) != null) {
      // Used by QueryIMDBJson* and QueryIMDBSearch
      return ImdbJsonConverter();
    } else if (getDeepContent(map, outerElementSearchResults) != null) {
      // Used by QueryIMDBMoviesForKeyword.
      return ImdbMoreKeywordsConverter();
    } else if (getDeepContent(map, deepPersonId) != null) {
      // Used by QueryIMDBNameDetails.
      return ImdbNameConverter();
    } else if (getDeepContent(map, deepTitleId2) != null) {
      // Used by QueryIMDBTitleDetails.
      return ImdbTitleConverter();
    } else if (getDeepContent(map, deepEntityHeader) != null) {
      // Used by QueryIMDBCastDetails.
      ImdbCastConverter();
    } 
      return ImdbJsonConverter();
  }
}
