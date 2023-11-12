import 'dart:collection';
import 'dart:convert';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

typedef MovieCollection = Map<String, MovieResultDTO>;
typedef RelatedMovieCategories = Map<String, MovieCollection>;
typedef MovieSources = Map<DataSourceType, String>;

class MovieResultDTO {
  DataSourceType bestSource = DataSourceType.none;
  String uniqueId = movieDTOUninitialized; // ID in current data source
  String title = '';
  String alternateTitle = '';
  String charactorName = '';
  String description = '';
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = '';
  int creditsOrder = 0; // 100 = star, 0 = extra
  double userRating = 0;
  int userRatingCount = 0;
  CensorRatingType censorRating = CensorRatingType.none;
  Duration runTime = Duration.zero;
  String imageUrl = '';
  LanguageType language = LanguageType.none;
  Set<String> languages = {};
  Set<String> genres = {};
  Set<String> keywords = {};
  MovieSources sources = {};
  // Related DTOs are in a category, then keyed by uniqueId
  RelatedMovieCategories related = {};
}

enum MovieContentType {
  none,
  error,
  information,
  keyword,
  barcode,
  person,
  download, //   e.g. magnet from tpb
  navigation, // e.g. next page
  movie, //      includes "tv movie"
  short, //      anything less that an hour long that does not repeat
  series, //     anything less that an hour long that does repeat or repeats more than 4 times
  miniseries, // anything more that an hour long that does repeat
  episode, //    anything that is part of a series or mini-series
  title, //      unknown movie type
  custom,
}

enum CensorRatingType {
  none,
  kids, //      C G
  family, //    PG
  mature, //    M
  adult, //     M15+, R
  restricted, // X, RC
  custom,
}

enum LanguageType {
  none,
  allEnglish,
  mostlyEnglish,
  someEnglish,
  silent,
  foreign,
  custom,
}

// member variable names
const String movieDTOBestSource = 'bestSource';
const String movieDTOUniqueId = 'uniqueId';
const String movieDTOTitle = 'title';
const String movieDTOAlternateTitle = 'alternateTitle';
const String movieDTOCharactorName = 'charactorName';
const String movieDTODescription = 'description';
const String movieDTOType = 'type';
const String movieDTOYear = 'year';
const String movieDTOYearRange = 'yearRange';
const String movieDTOcreditsOrder = 'creditsOrder';
const String movieDTOUserRating = 'userRating';
const String movieDTOUserRatingCount = 'userRatingCount';
const String movieDTOCensorRating = 'censorRating';
const String movieDTORunTime = 'runTime';
const String movieDTOImageUrl = 'imageUrl';
const String movieDTOLanguage = 'language';
const String movieDTOLanguages = 'languages';
const String movieDTOGenres = 'genres';
const String movieDTOKeywords = 'keywords';
const String movieDTOSources = 'sources';
const String movieDTORelated = 'related';
const String movieDTOUninitialized = '-1';
const String movieDTOMessagePrefix = '-';

class RestorableMovie extends RestorableValue<MovieResultDTO> {
  @override
  @factory
  MovieResultDTO createDefaultValue() => MovieResultDTO();

  @override
  void didUpdateValue(MovieResultDTO? oldValue) {
    if (null == oldValue || !oldValue.matches(value)) {
      notifyListeners();
    }
  }

  @override
  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO fromPrimitives(Object? data) => dtoFromPrimitives(data);
  @factory
  MovieResultDTO dtoFromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        return decoded.toMovieResultDTO();
      }
    }
    return MovieResultDTO();
  }

  @override
  Object toPrimitives() => dtoToPrimitives(value);
  Object dtoToPrimitives(MovieResultDTO dto) => jsonEncode(dto.toMap());
}

class RestorableMovieList extends RestorableValue<List<MovieResultDTO>> {
  @override
  List<MovieResultDTO> createDefaultValue() => [];

  @override
  void didUpdateValue(List<MovieResultDTO>? oldValue) {
    if (null == oldValue ||
        oldValue.toPrintableString() != value.toPrintableString()) {
      notifyListeners();
    }
  }

  @override
  @factory
  // ignore: invalid_factory_method_impl
  List<MovieResultDTO> fromPrimitives(Object? data) => dtoFromPrimitives(data);
  @factory
  // ignore: invalid_factory_method_impl
  List<MovieResultDTO> dtoFromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is List) {
        return ListDTOConversion.decodeList(decoded);
      }
    }
    return [];
  }

  @override
  Object toPrimitives() => listToPrimitives(value);
  Object listToPrimitives(List<MovieResultDTO> list) =>
      jsonEncode(list.encodeList());
}

extension ListDTOConversion on Iterable<MovieResultDTO> {
  /// Convert a [List] of json encoded [String]s into a [List] of [MovieResultDTO] objects
  ///
  @factory
  // ignore: invalid_factory_method_impl
  static List<MovieResultDTO> decodeList(Iterable<dynamic> encoded) {
    final result = <MovieResultDTO>[];
    for (final json in encoded) {
      final decoded = jsonDecode(json.toString());
      if (decoded is Map) result.add(decoded.toMovieResultDTO());
    }
    return result;
  }

  /// Convert a [List] of [MovieResultDTO] objects into a [List] of json encoded [String]s
  ///
  List<String> encodeList() {
    final result = <String>[];
    for (final dto in this) {
      result.add(dto.toJson());
    }
    return result;
  }
}

extension MapResultDTOConversion on Map {
  /// Convert a [Map] into a [MovieResultDTO] object
  ///
  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO toMovieResultDTO() {
    final dto = MovieResultDTO();
    dto.uniqueId = dynamicToString(this[movieDTOUniqueId]);
    dto.title = dynamicToString(this[movieDTOTitle]);
    dto.alternateTitle = dynamicToString(this[movieDTOAlternateTitle]);
    dto.charactorName = dynamicToString(this[movieDTOCharactorName]);

    dto.description = dynamicToString(this[movieDTODescription]);
    dto.year = dynamicToInt(this[movieDTOYear]);
    dto.yearRange = dynamicToString(this[movieDTOYearRange]);
    dto.creditsOrder = dynamicToInt(this[movieDTOcreditsOrder]);
    dto.userRating = dynamicToDouble(this[movieDTOUserRating]);
    dto.userRatingCount = dynamicToInt(this[movieDTOUserRatingCount]);
    dto.runTime = Duration(seconds: dynamicToInt(this[movieDTORunTime]));
    dto.imageUrl = dynamicToString(this[movieDTOImageUrl]);

    dto.bestSource = getEnumValue<DataSourceType>(
          this[movieDTOBestSource],
          DataSourceType.values,
        ) ??
        dto.bestSource;
    dto.type = getEnumValue<MovieContentType>(
          this[movieDTOType],
          MovieContentType.values,
        ) ??
        dto.type;
    dto.censorRating = getEnumValue<CensorRatingType>(
          this[movieDTOCensorRating],
          CensorRatingType.values,
        ) ??
        dto.censorRating;
    dto.language = getEnumValue<LanguageType>(
          this[movieDTOLanguage],
          LanguageType.values,
        ) ??
        dto.language;

    dto.sources = stringToSources(this[movieDTOSources]);
    if (!dto.sources.containsKey(dto.bestSource) &&
        !dto.uniqueId.startsWith(movieDTOMessagePrefix)) {
      dto.sources[dto.bestSource] = dto.uniqueId;
    }
    dto.languages = dynamicToStringSet(this[movieDTOLanguages]);
    dto.genres = dynamicToStringSet(this[movieDTOGenres]);
    dto.keywords = dynamicToStringSet(this[movieDTOKeywords]);
    dto.related = stringToRelated(this[movieDTORelated]);
    return dto;
  }

  /// Convert json encoded [Map]<[String], [String]>
  /// to [Map]<[DataSourceType][String]>.
  ///
  /// Discards anything that cannont be converted.
  MovieSources stringToSources(dynamic input) {
    final MovieSources sources = {};
    if (input is Map) {
      for (final sourceEntry in input.entries) {
        final value = sourceEntry.value;
        if (sourceEntry.key is String && value is String) {
          final sourceEnum = getEnumValue<DataSourceType>(
            sourceEntry.key,
            DataSourceType.values,
          );
          if (null != sourceEnum) {
            sources[sourceEnum] = value;
          }
        }
      }
    }
    return sources;
  }

  /// Convert json encoded related movies list to Map.
  ///
  /// Related movie list is a json encoded DTO
  /// Wrapped in a map using uniqueId as key
  /// Which is wrapped in another map using category name as key.
  RelatedMovieCategories stringToRelated(dynamic categories) {
    final RelatedMovieCategories related = {};
    if (categories is Map) {
      // Find the categories that movie are collected under e.g. "director", "writer", etc
      for (final category in categories.entries) {
        if (category.value is Map) {
          final categoryText = category.key.toString();
          final categoryContents = category.value as Map;
          // Build a collection of movies keyed by the unique id.
          final MovieCollection movies = {};
          for (final movie in categoryContents.entries) {
            if (movie.value is Map) {
              final movieId = movie.key.toString();
              // Build DTO based on attributes encoded in the map.
              final Map movieAttributes = movie.value as Map;
              final dto = movieAttributes.toMovieResultDTO();
              movies[movieId] = dto;
            }
          }
          if (movies.isNotEmpty) {
            related[categoryText] = movies;
          }
        }
      }
    }
    return related;
  }
}

class DtoCache {
  DtoCache();
  DtoCache._internal();

  factory DtoCache.singleton() => _singleton;

  static final DtoCache _singleton = DtoCache._internal();

  final _globalDtoCache = TieredCache<MovieResultDTO>();

  /// Retrieve data from the cache.
  ///
  MovieResultDTO fetch(MovieResultDTO newValue) => merge(newValue);

  /// remove [newValue] from the cache.
  ///
  void remove(MovieResultDTO newValue) =>
      _globalDtoCache.remove(_key(newValue));

  /// Store information from [newValue] into a cache and
  /// merge with any existing record.
  ///
  MovieResultDTO merge(MovieResultDTO newValue) {
    final key = _key(newValue);
    if (_globalDtoCache.isCached(key)) {
      return _globalDtoCache.get(key).merge(newValue);
    }
    _globalDtoCache.add(key, newValue);
    return newValue;
  }

  /// Update cache to merge in movies from [newDtos] and
  /// return the same records with updated values.
  ///
  MovieCollection mergeCollection(MovieCollection newDtos) {
    final MovieCollection merged = {};
    for (final dto in newDtos.entries) {
      merged[dto.key] = merge(dto.value);
    }
    return merged;
  }

  static String _key(MovieResultDTO dto) => dto.uniqueId;
}

extension MovieResultDTOHelpers on MovieResultDTO {
  static final _htmlDecode = HtmlUnescape();

  /// Create a MovieResultDTO encapsulating an error.
  ///
  static int _lastError = -1;
  static void resetError() {
    _lastError = -1;
  }

  MovieResultDTO error([
    String errorText = '',
    DataSourceType errorSource = DataSourceType.none,
  ]) {
    type = MovieContentType.error;
    _lastError = _lastError - 1;
    uniqueId = _lastError.toString();
    title = errorText;
    bestSource = errorSource;
    return this;
  }

  MovieResultDTO testDto(String testText) {
    title = testText;
    return this;
  }

  /// Reinitialise the source for a movie.
  ///
  MovieResultDTO setSource({
    Object? newSource,
    String? newUniqueId,
  }) {
    uniqueId = newUniqueId ?? uniqueId;

    if (newSource is DataSourceType) {
      bestSource = newSource;
    }

    sources.clear();
    sources[bestSource] = uniqueId;
    return this;
  }

  void setReadIndicator() {
    sources[DataSourceType.fbmmsnavlog] = uniqueId;
  }

  bool getReadIndicator() => sources.containsKey(DataSourceType.fbmmsnavlog);

  /// Create a MovieResultDTO with supplied data.
  ///
  MovieResultDTO init({
    DataSourceType bestSource = DataSourceType.none,
    String? uniqueId = movieDTOUninitialized,
    String? title = '',
    String? alternateTitle = '',
    String? charactorName = '',
    String? description = '',
    String? type = '',
    String? year = '0',
    String? yearRange = '',
    String? creditsOrder = '0',
    String? userRating = '0',
    String? userRatingCount = '0',
    String? censorRating = '',
    String? runTime = '0',
    String? imageUrl = '',
    String? language = '',
    String? languages = '[]',
    String? genres = '[]',
    String? keywords = '[]',
    String? sources = '{}',
    // Related DTOs are in a category, then keyed by uniqueId
    RelatedMovieCategories? related,
  }) {
    // Strongly type variables, caller must give valid data
    this.bestSource = bestSource;
    this.related = related ?? {};
    // Weakly typed variables, help caller to massage data
    this.uniqueId = uniqueId ?? movieDTOUninitialized;
    this.sources[this.bestSource] = this.uniqueId;
    this.title = title ?? alternateTitle ?? '';
    if (title != alternateTitle) {
      this.alternateTitle = alternateTitle ?? '';
    }
    this.charactorName = charactorName ?? '';
    this.description = description ?? '';
    this.yearRange = yearRange ?? '';
    this.imageUrl = imageUrl ?? '';
    this.year = IntHelper.fromText(year) ?? 0;
    this.creditsOrder = IntHelper.fromText(creditsOrder) ?? 0;
    this.userRatingCount = IntHelper.fromText(userRatingCount) ?? 0;
    this.userRating = DoubleHelper.fromText(userRating) ?? 0;
    this.runTime = Duration(seconds: IntHelper.fromText(runTime) ?? 0);
    this.languages = dynamicToStringSet(languages);
    this.genres = dynamicToStringSet(genres);
    this.keywords = dynamicToStringSet(keywords);
    // Enumerations, work with what we get
    this.type = getEnumValue<MovieContentType>(
          type,
          MovieContentType.values,
        ) ??
        MovieContentType.none;
    this.censorRating = getEnumValue<CensorRatingType>(
          censorRating,
          CensorRatingType.values,
        ) ??
        CensorRatingType.none;
    this.language = getEnumValue<LanguageType>(
          language,
          LanguageType.values,
        ) ??
        getLanguageType(this.languages);

    this.type = bestValue(
      getMovieContentType(
            '$genres $yearRange',
            IntHelper.fromText(runTime),
            this.uniqueId,
          ) ??
          this.type,
      this.type,
    );
    return this;
  }

  /// Convert a json [String] to a [MovieResultDTO].
  ///
  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO fromJson(dynamic json) {
    final decoded = jsonDecode(json.toString());
    if (decoded is Map) return decoded.toMovieResultDTO();
    return MovieResultDTO();
  }

  /// Convert a [MovieResultDTO] to a json [String].
  ///
  String toJson({bool includeRelated = true}) =>
      jsonEncode(toMap(includeRelated: includeRelated));

  /// Convert a [MovieResultDTO] object into a [Map].
  ///
  /// All returned objects are compatible with the [StandardMessageCodec] class.
  /// i.e. only contain string, number, bool, map or list.
  Map<String, Object> toMap({bool includeRelated = true}) {
    final result = <String, Object>{};
    final defaultValues = MovieResultDTO();
    result[movieDTOUniqueId] = uniqueId;
    if (bestSource != defaultValues.bestSource) {
      result[movieDTOBestSource] = bestSource.toString();
    }
    if (title != defaultValues.title) result[movieDTOTitle] = title;
    if (alternateTitle != defaultValues.alternateTitle) {
      result[movieDTOAlternateTitle] = alternateTitle;
    }
    if (charactorName != defaultValues.charactorName) {
      result[movieDTOCharactorName] = charactorName;
    }

    if (type != defaultValues.type) {
      result[movieDTOType] = type.toString();
    }
    if (year != defaultValues.year) {
      result[movieDTOYear] = year.toString();
    }
    if (yearRange != defaultValues.yearRange) {
      result[movieDTOYearRange] = yearRange;
    }
    if (runTime != defaultValues.runTime) {
      result[movieDTORunTime] = runTime.inSeconds.toString();
    }
    if (language != defaultValues.language) {
      result[movieDTOLanguage] = language.toString();
    }
    if (creditsOrder != defaultValues.creditsOrder) {
      result[movieDTOcreditsOrder] = creditsOrder.toString();
    }

    if (languages != defaultValues.languages && languages.isNotEmpty) {
      result[movieDTOLanguages] = json.encode(languages.toList());
    }
    if (genres != defaultValues.genres && genres.isNotEmpty) {
      result[movieDTOGenres] = json.encode(genres.toList());
    }
    if (keywords != defaultValues.keywords && keywords.isNotEmpty) {
      result[movieDTOKeywords] = json.encode(keywords.toList());
    }
    if (description != defaultValues.description) {
      result[movieDTODescription] = description;
    }
    if (userRating != defaultValues.userRating) {
      result[movieDTOUserRating] = userRating.toString();
    }
    if (userRatingCount != defaultValues.userRatingCount) {
      result[movieDTOUserRatingCount] = userRatingCount.toString();
    }
    if (censorRating != defaultValues.censorRating) {
      result[movieDTOCensorRating] = censorRating.toString();
    }
    if (imageUrl != defaultValues.imageUrl) {
      result[movieDTOImageUrl] = imageUrl;
    }

    if (sources.isNotEmpty) {
      final sourcesMap = <String, String>{};
      for (final source in sources.entries) {
        sourcesMap[source.key.toString()] = source.value;
      }
      result[movieDTOSources] = sourcesMap;
    }

    if (includeRelated && related.isNotEmpty) {
      // convert each related dto to a string
      final relatedMap = <String, Object>{};
      for (final category in related.entries) {
        final Map movies = {};
        for (final dto in category.value.entries) {
          final movieMap = dto.value.toMap();
          movies[dto.value.uniqueId] = movieMap;
        }
        relatedMap[category.key] = movies;
      }
      result[movieDTORelated] = relatedMap;
    }
    return result;
  }

  /// Add [relatedDto] into the related movies list of a [MovieResultDTO] in the [key] section.
  ///
  void addRelated(String key, MovieResultDTO relatedDto) {
    if ('' != relatedDto.title) {
      if (!related.containsKey(key)) {
        related[key] = {};
      }
      if (!related[key]!.containsKey(relatedDto.uniqueId)) {
        related[key]![relatedDto.uniqueId] = relatedDto;
      } else {
        related[key]![relatedDto.uniqueId]!.merge(relatedDto);
      }
    }
  }

  /// Combine information from [newValue] into a [MovieResultDTO].
  ///
  MovieResultDTO merge(MovieResultDTO newValue, {bool excludeRelated = false}) {
    if (newValue.userRatingCount >= userRatingCount ||
        0 == userRatingCount ||
        newValue.sources.containsKey(DataSourceType.imdb) ||
        newValue.sources.containsKey(DataSourceType.torrentDownloadDetail)) {
      bestSource = bestValue(bestSource, newValue.bestSource);

      final oldTitle = title;
      if (DataSourceType.imdb == newValue.bestSource && '' != newValue.title) {
        title = _htmlDecode.convert(newValue.title);
      } else {
        title = bestValue(newValue.title, title).reduceWhitespace();
      }
      var newAlternateTitle = '';
      if ('' != newValue.alternateTitle.reduceWhitespace() &&
          title != newValue.alternateTitle.reduceWhitespace()) {
        newAlternateTitle = newValue.alternateTitle;
      } else if ('' != oldTitle.reduceWhitespace() &&
          title != oldTitle.reduceWhitespace()) {
        newAlternateTitle = oldTitle;
      } else if ('' != alternateTitle.reduceWhitespace() &&
          title != alternateTitle.reduceWhitespace()) {
        newAlternateTitle = alternateTitle;
      }

      alternateTitle = newAlternateTitle;
      charactorName = bestValue(newValue.charactorName, charactorName);
      if (newValue.uniqueId == 'tt3127016') {
        newValue.uniqueId = 'tt3127016';
      }
      description = bestValue(newValue.description, description);
      type = bestValue(newValue.type, type);
      year = bestValue(newValue.year, year);
      yearRange = bestValue(newValue.yearRange, yearRange);
      runTime = bestValue(newValue.runTime, runTime);
      type = bestValue(newValue.type, type);
      censorRating = bestValue(newValue.censorRating, censorRating);
      imageUrl = bestValue(newValue.imageUrl, imageUrl);
      genres.addAll(newValue.genres);
      keywords.addAll(newValue.keywords);
      languages.addAll(newValue.languages);
      sources.addAll(newValue.sources);
      creditsOrder = bestValue(newValue.creditsOrder, creditsOrder);
      userRating = bestUserRating(
        newValue.userRating,
        newValue.userRatingCount,
        userRating,
        userRatingCount,
      );
      userRatingCount = bestValue(newValue.userRatingCount, userRatingCount);
      getLanguageType();
      type = bestValue(
        getMovieContentType(
              '$genres $yearRange',
              IntHelper.fromText(runTime),
              uniqueId,
            ) ??
            type,
        type,
      );
    }
    if (!excludeRelated) {
      mergeRelatedDtos(related, newValue.related);
    }
    return this;
  }

  /// Combine related movie information from [existingDtos] into a [MovieResultDTO].
  ///
  static void mergeRelatedDtos(
    RelatedMovieCategories existingDtos,
    RelatedMovieCategories newDtos,
  ) {
    for (final key in newDtos.keys) {
      if (existingDtos.containsKey(key)) {
        _mergeDtoList(existingDtos[key]!, newDtos[key]!);
      } else {
        // Create empty list to pass through to merge function.
        existingDtos[key] = newDtos[key]!;
      }
    }
  }

  /// Update [existingDtos] to also contain movies from [newDtos].
  ///
  static void _mergeDtoList(
    MovieCollection existingDtos,
    MovieCollection newDtos,
  ) {
    for (final dto in newDtos.entries) {
      if (existingDtos.keys.contains(dto.key)) {
        existingDtos[dto.key]!.merge(dto.value, excludeRelated: true);
      } else {
        existingDtos[dto.key] = dto.value;
      }
    }
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  /// [a] and [b] can be numbers, strings, durations, enums
  T bestValue<T>(T a, T b) {
    if (a is MovieContentType && b is MovieContentType) {
      return bestType(a, b) as T;
    }
    if (a is CensorRatingType && b is CensorRatingType) {
      return bestCensorRating(a, b) as T;
    }
    if (a is DataSourceType && b is DataSourceType) {
      return bestBestSource(a, b) as T;
    }
    if (a is LanguageType && b is LanguageType) {
      return bestLanguage(a, b) as T;
    }
    if (a is num && b is num && a < b) {
      return b;
    }
    if (a is Duration && b is Duration && a < b) {
      return b;
    }
    if (a is String && b is String) {
      return bestString(a, b) as T;
    }
    if (a.toString().length < b.toString().length) {
      return b;
    }
    if (lastNumberFromString(a.toString()) <
        lastNumberFromString(b.toString())) {
      return b;
    }
    return a;
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  /// The string with the longest length is the best string
  /// unless it ends in ...
  String bestString(String a, String b) {
    final aStr = _htmlDecode.convert(a);
    final bStr = _htmlDecode.convert(b);

    var longest = aStr;
    var shortest = bStr;
    if (aStr.length < bStr.length) {
      shortest = aStr;
      longest = bStr;
    }

    if (shortest.length > 100 &&
        longest.substring(longest.length - 25).contains('...')) {
      // other string longer but contains an incomplete description!
      return shortest;
    }
    return longest;
  }

  /// Compare [rating1] with [rating2] and return the most relevant value.
  ///
  /// The rating with the highest count is the best rating.
  double bestUserRating(
    double rating1,
    num count1,
    double rating2,
    num count2,
  ) {
    if (count1 > count2) return rating1;
    return rating2;
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  MovieContentType bestType(MovieContentType a, MovieContentType b) {
    if (b.index > a.index) return b;
    return a;
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  CensorRatingType bestCensorRating(CensorRatingType a, CensorRatingType b) {
    if (b.index > a.index) return b;
    return a;
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  DataSourceType bestBestSource(DataSourceType a, DataSourceType b) {
    if (b == DataSourceType.imdb) return b;
    return a;
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  LanguageType bestLanguage(LanguageType a, LanguageType b) {
    if (b.index > a.index) return b;
    return a;
  }

  /// Create a string representation of a [MovieResultDTO].
  ///
  String toPrintableString() => toMap().toString();

  /// Create a placeholder for a value that can not be easily represented
  /// as a [MovieResultDTO].
  ///
  MovieResultDTO toUnknown() {
    final dto = MovieResultDTO();
    dto.bestSource = bestSource;
    dto.uniqueId = uniqueId;
    dto.title = 'unknown';
    dto.alternateTitle = alternateTitle;
    dto.charactorName = charactorName;

    dto.description = description;
    dto.type = type;
    dto.year = year;
    dto.yearRange = yearRange;
    dto.creditsOrder = creditsOrder;
    dto.userRating = userRating;
    dto.userRatingCount = userRatingCount;
    dto.censorRating = censorRating;
    dto.runTime = runTime;
    dto.imageUrl = imageUrl;
    dto.language = language;
    dto.languages = languages;
    dto.genres = genres;
    dto.keywords = keywords;
    dto.sources = sources;
    dto.related = related;
    return dto;
  }

  /// Look at information provided to see if [MovieContentType] can be determined.
  ///
  /// info is in the form  ' (1988–1993) (TV Series)'
  static MovieContentType? _lookupMovieContentType(
    String info,
    int? seconds,
    String id,
  ) {
    if (id.startsWith(imdbPersonPrefix)) return MovieContentType.person;
    if (id == "-1") return MovieContentType.none;
    if (id.startsWith(movieDTOMessagePrefix)) return MovieContentType.error;
    final String title = info.toLowerCase();
    if (title.lastIndexOf('game') > -1) return MovieContentType.custom;
    if (title.lastIndexOf('creativework') > -1) return MovieContentType.custom;
    if (title.lastIndexOf('music') > -1) return MovieContentType.custom;
    if (seconds != null && seconds < (30 * 60) && seconds > 0) {
      return MovieContentType.short;
    }
    // mini includes TV Mini-series
    if (title.lastIndexOf('mini') > -1) return MovieContentType.miniseries;
    if (title.lastIndexOf('episode') > -1) return MovieContentType.episode;
    if (title.lastIndexOf('series') > -1) return MovieContentType.series;
    if (title.lastIndexOf('-') > -1) return MovieContentType.series;
    if (title.lastIndexOf('–') > -1) return MovieContentType.series;
    if (title.lastIndexOf('special') > -1) return MovieContentType.series;
    if (title.lastIndexOf('short') > -1) return MovieContentType.short;
    if (seconds != null && seconds < (60 * 60) && seconds > 0) {
      return MovieContentType.episode;
    }
    if (title.lastIndexOf('movie') > -1) return MovieContentType.movie;
    if (title.lastIndexOf('video') > -1) return MovieContentType.movie;
    if (title.lastIndexOf('feature') > -1) return MovieContentType.movie;
    if (id.startsWith(imdbTitlePrefix)) return MovieContentType.title;
    return null;
  }

  /// update title type based on information in the dto.
  MovieContentType getContentType() => type = getMovieContentType(
        yearRange,
        runTime.inSeconds,
        uniqueId,
      ) ??
      type;

  /// Use movie type string to lookup [MovieContentType] movie type.
  static MovieContentType? getMovieContentType(
    Object? info,
    int? seconds,
    String id,
  ) {
    final string = info?.toString() ?? '';
    final type = _lookupMovieContentType(string, seconds, id);
    if (null != type || null == info) return type;
    return null;
  }

  /// Compare 2 fields and describe the difference
  void _matchCompare<T>(
    Map<String, String> mismatches,
    String fieldName,
    T actual,
    T expected, {
    bool fuzzy = false,
  }) {
    if (fuzzy && (actual is int || actual is double)) {
      _matchFuzzyCompare(mismatches, fieldName, actual, expected);
    } else {
      if (expected != actual) {
        mismatches[fieldName] =
            'is different\n  Expected: "$expected"\n    Actual: "$actual"\n';
      }
    }
  }

  /// Compare 2 fields and describe the difference
  void _matchFuzzyCompare<T>(
    Map<String, String> mismatches,
    String fieldName,
    T actual,
    T expected,
  ) {
    if (expected != actual) {
      if (!DoubleHelper.fuzzyMatch(actual, expected, tolerance: 80)) {
        mismatches[fieldName] = 'is different\n'
            '  Expected approx: "$expected"\n'
            '           Actual: "$actual"\n';
      }
    }
  }

  /// Compare 2 identifiers and describe the difference
  ///
  /// Allow error identifiers to be different
  void _matchCompareId(
    Map<String, String> mismatches,
    String fieldName,
    String actual,
    String expected,
  ) {
    if (!expected.startsWith(movieDTOMessagePrefix) ||
        !actual.startsWith(movieDTOMessagePrefix)) {
      _matchCompare(mismatches, fieldName, actual, expected);
    }
  }

  /// Compare 2 movie source collections and describe the difference
  ///
  /// Allow error identifiers to be different
  void _matchCompareIdMap(
    Map<String, String> mismatches,
    String fieldName,
    MovieSources actual,
    MovieSources expected,
  ) {
    if (expected.length != actual.length) {
      _matchCompare(mismatches, '$fieldName length', actual, expected);
      return;
    }
    final actualSorted = SplayTreeMap<DataSourceType, String>.from(
      actual,
      Enum.compareByIndex,
    );
    final expectedSorted = SplayTreeMap<DataSourceType, String>.from(
      expected,
      Enum.compareByIndex,
    );
    for (var index = 0; index < expected.length; index++) {
      // Compare source name
      _matchCompare(
        mismatches,
        fieldName,
        actualSorted.keys.elementAt(index),
        expectedSorted.keys.elementAt(index),
      );
      // Compare source identifier
      _matchCompareId(
        mismatches,
        fieldName,
        actualSorted.values.elementAt(index),
        expectedSorted.values.elementAt(index),
      );
    }
  }

  /// Test framework matcher to compare current [MovieResultDTO] to [actualDTO]
  ///
  /// Explains any difference found.
  /// [matchState] allows information about mismatches to be passed back
  /// [related] allows exclusion of the related dto collection for comparison
  /// [fuzzy] allows volitile numeric data to have a 75% variation
  bool matches(
    MovieResultDTO actualDTO, {
    Map? matchState,
    bool related = true,
    bool fuzzy = false,
    String prefix = '',
  }) {
    if (title == actualDTO.title && title == 'unknown') return true;

    final mismatches = <String, String>{};
    void matchCompare<T>(String fieldName, T actual, T expected) =>
        _matchCompare(
          mismatches,
          '$prefix$fieldName',
          actual,
          expected,
          fuzzy: fuzzy,
        );

    void matchCompareId(String fieldName, String actual, String expected) =>
        _matchCompareId(mismatches, '$prefix$fieldName', actual, expected);

    void matchCompareIdMap(
      String fieldName,
      MovieSources actual,
      MovieSources expected,
    ) =>
        _matchCompareIdMap(mismatches, '$prefix$fieldName', actual, expected);

    matchCompare('bestSource', actualDTO.bestSource, bestSource);
    matchCompareId('uniqueId', actualDTO.uniqueId, uniqueId);
    if (MovieContentType.error != type && sources.isNotEmpty) {
      matchCompareIdMap('sources', actualDTO.sources, sources);
    }
    matchCompare('title', actualDTO.title, title);
    matchCompare('alternateTitle', actualDTO.alternateTitle, alternateTitle);
    matchCompare('charactorName', actualDTO.charactorName, charactorName);
    matchCompare('description', actualDTO.description, description);
    matchCompare('type', actualDTO.type, type);
    matchCompare('year', actualDTO.year, year);
    matchCompare('creditsOrder', actualDTO.creditsOrder, creditsOrder);
    matchCompare('yearRange', actualDTO.yearRange, yearRange);
    matchCompare('userRating', actualDTO.userRating, userRating);
    matchCompare('censorRating', actualDTO.censorRating, censorRating);
    matchCompare('runTime', actualDTO.runTime, runTime);
    matchCompare('imageUrl', actualDTO.imageUrl, imageUrl);
    matchCompare('language', actualDTO.language, language);
    matchCompare(
      'languages',
      languages.toString(),
      actualDTO.languages.toString(),
    );
    matchCompare('genres', actualDTO.genres.toString(), genres.toString());
    matchCompare(
      'keywords',
      actualDTO.keywords.toString(),
      keywords.toString(),
    );

    if (related) {
      final expected = this.related.toPrintableString();
      final actual = actualDTO.related.toPrintableString();
      if (expected != actual) matchCompare('related', actual, expected);
    }

    if (mismatches.isNotEmpty) {
      if (null != matchState) matchState['differences'] = mismatches;
      return false;
    }
    return true;
  }

  /// Loop through all languages in order to see how dominant English is.
  LanguageType getLanguageType([Iterable? languageList]) {
    for (final languageVal in languageList ?? languages) {
      final languageText = languageVal.toString();
      if (languageText.isNotEmpty) {
        if (!languages.contains(languageText)) {
          languages.add(languageText);
        }
        if (languageText.toUpperCase().startsWith('EN')) {
          if (LanguageType.none == language ||
              LanguageType.allEnglish == language) {
            // First item(s) found are English, assume all English until other languages found.
            language = LanguageType.allEnglish;
            continue;
          } else {
            // English is not the first language listed.
            return language = LanguageType.someEnglish;
          }
        }
        if (LanguageType.allEnglish == language) {
          // English was the first language listed but found another language.
          return language = LanguageType.mostlyEnglish;
        } else {
          // First item found is foreign, assume all foreign until other languages found.
          language = LanguageType.foreign;
          continue;
        }
      }
    }
    return language;
  }

  /// Remove data that should only be held transiently.
  ///
  /// Some data can be help in memory but should not be saved to source code.
  /// Other data is not owned by the source and can be considered public domain.
  void clearCopyrightedData() {
    description = '';
    imageUrl = '';
    userRating = 0;
    userRatingCount = 0;
    creditsOrder = 0;
    languages.clear();
    genres.clear();
    keywords.clear();
    for (final category in related.keys) {
      for (final dto in related[category]!.values) {
        dto.clearCopyrightedData();
      }
    }
  }

  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO clone() => toMap().toMovieResultDTO();
}

extension IterableMovieResultDTOHelpers on Iterable<MovieResultDTO> {
  /// Create a string representation of a [List]<[MovieResultDTO]>.
  ///
  String toPrintableString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final entry in this) {
      listContents.write('$separator${entry.toPrintableString()}');
      separator = ',\n';
    }
    return 'List<MovieResultDTO>($length)[\n$listContents\n]';
  }

  /// return a string containing valid json
  String toJsonString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final entry in this) {
      listContents.write('$separator${entry.toJson()}');
      separator = ',\n';
    }
    return "List<MovieResultDTO>($length)\nr'''\n[\n$listContents\n]\n'''";
  }

  /// Return a list of strings containing valid json
  ///
  /// used for constructing test data
  String toListOfDartJsonStrings({bool includeRelated = true}) {
    final listContents = StringBuffer();
    for (final entry in this) {
      final json = entry.toJson(includeRelated: includeRelated);
      final dartString = "r'''\n${json.replaceAll("'", "'")}\n''',\n";
      listContents.write(formatDtoJson(dartString));
    }
    return "[\n$listContents]";
  }

  /// Format JSON for readability
  String formatDtoJson(String json) {
    var formatted = json;
    formatted = formatted.replaceAll(
      '"related":{"',
      '\n  "related":{"',
    );
    formatted = formatted.replaceAll(
      '"languages":"[\\"',
      '\n      "languages":"[\\"',
    );
    formatted = formatted.replaceAll(
      '"genres":"[\\"',
      '\n      "genres":"[\\"',
    );
    formatted = formatted.replaceAll(
      '"keywords":"[\\"',
      '\n      "keywords":"[\\"',
    );
    formatted = formatted.replaceAll(
      '"description":"',
      '\n      "description":"',
    );
    formatted = formatted.replaceAll(
      '"userRating":"',
      '\n      "userRating":"',
    );
    formatted = formatted.replaceAll(
      '}},"',
      '}},\n      "',
    );
    formatted = formatted.replaceAll(
      '}}},\n  ',
      '}}},\n',
    );
    return formatted;
  }

  /// Create a json encoded representation of a [List]<[MovieResultDTO]>.
  ///
  String toJson() {
    final listContents = <String>[];
    for (final key in this) {
      listContents.add(jsonEncode(key.toMap()));
    }
    return jsonEncode(listContents);
  }

  void clearCopyrightedData() {
    for (final entry in this) {
      entry.clearCopyrightedData();
    }
  }
}

extension StringMovieResultDTOHelpers on String {
  /// Decode a json encoded representation of a [List]<[MovieResultDTO]>.
  ///
  List<MovieResultDTO> jsonToList() {
    final dtos = <MovieResultDTO>[];
    final listContents = jsonDecode(this);
    if (listContents is List) {
      for (final json in listContents) {
        final decoded = jsonDecode(json.toString());
        if (decoded is Map) {
          dtos.add(decoded.toMovieResultDTO());
        }
      }
    }
    return dtos;
  }
}

extension MapMovieResultDTOHelpers on Map<dynamic, MovieResultDTO> {
  /// Create a string representation of a [Map]<[String],[MovieResultDTO]>.
  ///
  String toPrintableString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final key in keys) {
      listContents.write('$separator${this[key]!.toPrintableString()}');
      separator = ',\n';
    }
    return 'List<MovieResultDTO>($length)[\n$listContents\n]';
  }

  /// Create a short string representation of a [Map]<[dynamic],[MovieResultDTO]>.
  ///
  /// Output will be less than 1000 chars long, truncating if required.
  String toShortString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final key in keys) {
      listContents.write('$separator${this[key]!.title}');
      separator = ',\n';
    }
    if (listContents.length > 1000) {
      final truncated = listContents.toString().substring(0, 500);
      return '$truncated...';
    }
    return listContents.toString();
  }
}

extension MapMapMovieResultDTOHelpers
    on Map<dynamic, Map<dynamic, MovieResultDTO>> {
  /// Create a string representation of a Map<[dynamic], Map<[dynamic], [MovieResultDTO]>>>.
  ///
  String toPrintableString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final key in keys) {
      listContents.write(
        '$separator$key:${this[key]!.toPrintableString()}',
      );
      separator = ',\n';
    }
    return '{$listContents}';
  }

  /// Create a short string representation of a Map<[dynamic], Map<[dynamic], [MovieResultDTO]>>>.
  ///
  String toShortString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final key in keys) {
      listContents.write(
        '$separator$key:${this[key]!.toShortString()}',
      );
      separator = ',\n';
    }
    return '$listContents';
  }
}

extension DTOCompare on MovieResultDTO {
  /// Rank movies against each other for sorting.
  ///
  int compareTo(MovieResultDTO other) {
    // Preference people > movies > information.
    if (contentCategory() != other.contentCategory()) {
      return contentCategory().compareTo(other.contentCategory());
    }
    switch (type) {
      case MovieContentType.person:
        return personCompare(other);
      case MovieContentType.download:
        return downloadCompare(other);
      case MovieContentType.barcode:
        return barcodeCompare(other);
      default:
        return movieCompare(other);
    }
  }

  /// Compare people based returned order and populatrity.
  int personCompare(MovieResultDTO other) {
    if (creditsOrder != other.creditsOrder ||
        userRatingCount != other.userRatingCount) {
      return personPopularityCompare(other);
    }
    return title.compareTo(other.title) * -1;
  }

  /// Compare downloads based availability.
  int downloadCompare(MovieResultDTO other) {
    if (creditsOrder != other.creditsOrder) {
      // Compare seeders
      return creditsOrder.compareTo(other.creditsOrder);
    }
    // Compare Leachers
    return userRatingCount.compareTo(other.userRatingCount);
  }

  /// Compare downloads based availability.
  int barcodeCompare(MovieResultDTO other) {
    final hasYear = alternateTitle.contains(RegExp(r'.*\s\d\d\d\d\s.*'));
    final otherHasYear =
        other.alternateTitle.contains(RegExp(r'.*\s\d\d\d\d\s.*'));

    // Deprioritise Ebay results
    if (isEbay(bestSource) && !isEbay(other.bestSource)) {
      return -1;
    }
    if (isEbay(other.bestSource) && !isEbay(bestSource)) {
      return 1;
    }

    // Prefer whichever has a year
    if (hasYear && !otherHasYear) {
      return 1;
    }
    if (otherHasYear && !hasYear) {
      return -1;
    }
    // Compare normal movie fields
    return movieCompare(other);
  }

  /// Compare movies based on popularity, type, language, year, etc.
  int movieCompare(MovieResultDTO other) {
    // See how many people have rated this movie.
    if (userRatingCategory() != other.userRatingCategory()) {
      return userRatingCategory().compareTo(other.userRatingCategory());
    }
    // See how many people have rated this movie.
    if (viewedCategory() != other.viewedCategory()) {
      return viewedCategory().compareTo(other.viewedCategory());
    }
    // Preference movies > series > short film > episodes.
    if (titleContentCategory() != other.titleContentCategory()) {
      return titleContentCategory().compareTo(other.titleContentCategory());
    }
    // Preference English > Foreign Language.
    if (language.index != other.language.index) {
      return languageCategory().compareTo(other.languageCategory());
    }
    // Rank older (less than 2000) and low rated movies lower.
    if (popularityCategory() != other.popularityCategory()) {
      return popularityCategory().compareTo(other.popularityCategory());
    }
    // If all things are equal, sort by year.
    return yearCompare(other);
  }

  /// Rank movies based on popularity.
  ///
  /// 0-99, 100-9999, 10000+
  int userRatingCategory() {
    if (userRatingCount == 0) return 0;
    if (userRatingCount < 100) return 1;
    if (userRatingCount < 10000) return 2;
    return 3;
  }

  /// Rank movies based not recently viewed.
  ///
  int viewedCategory() {
    return getReadIndicator() ? 0 : 1;
  }

  /// Rank movies based on type of content.
  ///
  /// movie > miniseries > tv series > short > series episode > game & unknown
  int titleContentCategory() {
    if (type == MovieContentType.none ||
        type == MovieContentType.custom ||
        type == MovieContentType.error) {
      return 0;
    }
    if (type == MovieContentType.episode) return 1;
    if (type == MovieContentType.short) return 2;
    if (type == MovieContentType.series) return 3;
    if (type == MovieContentType.miniseries) return 4;
    return 5;
  }

  /// Rank dto based on type (person Vs movie).
  ///
  /// person > movie
  int contentCategory() {
    switch (type) {
      case MovieContentType.person:
        return 99;
      case MovieContentType.episode:
        return 7;
      case MovieContentType.short:
        return 6;
      case MovieContentType.custom:
        return 5;
      case MovieContentType.keyword:
        return 4;
      case MovieContentType.download:
        return 3;
      case MovieContentType.error:
        return 2;
      case MovieContentType.information:
        return 1;
      case MovieContentType.navigation:
        return 0;
      default:
        return 90;
    }
  }

  /// Rank movies based on spoken language.
  ///
  /// English > mostly English > some English > no English > silent
  int languageCategory() {
    // Need to reverse the enum order for use with CompareTo().
    return language.index * -1;
  }

  /// Rank movies based on popular opinion.
  ///
  /// Any movie with a super low rating is probably not worth watching.
  /// A rating of 2 out of 5 is not great but better than nothing.
  /// Movies and series made before 2000 have a lower relevancy to today.
  int popularityCategory() {
    if (userRating < 2) return 0;
    if (maxYear() < 2000) return 1;
    return 2;
  }

  /// Rank movies based on year released.
  ///
  /// For series use year of most recent episode.
  int yearCompare(MovieResultDTO? other) {
    final thisYear = maxYear();
    final otherYear = other?.maxYear() ?? 0;
    return thisYear.compareTo(otherYear);
  }

  /// Rank movies based on raw popularity.
  ///
  int personPopularityCompare(MovieResultDTO other) {
    if (creditsOrder > 1 || other.creditsOrder > 1) {
      return creditsOrder.compareTo(other.creditsOrder);
    }
    return userRatingCount.compareTo(other.userRatingCount);
  }

  /// Extract year release or year of most recent episode.
  ///
  int maxYear() => max(year, yearRangeAsNumber());

  /// Extract year of most recent episode.
  ///
  int yearRangeAsNumber() => lastNumberFromString(yearRange);

  /// Extract numeric digits from end of string.
  ///
  /// String can optionally end with a dash.
  int lastNumberFromString(String str) {
    // one or more numeric digits ([0-9]+)
    // followed by 0 or more dashes ([\-]*)
    final match = RegExp(r'([0-9]+)([\-]*)$').firstMatch(str);
    if (null != match) {
      if (null != match.group(1)) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return 0;
  }
}
