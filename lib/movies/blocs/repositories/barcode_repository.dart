import 'package:my_movie_search/movies/blocs/repositories/repository_types/base_movie_repository.dart';
import 'package:my_movie_search/movies/data/search_criteria_mappers.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/libsa_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/picclick_barcode.dart';
import 'package:my_movie_search/movies/web_data_providers/search/uhtt_barcode.dart';

/// Search for barcode for a DVD.
class BarcodeRepository extends BaseMovieRepository {
  @override
  WebFetchDTOLimitedFetch getProviders() => {
    QueryLibsaBarcodeSearch(criteria): 1000,
    QueryFishpondBarcodeSearch(criteria): 1000,
    QueryUhttBarcodeSearch(criteria): 1000,
    QueryPicclickBarcodeSearch(criteria): 1000,
  };
}
