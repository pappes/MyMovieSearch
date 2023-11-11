// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/picclick_barcode.dart';

class PicclickBarcodeSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(Map map) => [
        MovieResultDTO().init(
          bestSource: DataSourceType.picclickBarcode,
          type: MovieContentType.barcode.toString(),
          uniqueId: map[jsonIdKey]?.toString(),
          alternateTitle: map[jsonRawDescriptionKey]?.toString(),
          title: map[jsonCleanDescriptionKey]?.toString(),
          description: map[jsonIdKey]?.toString(),
          imageUrl: map[jsonUrlKey]?.toString(),
        )
      ];
}
