// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/picclick_barcode.dart';

class PicclickBarcodeSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) {
    return [dtoFromMap(map)];
  }

  static MovieResultDTO dtoFromMap(Map map) {
    return MovieResultDTO().init(
      bestSource: DataSourceType.picclickBarcode,
      type: MovieContentType.barcode.toString(),
      uniqueId: map[jsonIdKey]?.toString(),
      title: map[jsonDescriptionKey]?.toString(),
      description: map[jsonIdKey]?.toString(),
      imageUrl: map[jsonUrlKey]?.toString(),
    );
  }
}
