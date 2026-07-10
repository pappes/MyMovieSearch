import 'package:my_movie_search/movies/data/movie_result_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

typedef MovieCollection = Map<String, MovieResultDTO>;
typedef RelatedMovieCategories = Map<String, MovieCollection>;
typedef MovieSources = Map<DataSourceType, String>;

/// Holds a single movie result from any data source
class MovieResultDTO {
  DataSourceType bestSource = .none;
  String uniqueId = movieDTOUninitialized; // ID in current data source
  String title = '';
  String alternateTitle = '';
  String characterName = '';
  String description = '';
  MovieContentType type = .none;
  int year = 0;
  String yearRange = '';
  int creditsOrder = 0; // 100 = star, 0 = extra
  // creditsOrder also stores Stacker and NumberOfSeeders and qtyErrors
  double userRating = 0;
  // userRating also stores qtyCachedResponses
  int userRatingCount = 0;
  // userRatingCount also stores StackerDisk, NumberOfLeechers and qtyRequests
  CensorRatingType censorRating = .none;
  Duration runTime = .zero;
  String imageUrl = '';
  LanguageType language = .none;
  Set<String> languages = {};
  Set<String> genres = {};
  Set<String> keywords = {};
  Map<String, String> links = {};
  MovieSources sources = {};
  // Related DTOs are in a category, then keyed by uniqueId
  RelatedMovieCategories related = {};

  @override
  String toString() => "Instance of 'MovieResultDTO': $uniqueId - $title";

  /// Convert a [MovieResultDTO] to a map tha can be consumed by jsonEncode.
  ///
  Map<String, Object> toJson({bool includeRelated = true}) =>
      toMap(includeRelated: includeRelated);
}

// member variable names
const movieDTOBestSource = 'bestSource';
const movieDTOUniqueId = 'uniqueId';
const movieDTOTitle = 'title';
const movieDTOAlternateTitle = 'alternateTitle';
const movieDTOCharacterName = 'characterName';
const movieDTODescription = 'description';
const movieDTOType = 'type';
const movieDTOYear = 'year';
const movieDTOYearRange = 'yearRange';
const movieDTOcreditsOrder = 'creditsOrder';
const movieDTOUserRating = 'userRating';
const movieDTOUserRatingCount = 'userRatingCount';
const movieDTOCensorRating = 'censorRating';
const movieDTORunTime = 'runTime';
const movieDTOImageUrl = 'imageUrl';
const movieDTOLanguage = 'language';
const movieDTOLanguages = 'languages';
const movieDTOGenres = 'genres';
const movieDTOKeywords = 'keywords';
const movieDTOLinks = 'links';
const movieDTOSources = 'sources';
const movieDTORelated = 'related';
const movieDTOUninitialized = '-1';
const movieDTOMessagePrefix = '-';

/// Helper functions for interpreting [MovieResultDTO] contents.
extension MovieResultDTOHelpers on MovieResultDTO {
  /// Create a MovieResultDTO encapsulating an error.
  ///
  static int _lastError = -1;
  static void resetError() {
    _lastError = -1;
  }

  MovieResultDTO error([
    String errorText = '',
    DataSourceType errorSource = .none,
  ]) {
    type = .error;
    _lastError = _lastError - 1;
    uniqueId = _lastError.toString();
    title = errorText.truncate();
    bestSource = errorSource;
    return this;
  }

  void setReadIndicator(String value) => sources[.fbmmsnavlog] = value;

  String? getReadIndicator() => sources[DataSourceType.fbmmsnavlog];

  /// Loop through all languages in order to see how dominant English is.
  LanguageType getLanguageType() => language = languages.getLanguageType();
}
