import 'dart:convert';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

typedef RelatedMovies = Map<String, MovieResultDTO>;
typedef RelatedMovieCategories = Map<String, RelatedMovies>;

class MovieResultDTO {
  DataSourceType source = DataSourceType.none;
  String uniqueId = movieResultDTOUninitialized; // ID in current data source
  String alternateId = ''; // ID in another data source e.g. from TMDB to IMDB
  String title = '';
  String alternateTitle = '';
  String charactorName = '';
  String description = '';
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = '';
  double userRating = 0;
  int userRatingCount = 0;
  CensorRatingType censorRating = CensorRatingType.none;
  Duration runTime = Duration.zero;
  String imageUrl = '';
  LanguageType language = LanguageType.none;
  Set<String> languages = {};
  Set<String> genres = {};
  Set<String> keywords = {};
  // Related DTOs are in a category, then keyed by uniqueId
  RelatedMovieCategories related = {};
}

enum MovieContentType {
  none,
  person,
  movie, //      includes "tv movie"
  series, //     anything less that an hour long that does repeat or repeats more than 4 times
  miniseries, // anything more that an hour long that does repeat
  short, //      anything less that an hour long that does not repeat
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
const String movieResultDTOSource = 'source';
const String movieResultDTOUniqueId = 'uniqueId';
const String movieResultDTOAlternateId = 'alternateId';
const String movieResultDTOTitle = 'title';
const String movieResultDTOAlternateTitle = 'alternateTitle';
const String movieResultDTOCharactorName = 'charactorName';
const String movieResultDTODescription = 'description';
const String movieResultDTOType = 'type';
const String movieResultDTOYear = 'year';
const String movieResultDTOYearRange = 'yearRange';
const String movieResultDTOUserRating = 'userRating';
const String movieResultDTOUserRatingCount = 'userRatingCount';
const String movieResultDTOCensorRating = 'censorRating';
const String movieResultDTORunTime = 'runTime';
const String movieResultDTOImageUrl = 'imageUrl';
const String movieResultDTOLanguage = 'language';
const String movieResultDTOLanguages = 'languages';
const String movieResultDTOGenres = 'genres';
const String movieResultDTOKeywords = 'keywords';
const String movieResultDTORelated = 'related';
const String movieResultDTOUninitialized = '-1';
const String movieResultDTOMessagePrefix = '-';

class RestorableMovie extends RestorableValue<MovieResultDTO> {
  @override
  MovieResultDTO createDefaultValue() => MovieResultDTO();

  @override
  void didUpdateValue(MovieResultDTO? oldValue) {
    if (null == oldValue || !oldValue.matches(value)) {
      notifyListeners();
    }
  }

  @override
  MovieResultDTO fromPrimitives(Object? data) => dtoFromPrimitives(data);
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
  Object dtoToPrimitives(MovieResultDTO dto) =>
      jsonEncode(dto.toMap(excludeCopyrightedData: false));
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
  List<MovieResultDTO> fromPrimitives(Object? data) => dtoFromPrimitives(data);
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
      result.add(dto.toJson(excludeCopyrightedData: false));
    }
    return result;
  }
}

extension MapResultDTOConversion on Map {
  /// Convert a [Map] into a [MovieResultDTO] object
  ///
  MovieResultDTO toMovieResultDTO() {
    final dto = MovieResultDTO();
    dto.uniqueId = dynamicToString(this[movieResultDTOUniqueId]);
    dto.alternateId = dynamicToString(this[movieResultDTOAlternateId]);
    dto.title = dynamicToString(this[movieResultDTOTitle]);
    dto.alternateTitle = dynamicToString(this[movieResultDTOAlternateTitle]);
    dto.charactorName = dynamicToString(this[movieResultDTOCharactorName]);

    dto.description = dynamicToString(this[movieResultDTODescription]);
    dto.year = dynamicToInt(this[movieResultDTOYear]);
    dto.yearRange = dynamicToString(this[movieResultDTOYearRange]);
    dto.userRating = dynamicToDouble(this[movieResultDTOUserRating]);
    dto.userRatingCount = dynamicToInt(this[movieResultDTOUserRatingCount]);
    dto.runTime = Duration(seconds: dynamicToInt(this[movieResultDTORunTime]));
    dto.imageUrl = dynamicToString(this[movieResultDTOImageUrl]);

    dto.source = getEnumValue<DataSourceType>(
          this[movieResultDTOSource],
          DataSourceType.values,
        ) ??
        dto.source;
    dto.type = getEnumValue<MovieContentType>(
          this[movieResultDTOType],
          MovieContentType.values,
        ) ??
        dto.type;
    dto.censorRating = getEnumValue<CensorRatingType>(
          this[movieResultDTOCensorRating],
          CensorRatingType.values,
        ) ??
        dto.censorRating;
    dto.language = getEnumValue<LanguageType>(
          this[movieResultDTOLanguage],
          LanguageType.values,
        ) ??
        dto.language;

    dto.languages = dynamicToStringSet(this[movieResultDTOLanguages]);
    dto.genres = dynamicToStringSet(this[movieResultDTOGenres]);
    dto.keywords = dynamicToStringSet(this[movieResultDTOKeywords]);
    dto.related = stringToRelated(this[movieResultDTORelated]);
    return dto;
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
          final RelatedMovies movies = {};
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

extension MovieResultDTOHelpers on MovieResultDTO {
  static final _htmlDecode = HtmlUnescape();

  /// Create a MovieResultDTO encapsulating an error.
  ///
  static int _lastError = -1;
  MovieResultDTO error([String errorText = '']) {
    _lastError = _lastError - 1;
    uniqueId = _lastError.toString();
    title = errorText;
    return this;
  }

  MovieResultDTO testDto(String testText) {
    title = testText;
    return this;
  }

  /// Create a MovieResultDTO with supplied data.
  ///
  MovieResultDTO init({
    DataSourceType source = DataSourceType.none,
    String? uniqueId = movieResultDTOUninitialized,
    String? alternateId = '',
    String? title = '',
    String? alternateTitle = '',
    String? charactorName = '',
    String? description = '',
    String? type = '',
    String? year = '0',
    String? yearRange = '',
    String? userRating = '0',
    String? userRatingCount = '0',
    String? censorRating = '',
    String? runTime = '0',
    String? imageUrl = '',
    String? language = '',
    String? languages = '[]',
    String? genres = '[]',
    String? keywords = '[]',
    // Related DTOs are in a category, then keyed by uniqueId
    RelatedMovieCategories? related,
  }) {
    // Strongly type variables, caller must give valid data
    this.source = source;
    this.related = related ?? {};
    // Weakly typed variables, help caller to massage data
    this.uniqueId = uniqueId ?? movieResultDTOUninitialized;
    this.alternateId = alternateId ?? '';
    this.title = title ?? alternateTitle ?? '';
    if (title != alternateTitle) {
      this.alternateTitle = alternateTitle ?? '';
    }
    this.charactorName = charactorName ?? '';
    this.description = description ?? '';
    this.yearRange = yearRange ?? '';
    this.imageUrl = imageUrl ?? '';
    this.year = IntHelper.fromText(year) ?? 0;
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
    return this;
  }

  /// Convert a json [String] to a [MovieResultDTO].
  ///
  MovieResultDTO fromJson(dynamic json) {
    final decoded = jsonDecode(json.toString());
    if (decoded is Map) return decoded.toMovieResultDTO();
    return MovieResultDTO();
  }

  /// Convert a [MovieResultDTO] to a json [String].
  ///
  String toJson({bool excludeCopyrightedData = true}) {
    return jsonEncode(toMap(excludeCopyrightedData: excludeCopyrightedData));
  }

  /// Convert a [MovieResultDTO] object into a [Map].
  ///
  /// All returned objects are compatible with the [StandardMessageCodec] class.
  /// i.e. only contain string, number, bool, map or list.
  Map<String, Object> toMap({bool excludeCopyrightedData = true}) {
    final result = <String, Object>{};
    final defaultValues = MovieResultDTO();
    result[movieResultDTOUniqueId] = uniqueId;
    if (source != defaultValues.source) {
      result[movieResultDTOSource] = source.toString();
    }
    if (alternateId != defaultValues.alternateId) {
      result[movieResultDTOAlternateId] = alternateId;
    }
    if (title != defaultValues.title) result[movieResultDTOTitle] = title;
    if (alternateTitle != defaultValues.alternateTitle) {
      result[movieResultDTOAlternateTitle] = alternateTitle;
    }
    if (charactorName != defaultValues.charactorName) {
      result[movieResultDTOCharactorName] = charactorName;
    }

    if (type != defaultValues.type) {
      result[movieResultDTOType] = type.toString();
    }
    if (year != defaultValues.year) {
      result[movieResultDTOYear] = year.toString();
    }
    if (yearRange != defaultValues.yearRange) {
      result[movieResultDTOYearRange] = yearRange;
    }
    if (runTime != defaultValues.runTime) {
      result[movieResultDTORunTime] = runTime.inSeconds.toString();
    }
    if (language != defaultValues.language) {
      result[movieResultDTOLanguage] = language.toString();
    }

    if (!excludeCopyrightedData) {
      if (languages != defaultValues.languages) {
        result[movieResultDTOLanguages] = json.encode(languages.toList());
      }
      if (genres != defaultValues.genres) {
        result[movieResultDTOGenres] = json.encode(genres.toList());
      }
      if (keywords != defaultValues.keywords) {
        result[movieResultDTOKeywords] = json.encode(keywords.toList());
      }
      if (description != defaultValues.description) {
        result[movieResultDTODescription] = description;
      }
      if (userRating != defaultValues.userRating) {
        result[movieResultDTOUserRating] = userRating.toString();
      }
      if (userRatingCount != defaultValues.userRatingCount) {
        result[movieResultDTOUserRatingCount] = userRatingCount.toString();
      }
      if (censorRating != defaultValues.censorRating) {
        result[movieResultDTOCensorRating] = censorRating.toString();
      }
      if (imageUrl != defaultValues.imageUrl) {
        result[movieResultDTOImageUrl] = imageUrl;
      }
    }
    // convert each related dto to a string
    final relatedMap = <String, Object>{};
    for (final category in related.entries) {
      final Map movies = {};
      for (final dto in category.value.entries) {
        final movieMap = dto.value.toMap(
          excludeCopyrightedData: excludeCopyrightedData,
        );
        movies[dto.value.uniqueId] = movieMap;
      }
      relatedMap[category.key] = movies;
    }
    result[movieResultDTORelated] = relatedMap;
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
  void merge(MovieResultDTO newValue) {
    //TODO alternate ID
    if (newValue.userRatingCount > userRatingCount ||
        0 == userRatingCount ||
        DataSourceType.imdb == newValue.source) {
      source = bestValue(newValue.source, source);

      final oldTitle = title;
      if (DataSourceType.imdb == newValue.source && '' != newValue.title) {
        title = _htmlDecode.convert(newValue.title);
      } else {
        title = bestValue(newValue.title, title).trim();
      }
      var newAlternateTitle = '';
      if ('' != newValue.alternateTitle.trim() &&
          title != newValue.alternateTitle.trim()) {
        newAlternateTitle = newValue.alternateTitle;
      } else if ('' != oldTitle.trim() && title != oldTitle.trim()) {
        newAlternateTitle = oldTitle;
      } else if ('' != alternateTitle.trim() &&
          title != alternateTitle.trim()) {
        newAlternateTitle = alternateTitle;
      }

      alternateTitle = newAlternateTitle;
      print('$uniqueId  merged $title & $alternateTitle ');
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
      getLanguageType();
      userRating = bestUserRating(
        newValue.userRating,
        newValue.userRatingCount,
        userRating,
        userRatingCount,
      );
      userRatingCount = bestValue(newValue.userRatingCount, userRatingCount);
    }
    mergeDtoMapMap(related, newValue.related);
  }

  /// Combine related movie information from [existingDtos] into a [MovieResultDTO].
  ///
  void mergeDtoMapMap(
    RelatedMovieCategories existingDtos,
    RelatedMovieCategories newDtos,
  ) {
    for (final key in newDtos.keys) {
      if (!existingDtos.containsKey(key)) {
        // Create empty list to pass through to merge function.
        existingDtos[key] = {};
      }
      mergeDtoList(existingDtos[key]!, newDtos[key]!);
    }
  }

  /// Update [existingDtos] to also contain movies from [newDtos].
  ///
  void mergeDtoList(
    RelatedMovies existingDtos,
    RelatedMovies newDtos,
  ) {
    for (final dto in newDtos.entries) {
      if (existingDtos.keys.contains(dto.key)) {
        existingDtos[dto.key]!.merge(dto.value);
      } else {
        existingDtos[dto.key] = dto.value;
      }
    }
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  /// [a] and [b] can be numbers, strings, durations, enums
  T bestValue<T>(T a, T b) {
    if (a is MovieContentType && b is MovieContentType) bestType(a, b);
    if (a is CensorRatingType && b is CensorRatingType) bestCensorRating(a, b);
    if (a is DataSourceType && b is DataSourceType) bestSource(a, b);
    if (a is LanguageType && b is LanguageType) bestLanguage(a, b);
    if (a is num && b is num && a < b) return b;
    if (a is Duration && b is Duration && a < b) return b;
    if (a is String && b is String) {
      final aStr = _htmlDecode.convert(a);
      final bStr = _htmlDecode.convert(b);
      if (aStr.length < bStr.length) return bStr as T;
      return aStr as T;
    }
    if (a.toString().length < b.toString().length) return b;
    if (lastNumberFromString(a.toString()) <
        lastNumberFromString(b.toString())) {
      return b;
    }
    return a;
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
  DataSourceType bestSource(DataSourceType a, DataSourceType b) {
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
  String toPrintableString() {
    return toMap(excludeCopyrightedData: false).toString();
  }

  /// Create a placeholder for a value that can not be easily represented
  /// as a [MovieResultDTO].
  ///
  MovieResultDTO toUnknown() {
    final dto = MovieResultDTO();
    dto.source = source;
    dto.uniqueId = uniqueId;
    dto.alternateId = alternateId;
    dto.title = 'unknown';
    dto.alternateTitle = alternateTitle;
    dto.charactorName = charactorName;

    dto.description = description;
    dto.type = type;
    dto.year = year;
    dto.yearRange = yearRange;
    dto.userRating = userRating;
    dto.userRatingCount = userRatingCount;
    dto.censorRating = censorRating;
    dto.runTime = runTime;
    dto.imageUrl = imageUrl;
    dto.language = language;
    dto.languages = languages;
    dto.genres = genres;
    dto.keywords = keywords;
    dto.related = related;
    return dto;
  }

  /// Test framework matcher to compare current [MovieResultDTO] to [other]
  ///
  /// Explains any difference found.
  bool matches(MovieResultDTO other, {Map? matchState, bool related = true}) {
    if (title == other.title && title == 'unknown') return true;

    final mismatches = <String, String>{};
    void _matchCompare<T>(String field, T expected, T actual) {
      if (expected != actual) {
        mismatches[field] =
            'is different\n  Expected: "$expected"\n  Actual: "$actual"';
      }
    }

    _matchCompare('source', source, other.source);
    _matchCompare('uniqueId', uniqueId, other.uniqueId);
    _matchCompare('alternateId', alternateId, other.alternateId);
    _matchCompare('title', title, other.title);
    _matchCompare('alternateTitle', alternateTitle, other.alternateTitle);
    _matchCompare('charactorName', charactorName, other.charactorName);
    _matchCompare('description', description, other.description);
    _matchCompare('type', type, other.type);
    _matchCompare('year', year, other.year);
    _matchCompare('yearRange', yearRange, other.yearRange);
    _matchCompare('userRating', userRating, other.userRating);
    _matchCompare('censorRating', censorRating, other.censorRating);
    _matchCompare('runTime', runTime, other.runTime);
    _matchCompare('imageUrl', imageUrl, other.imageUrl);
    _matchCompare('language', language, other.language);
    _matchCompare(
      'languages',
      languages.toString(),
      other.languages.toString(),
    );
    _matchCompare('genres', genres.toString(), other.genres.toString());
    _matchCompare('keywords', keywords.toString(), other.keywords.toString());

    if (related) {
      final expected = this.related.toPrintableString();
      final actual = other.related.toPrintableString();
      if (expected != actual) _matchCompare('related', expected, actual);
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
  String toListOfDartJsonStrings({bool excludeCopyrightedData = true}) {
    final listContents = StringBuffer();
    for (final entry in this) {
      final json = entry.toJson(excludeCopyrightedData: excludeCopyrightedData);
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
      listContents.add(jsonEncode(key.toMap(excludeCopyrightedData: false)));
    }
    return jsonEncode(listContents);
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
        '$separator${key.toString()}:${this[key]!.toPrintableString()}',
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
        '$separator${key.toString()}:${this[key]!.toShortString()}',
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
    // Treat null and negative numbers as lower than any other value
    if (uniqueId == movieResultDTOUninitialized &&
        other.uniqueId != movieResultDTOUninitialized) return -1;
    if (uniqueId != movieResultDTOUninitialized &&
        other.uniqueId == movieResultDTOUninitialized) return 1;
    // Preference people > movies.
    if (contentCategory() != other.contentCategory()) {
      return contentCategory().compareTo(other.contentCategory());
    }
    // For people sort by popularity
    if (MovieContentType.person == type) {
      if (userRatingCount != other.userRatingCount) {
        return personPopularityCompare(other);
      }
      return title.compareTo(other.title) * -1;
    }
    // See how many people have rated this movie.
    if (userRatingCategory() != other.userRatingCategory()) {
      return userRatingCategory().compareTo(other.userRatingCategory());
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

  /// Rank movies based on type of content.
  ///
  /// movie > miniseries > tv series > short > series episode > game & unknown
  int titleContentCategory() {
    if (type == MovieContentType.none || type == MovieContentType.custom) {
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
    if (type == MovieContentType.person) {
      return 1;
    }
    return 0;
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
  int personPopularityCompare(MovieResultDTO? other) {
    final otherCount = other?.userRatingCount ?? 0;
    return userRatingCount.compareTo(otherCount);
  }

  /// Extract year release or year of most recent episode.
  ///
  int maxYear() {
    return max(year, yearRangeAsNumber());
  }

  /// Extract year of most recent episode.
  ///
  int yearRangeAsNumber() {
    return lastNumberFromString(yearRange);
  }

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
