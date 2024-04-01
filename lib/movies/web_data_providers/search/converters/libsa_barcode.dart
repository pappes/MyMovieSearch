// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/libsa_barcode.dart';

class LibsaBarcodeSearchConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map<dynamic, dynamic> map,
  ) =>
      [
        MovieResultDTO().init(
          bestSource: DataSourceType.libsaBarcode,
          type: MovieContentType.barcode.toString(),
          title: map[jsonCleanDescriptionKey]?.toString(),
          alternateTitle: map[jsonRawDescriptionKey]?.toString(),
          imageUrl: map[jsonUrlKey]?.toString(),
          uniqueId: map[jsonUrlKey]?.toString(),
        ),
      ];
}
