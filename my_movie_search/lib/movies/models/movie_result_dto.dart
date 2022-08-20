import 'dart:convert';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';

class MovieResultDTO {
  DataSourceType source = DataSourceType.none;
  String uniqueId = movieResultDTOUninitialized; // ID in current data source
  String alternateId = ''; // ID in another data source e.g. from TMDB to IMDB
  String title = '';
  String alternateTitle = '';
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
  List<String> languages = [];
  List<String> genres = [];
  List<String> keywords = [];
  // Related DTOs are in a category, then keyed by uniqueId
  Map<String, Map<String, MovieResultDTO>> related = {};
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
      result.add(jsonEncode(dto.toMap(excludeCopyrightedData: false)));
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

    dto.languages = dynamicToStringList(this[movieResultDTOLanguages]);
    dto.genres = dynamicToStringList(this[movieResultDTOGenres]);
    dto.keywords = dynamicToStringList(this[movieResultDTOKeywords]);
    //TODO related
    return dto;
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

  /// Convert a [MovieResultDTO] object into a [Map].
  ///
  Map<String, String> toMap({bool excludeCopyrightedData = true}) {
    final map = <String, String>{};
    final defaultValues = MovieResultDTO();
    if (source != defaultValues.source) {
      map[movieResultDTOSource] = source.toString();
    }
    if (uniqueId != defaultValues.uniqueId) {
      map[movieResultDTOUniqueId] = uniqueId;
    }
    if (alternateId != defaultValues.alternateId) {
      map[movieResultDTOAlternateId] = alternateId;
    }
    if (title != defaultValues.title) map[movieResultDTOTitle] = title;
    if (alternateTitle != defaultValues.alternateTitle) {
      map[movieResultDTOAlternateTitle] = alternateTitle;
    }

    if (type != defaultValues.type) {
      map[movieResultDTOType] = type.toString();
    }
    if (year != defaultValues.year) {
      map[movieResultDTOYear] = year.toString();
    }
    if (yearRange != defaultValues.yearRange) {
      map[movieResultDTOYearRange] = yearRange;
    }
    if (runTime != defaultValues.runTime) {
      map[movieResultDTORunTime] = runTime.inSeconds.toString();
    }
    if (language != defaultValues.language) {
      map[movieResultDTOLanguage] = language.toString();
    }

    if (!excludeCopyrightedData) {
      if (languages != defaultValues.languages) {
        map[movieResultDTOLanguages] = json.encode(languages);
      }
      if (genres != defaultValues.genres) {
        map[movieResultDTOGenres] = json.encode(genres);
      }
      if (keywords != defaultValues.keywords) {
        map[movieResultDTOKeywords] = json.encode(keywords);
      }
      if (description != defaultValues.description) {
        map[movieResultDTODescription] = description;
      }
      if (userRating != defaultValues.userRating) {
        map[movieResultDTOUserRating] = userRating.toString();
      }
      if (userRatingCount != defaultValues.userRatingCount) {
        map[movieResultDTOUserRatingCount] = userRatingCount.toString();
      }
      if (censorRating != defaultValues.censorRating) {
        map[movieResultDTOCensorRating] = censorRating.toString();
      }
      if (imageUrl != defaultValues.imageUrl) {
        map[movieResultDTOImageUrl] = imageUrl;
      }
    }
    //TODO: related
    final relatedMap = <String, String>{};
    related.forEach(
      (key, childMap) => // Get comma delimited uniqueIds
          relatedMap[key] = childMap.keys.toString(),
    );
    map[movieResultDTORelated] = relatedMap.toString();
    return map;
  }

  /// Add [relatedDto] into the related movies list of a [MovieResultDTO] in the [key] section.
  ///
  void addRelated(String key, MovieResultDTO relatedDto) {
    if (!related.containsKey(key)) {
      related[key] = {};
    }
    if (!related[key]!.containsKey(relatedDto.uniqueId)) {
      related[key]![relatedDto.uniqueId] = relatedDto;
    } else {
      related[key]![relatedDto.uniqueId]!.merge(relatedDto);
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
      if (DataSourceType.imdb == newValue.source && "" != newValue.title) {
        title = _htmlDecode.convert(newValue.title);
      } else {
        title = bestValue(newValue.title, title);
      }

      alternateTitle = bestValue(newValue.alternateTitle, alternateTitle);
      description = bestValue(newValue.description, description);
      type = bestValue(newValue.type, type);
      year = bestValue(newValue.year, year);
      yearRange = bestValue(newValue.yearRange, yearRange);
      runTime = bestValue(newValue.runTime, runTime);
      type = bestValue(newValue.type, type);
      censorRating = bestValue(newValue.censorRating, censorRating);
      imageUrl = bestValue(newValue.imageUrl, imageUrl);
      language = bestValue(newValue.language, language);
      languages = bestList(newValue.languages, languages);
      genres = bestList(newValue.genres, genres);
      keywords = bestList(newValue.keywords, keywords);
      userRating = bestUserRating(
        newValue.userRating,
        newValue.userRatingCount,
        userRating,
        userRatingCount,
      );
      userRatingCount = bestValue(newValue.userRatingCount, userRatingCount);
      mergeDtoMapMap(related, newValue.related);
    }
  }

  /// Combine related movie information from [existingDtos] into a [MovieResultDTO].
  ///
  void mergeDtoMapMap(
    Map<String, Map<String, MovieResultDTO>> existingDtos,
    Map<String, Map<String, MovieResultDTO>> newDtos,
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
    Map<String, MovieResultDTO> existingDtos,
    Map<String, MovieResultDTO> newDtos,
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

  /// Combine [a] and [b] excluding duplicate entries from the result.
  ///
  List<String> bestList(List<String> a, List<String> b) {
    final result = <String>{};
    result.addAll(a);
    result.addAll(b);

    return result.toList();
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

  String toJson() {
    String encode(Object? dto) {
      if (null != dto && dto is MovieResultDTO) {
        final Map<String, dynamic> map = {};
        map.addAll(dto.toMap(excludeCopyrightedData: false));
        map["languages"] = dto.languages;
        map["genres"] = dto.genres;
        map["keywords"] = dto.keywords;
        //map["related"] = dto.related;
        return jsonEncode(
          map,
          toEncodable: encode,
        );
      } else {
        return dto.toString();
      }
    }

    return encode(this);
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
  bool matches(MovieResultDTO other) {
    if (title == other.title && title == 'unknown') return true;

    return source == other.source &&
        uniqueId == other.uniqueId &&
        alternateId == other.alternateId &&
        title == other.title &&
        alternateTitle == other.alternateTitle &&
        description == other.description &&
        type == other.type &&
        year == other.year &&
        yearRange == other.yearRange &&
        userRating == other.userRating &&
        censorRating == other.censorRating &&
        runTime == other.runTime &&
        language == other.language &&
        languages.toString() == other.languages.toString() &&
        genres.toString() == other.genres.toString() &&
        keywords.toString() == other.keywords.toString() &&
        imageUrl == other.imageUrl;
    // TODO reinstate when toMovieResultDTO can convert text to related.
    // this.related.toPrintableString() == other.related.toPrintableString();
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

  String toJsonString() {
    final listContents = StringBuffer();
    String separator = '';
    for (final entry in this) {
      listContents.write('$separator${entry.toJson()}');
      separator = ',\n';
    }
    return "List<MovieResultDTO>($length)\nr'''\n[\n$listContents\n]\n'''";
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
      return personPopularityCompare(other);
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
