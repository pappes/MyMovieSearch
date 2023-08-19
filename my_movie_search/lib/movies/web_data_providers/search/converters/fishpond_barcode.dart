// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/fishpond_barcode.dart';

class FishpondBarcodeSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    return MovieResultDTO().init(
      bestSource: DataSourceType.fishpondBarcode,
      type: MovieContentType.barcode.toString(),
      uniqueId: map[jsonUrlKey]?.toString(),
      alternateTitle: map[jsonRawDescriptionKey]?.toString(),
      title: map[jsonCleanDescriptionKey]?.toString(),
      imageUrl: map[jsonUrlKey]?.toString(),
    );
  }
}