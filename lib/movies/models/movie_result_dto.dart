import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/barcode_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/persistence/tiered_cache.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

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
  // creditsOrder also stores Stacker and number ofSeeders
  double userRating = 0;
  int userRatingCount = 0;
  // userRatingCount also stores Stacker Disk and number of Leechers
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

  /// Convert a [MovieResultDTO] to a map tha can be consumed by jsonEncode.
  ///
  Map<String, dynamic> toJson({bool includeRelated = true}) =>
      // ignore: unnecessary_this
      this.toMap(includeRelated: includeRelated);
}

enum MovieContentType {
  none,
  error,
  information,
  keyword,
  barcode,
  searchprompt, // freetext dto to be used in a search criteria
  person,
  title, //      unknown movie type
  download, //   e.g. magnet from tpb
  navigation, // e.g. next page
  movie, //      includes "tv movie"
  short, //      anything less that an hour long that does not repeat
  series, //     a short that repeats or movie repeats more than 4 times
  miniseries, // anything more that an hour long that does repeat
  episode, //    anything that is part of a series or mini-series
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
  RestorableMovie([MovieResultDTO? def]) {
    if (def != null) defaultVal = def;
  }

  static int nextId = 0;
  MovieResultDTO defaultVal = MovieResultDTO();

  @override
  MovieResultDTO createDefaultValue() => defaultVal;

  @override
  void didUpdateValue(MovieResultDTO? oldValue) {
    if (null == oldValue || oldValue.uniqueId != value.uniqueId) {
      notifyListeners();
    }
  }

  static Map<String, dynamic> _getMap(GoRouterState state) {
    final criteria = state.extra;
    if (criteria != null && criteria is Map<String, dynamic>) return criteria;
    return {};
  }

  static Map<String, dynamic> routeState(MovieResultDTO dto) {
    unawaited(DtoCache.singleton().merge(dto));
    return {'id': nextId++, 'dtoId': dto.uniqueId};
  }

  static MovieResultDTO getDto(GoRouterState state) {
    final input = _getMap(state);
    if (input.containsKey('dtoId')) {
      final criteria = input['dtoId'];
      if (criteria != null && criteria is String) {
        return DtoCache.singleton().fetchSynchronously(criteria) ??
            MovieResultDTO().init(uniqueId: criteria);
      }
      return dtoFromPrimitives(criteria);
    }
    return MovieResultDTO();
  }

  /// Get a unique identifier for this data.
  ///
  /// Will generate a unique if if none supplied.
  /// Will update the next id if it is out of sync.
  static String getRestorationId(GoRouterState state) {
    final input = _getMap(state);
    if (input.containsKey('id')) {
      final dtoRestorationId = input['id'];
      if (dtoRestorationId != null && dtoRestorationId is int) {
        if (dtoRestorationId > nextId) nextId = dtoRestorationId + 1;
        return 'RestorableMovie$dtoRestorationId';
      }
    }
    return 'RestorableMovie${nextId++}';
  }

  @override
  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO fromPrimitives(Object? data) => dtoFromPrimitives(data);
  @factory
  static MovieResultDTO dtoFromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        // Restore nextId if it is out of sync.
        if (decoded.containsKey('nextId')) {
          final storedId = IntHelper.fromText(decoded['nextId']) ?? nextId;
          if (storedId > nextId) {
            nextId = storedId + 1;
          }
        }
        if (decoded.containsKey('dto')) {
          return MovieResultDTO().init(uniqueId: decoded['dto']?.toString());
        }
      }
    }
    return MovieResultDTO();
  }

  @override
  // Need 2 functions because access to [value] is not initialised for testing!
  Object toPrimitives() => RestorableMovie.dtoToPrimitives(value);
  static Object dtoToPrimitives(MovieResultDTO dto) {
    final map = {
      'dto': dto.uniqueId,
      'nextId': '${nextId + 1}',
    };
    final json = jsonEncode(map);
    printSizeAndReturn(json);
    return json;
  }
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
  List<MovieResultDTO> fromPrimitives(Object? data) {
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is List) {
        return ListDTOConversion.decodeList(decoded);
      }
    }
    return createDefaultValue();
  }

  @override
  // Need 2 functions because access to [value] is not initialised for testing!
  Object toPrimitives() => listToPrimitives(value);
  Object listToPrimitives(List<MovieResultDTO> list) =>
      printSizeAndReturn(jsonEncode(list.encodeList()));
}

String printSizeAndReturn(String str) {
  final len = str.length;
  print('Restorable size = $len, content = ${str.substring(0, min(50, len))}');
  return str;
}

extension ListDTOConversion on Iterable<MovieResultDTO> {
  /// Convert a [List] of json encoded [String]s
  /// into a [List] of [MovieResultDTO] objects
  ///
  @factory
  // ignore: invalid_factory_method_impl
  static List<MovieResultDTO> decodeList(Iterable<dynamic> encoded) {
    final result = <MovieResultDTO>[];
    for (final json in encoded) {
      if (json is Map) {
        result.add(json.toMovieResultDTO());
      } else {
        final decoded = jsonDecode(json.toString());
        if (decoded is Map) {
          result.add(decoded.toMovieResultDTO());
        } else {
          result.add(MovieResultDTO().init(uniqueId: decoded.toString()));
        }
      }
    }
    return result;
  }

  /// Convert a [List] of [MovieResultDTO] objects
  /// into a [List] of json encoded [String]s
  ///
  List<String> encodeList() {
    final result = <String>[];
    for (final dto in this) {
      result.add(jsonEncode(dto.uniqueId));
    }
    return result;
  }

  /// Create a new list with the same values
  ///
  Iterable<MovieResultDTO> shallowCopy() {
    final newList = <MovieResultDTO>[];
    forEach(newList.add);
    return newList;
  }
}

extension MapResultDTOConversion on Map<dynamic, dynamic> {
  /// Convert a [Map] into a [MovieResultDTO] object
  ///
  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO toMovieResultDTO() {
    final dto = MovieResultDTO()
      ..uniqueId = dynamicToString(this[movieDTOUniqueId])
      ..title = dynamicToString(this[movieDTOTitle])
      ..alternateTitle = dynamicToString(this[movieDTOAlternateTitle])
      ..charactorName = dynamicToString(this[movieDTOCharactorName])
      ..description = dynamicToString(this[movieDTODescription])
      ..year = dynamicToInt(this[movieDTOYear])
      ..yearRange = dynamicToString(this[movieDTOYearRange])
      ..creditsOrder = dynamicToInt(this[movieDTOcreditsOrder])
      ..userRating = dynamicToDouble(this[movieDTOUserRating])
      ..userRatingCount = dynamicToInt(this[movieDTOUserRatingCount])
      ..runTime = Duration(seconds: dynamicToInt(this[movieDTORunTime]))
      ..imageUrl = dynamicToString(this[movieDTOImageUrl])
      ..languages = dynamicToStringSet(this[movieDTOLanguages])
      ..genres = dynamicToStringSet(this[movieDTOGenres])
      ..keywords = dynamicToStringSet(this[movieDTOKeywords])
      ..related = stringToRelated(this[movieDTORelated]);

    dto
      ..bestSource = getEnumValue<DataSourceType>(
            this[movieDTOBestSource],
            DataSourceType.values,
          ) ??
          dto.bestSource
      ..type = getEnumValue<MovieContentType>(
            this[movieDTOType],
            MovieContentType.values,
          ) ??
          dto.type
      ..censorRating = getEnumValue<CensorRatingType>(
            this[movieDTOCensorRating],
            CensorRatingType.values,
          ) ??
          dto.censorRating
      ..language = getEnumValue<LanguageType>(
            this[movieDTOLanguage],
            LanguageType.values,
          ) ??
          dto.language
      ..sources = stringToSources(this[movieDTOSources]);
    if (!dto.sources.containsKey(dto.bestSource) && !dto.isMessage()) {
      dto.sources[dto.bestSource] = dto.uniqueId;
    }
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
      // Find the categories that movie are collected under
      // e.g. "director", "writer", etc
      for (final category in categories.entries) {
        if (category.value is Map || category.value is Iterable) {
          final categoryText = category.key.toString();
          final categoryContents = category.value;

          // Convert the contents of the category to a list.
          Iterable<dynamic> movieList = [];
          if (categoryContents is Map) {
            movieList = categoryContents.values;
          } else if (categoryContents is Iterable<Map>) {
            movieList = categoryContents;
          }

          // Build a collection of movie DTOs keyed by the unique id.
          final MovieCollection movies = {};
          for (final movieEntry in movieList) {
            if (movieEntry is Map) {
              // Build DTO based on attributes encoded in the map.
              final dto = movieEntry.toMovieResultDTO();
              movies[dto.uniqueId] = dto;
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

  static Map<dynamic, dynamic> dumpCache() {
    final cache = _singleton._globalDtoCache.memoryCache;
    for (final record in cache.entries) {
      print('${record.key} - ${record.value.title}');
    }
    return cache;
  }

  /// Retrieve data from the memory cache if available.
  ///
  MovieResultDTO? fetchSynchronously(String uniqueId) {
    try {
      return _globalDtoCache.get(uniqueId);
    } catch (e) {
      return null;
    }
  }

  /// Retrieve data from the cache.
  ///
  Future<MovieResultDTO> fetch(MovieResultDTO newValue) async =>
      merge(newValue);

  /// remove [newValue] from the cache.
  ///
  void remove(MovieResultDTO newValue) =>
      _globalDtoCache.remove(_key(newValue));

  /// Store information from [newValue] into a cache and
  /// merge with any existing record.
  ///
  Future<MovieResultDTO> merge(MovieResultDTO newValue) async {
    final key = _key(newValue);
    if (await _globalDtoCache.isCached(key)) {
      return _globalDtoCache.get(key)..merge(newValue);
    }
    _globalDtoCache.add(key, newValue);
    return newValue;
  }

  /// Update cache to merge in movies from [newDtos] and
  /// return the same records with updated values.
  ///
  Future<MovieCollection> mergeCollection(MovieCollection newDtos) async {
    final MovieCollection merged = {};
    for (final dto in newDtos.entries) {
      merged[dto.key] = await merge(dto.value);
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

  /// dto is a message if it is an error, navigation command, of info.
  bool isMessage() {
    switch (type) {
      case MovieContentType.error:
      case MovieContentType.navigation:
        return true;

      case MovieContentType.information:
      case MovieContentType.none:
      case MovieContentType.keyword:
      case MovieContentType.barcode:
      case MovieContentType.searchprompt:
      case MovieContentType.person:
      case MovieContentType.download:
      case MovieContentType.movie:
      case MovieContentType.short:
      case MovieContentType.series:
      case MovieContentType.miniseries:
      case MovieContentType.episode:
      case MovieContentType.title:
      case MovieContentType.custom:
        return false;
    }
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
    final readIndicator = getReadIndicator();

    sources.clear();
    sources[bestSource] = uniqueId;

    if (readIndicator != null) setReadIndicator(readIndicator);
    return this;
  }

  void setReadIndicator(String value) {
    sources[DataSourceType.fbmmsnavlog] = value;
  }

  String? getReadIndicator() => sources[DataSourceType.fbmmsnavlog];

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

    if (this.type != MovieContentType.searchprompt &&
        this.type != MovieContentType.episode) {
      this.type = bestValue(
        getMovieContentType(
              '$genres $yearRange',
              IntHelper.fromText(runTime),
              this.uniqueId,
            ) ??
            this.type,
        this.type,
      );
    }
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
  String toJsonText({bool includeRelated = true}) =>
      jsonEncode(toMap(includeRelated: includeRelated));

  /// Convert a [MovieResultDTO] object into a [Map].
  ///
  /// All returned objects are compatible with the StandardMessageCodec class.
  /// i.e. only contain string, number, bool, map or list.
  Map<String, Object> toMap({
    bool includeRelated = true,
    bool condensed = false,
    bool flattenRelated = false,
  }) {
    final result = <String, Object>{};
    final defaultValues = MovieResultDTO();
    result[movieDTOUniqueId] = uniqueId;
    if (title != defaultValues.title) result[movieDTOTitle] = title;
    if (!condensed) {
      if (bestSource != defaultValues.bestSource) {
        result[movieDTOBestSource] = bestSource.toString();
      }
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
        final relatedMap = <String, Object>{};
        for (final category in related.entries) {
          if (flattenRelated) {
            // Present related values as a List.
            final movies = <Map<String, Object>>[];
            for (final dto in category.value.entries) {
              final movieMap = dto.value.toMap();
              movies.add(movieMap);
            }
            relatedMap[category.key] = movies;
          } else {
            // Present related values as a Map.
            final movies = <String, dynamic>{};
            for (final dto in category.value.entries) {
              final movieMap = dto.value.toMap();
              movies[dto.value.uniqueId] = movieMap;
            }
            relatedMap[category.key] = movies;
          }
        }
        result[movieDTORelated] = relatedMap;
      }
    }
    return result;
  }

  /// Add [relatedDto] into the related movies list of a [MovieResultDTO]
  /// in the [key] section.
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
  void merge(MovieResultDTO newValue, {bool excludeRelated = false}) {
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
  }

  /// Combine related movie information from [existingDtos]
  /// into a [MovieResultDTO].
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

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  MovieContentType bestType(
    MovieContentType existing,
    MovieContentType candidate,
  ) {
    if (candidate.index > existing.index) return candidate;
    return existing;
  }

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  CensorRatingType bestCensorRating(
    CensorRatingType existing,
    CensorRatingType candidate,
  ) {
    if (candidate.index > existing.index) return candidate;
    return existing;
  }

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  DataSourceType bestBestSource(
    DataSourceType existing,
    DataSourceType candidate,
  ) {
    if (candidate == DataSourceType.imdb) return candidate;
    return existing;
  }

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  LanguageType bestLanguage(
    LanguageType existing,
    LanguageType candidate,
  ) {
    if (candidate.index > existing.index) return candidate;
    return existing;
  }

  /// Create a string representation of a [MovieResultDTO].
  ///
  String toPrintableString() => toMap().toString();

  /// Create a placeholder for a value that can not be easily represented
  /// as a [MovieResultDTO].
  ///
  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO toUnknown() => MovieResultDTO()
    ..bestSource = bestSource
    ..uniqueId = uniqueId
    ..title = 'unknown'
    ..alternateTitle = alternateTitle
    ..charactorName = charactorName
    ..description = description
    ..type = type
    ..year = year
    ..yearRange = yearRange
    ..creditsOrder = creditsOrder
    ..userRating = userRating
    ..userRatingCount = userRatingCount
    ..censorRating = censorRating
    ..runTime = runTime
    ..imageUrl = imageUrl
    ..language = language
    ..languages = languages
    ..genres = genres
    ..keywords = keywords
    ..sources = sources
    ..related = related;

  /// Look at information provided
  /// to see if [MovieContentType] can be determined.
  ///
  /// info is in the form  ' (1988–1993) (TV Series)'
  static MovieContentType? _lookupMovieContentType(
    String info,
    int? seconds,
    String id,
  ) {
    if (id.startsWith(imdbPersonPrefix)) return MovieContentType.person;
    if (id == movieDTOUninitialized) return MovieContentType.none;
    if (id.startsWith(movieDTOMessagePrefix)) return MovieContentType.error;
    final String title = info.toLowerCase().replaceAll('sci-fi', '');
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

  /// Construct route to Material user interface page
  /// as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  RouteInfo getDetailsPage() {
    if (uniqueId.startsWith(imdbPersonPrefix) ||
        type == MovieContentType.person) {
      // Open person details.
      return RouteInfo(
        ScreenRoute.persondetails,
        RestorableMovie.routeState(this),
        uniqueId,
      );
    } else if (uniqueId.startsWith(imdbTitlePrefix) ||
        type == MovieContentType.movie ||
        type == MovieContentType.miniseries ||
        type == MovieContentType.short ||
        type == MovieContentType.series ||
        type == MovieContentType.episode ||
        type == MovieContentType.title) {
      // Open Movie details.
      return RouteInfo(
        ScreenRoute.moviedetails,
        RestorableMovie.routeState(this),
        uniqueId,
      );
    } else {
      // Open error details.
      return RouteInfo(
        ScreenRoute.errordetails,
        RestorableMovie.routeState(this),
        MovieContentType.error.toString(),
      );
    }
  }

  /// Compare 2 fields and describe the difference
  void _matchCompare<T>(
    Map<String, String> mismatches,
    String fieldName,
    T actual,
    T expected, {
    bool fuzzy = false,
  }) {
    if (fuzzy && (actual is num || expected is num)) {
      _matchFuzzyCompare(mismatches, fieldName, actual as num, expected as num);
    } else {
      if (expected != actual) {
        mismatches[fieldName] =
            'is different\n  Expected: "$expected"\n    Actual: "$actual"\n';
      }
    }
  }

  /// Compare 2 fields and describe the difference
  void _matchFuzzyCompare<T extends num>(
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
      final actualKey = actualSorted.keys.elementAt(index);
      final expectedKey = expectedSorted.keys.elementAt(index);
      final actualValue = actualSorted.values.elementAt(index);
      final expectedValue = expectedSorted.values.elementAt(index);
      // Compare source name
      _matchCompare(mismatches, fieldName, actualKey, expectedKey);
      // Compare source identifier
      _matchCompareId(mismatches, fieldName, actualValue, expectedValue);
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
    Map<dynamic, dynamic>? matchState,
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
  LanguageType getLanguageType([Iterable<dynamic>? languageList]) {
    for (final languageVal in languageList ?? languages) {
      final languageText = languageVal.toString();
      if (languageText.isNotEmpty) {
        if (!languages.contains(languageText)) {
          languages.add(languageText);
        }
        if (languageText.toUpperCase().startsWith('EN')) {
          if (LanguageType.none == language ||
              LanguageType.allEnglish == language) {
            // First item(s) found are English,
            // assume all English until other languages found.
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
          // First item found is foreign,
          // assume all foreign until other languages found.
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

  MovieResultDTO inflate() =>
      DtoCache.singleton().fetchSynchronously(uniqueId) ?? this;

  @factory
  // ignore: invalid_factory_method_impl
  MovieResultDTO clone({bool condensed = false}) =>
      toMap(condensed: condensed).toMovieResultDTO();
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
      listContents.write('$separator${entry.toJsonText()}');
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
      final json = entry.toJsonText(includeRelated: includeRelated);
      final dartString = "r'''\n${json.replaceAll("'", "'")}\n''',\n";
      listContents.write(formatDtoJson(dartString));
    }
    return '[\n$listContents]';
  }

  /// Format JSON for readability
  String formatDtoJson(String json) {
    var formatted = json;
    formatted = formatted.replaceAll(
      '"related":{"',
      '\n  "related":{"',
    );
    formatted = formatted.replaceAll(
      r'"languages":"[\"',
      '\n      "languages":"[\\"',
    );
    formatted = formatted.replaceAll(
      r'"genres":"[\"',
      '\n      "genres":"[\\"',
    );
    formatted = formatted.replaceAll(
      r'"keywords":"[\"',
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
  String toJson({bool condensed = false}) {
    final listContents = <String>[];
    for (final dto in this) {
      listContents.add(jsonEncode(dto.toMap(condensed: condensed)));
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

  /// Create a short string representation
  /// of a [Map]<[dynamic],[MovieResultDTO]>.
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
  /// Create a string representation
  /// of a Map<[dynamic], Map<[dynamic], [MovieResultDTO]>>>.
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

  /// Create a short string representation
  /// of a Map<[dynamic], Map<[dynamic], [MovieResultDTO]>>>.
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
      case MovieContentType.searchprompt:
        return barcodeCompare(other);
      case MovieContentType.movie:
      case MovieContentType.error:
      case MovieContentType.information:
      case MovieContentType.keyword:
      case MovieContentType.navigation:
      case MovieContentType.none:
      case MovieContentType.short:
      case MovieContentType.series:
      case MovieContentType.miniseries:
      case MovieContentType.episode:
      case MovieContentType.title:
      case MovieContentType.custom:
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
    final read = getReadIndicator();

    switch (read) {
      case '':
        return 98;
      case null:
        return 98;
      case 'blank': // old version of as ReadHistory.read
        return 0;
      default:
        {
          try {
            final readHistory =
                getEnumValue<ReadHistory>(read, ReadHistory.values);
            switch (readHistory) {
              case ReadHistory.starred:
                return 99;
              case ReadHistory.reading:
                return 1;
              case ReadHistory.read:
                return 0;
              case null:
              case ReadHistory.none:
              case ReadHistory.custom:
            }
            // ignore: avoid_catching_errors
          } on ArgumentError catch (_) {}
        }
    }
    return 0;
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
      case MovieContentType.movie:
        return 98;
      case MovieContentType.series:
        return 90;
      case MovieContentType.none:
      case MovieContentType.title:
        return 80;
      case MovieContentType.episode:
      case MovieContentType.miniseries:
        return 7;
      case MovieContentType.short:
        return 6;
      case MovieContentType.custom:
        return 5;
      case MovieContentType.keyword:
      case MovieContentType.barcode:
      case MovieContentType.searchprompt:
        return 4;
      case MovieContentType.download:
        return 3;
      case MovieContentType.error:
        return 2;
      case MovieContentType.information:
        return 1;
      case MovieContentType.navigation:
        return 0;
    }
  }

  /// Rank movies based on spoken language.
  ///
  /// English > mostly English > some English > no English > silent
  // Need to reverse the enum order for use with CompareTo().
  int languageCategory() => language.index * -1;

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
