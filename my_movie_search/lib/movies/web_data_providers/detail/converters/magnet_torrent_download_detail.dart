// ignore_for_file: avoid_classes_with_only_static_members

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/magnet_torrent_download_detail.dart';

class TorrentDownloadDetailConverter {
  static List<MovieResultDTO> dtoFromCompleteJsonMap(
    Map map,
    SearchCriteriaDTO criteria,
  ) {
    return [
      MovieResultDTO().init(
        bestSource: DataSourceType.torrentDownloadDetail,
        type: MovieContentType.download.toString(),
        uniqueId: criteria.criteriaTitle,
        description: '${map[jsonDescriptionKey]}',
        imageUrl: map[jsonDetailLink]?.toString(),
        creditsOrder: map[jsonSeedersKey]?.toString(),
        userRatingCount: map[jsonLeechersKey]?.toString(),
      ),
    ];
  }
}
