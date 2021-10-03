import 'dart:convert';
import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';

import 'metadata_dto.dart';

class MovieResultDTO {
  DataSourceType source = DataSourceType.none;
  String uniqueId = movieResultDTOUninitialised;
  String alternateId = '';
  String title = '';
  String alternateTitle = '';
  String description = '';
  MovieContentType type = MovieContentType.none;
  int year = 0;
  String yearRange = '';
  double userRating = 0;
  int userRatingCount = 0;
  CensorRatingType censorRating = CensorRatingType.none;
  Duration runTime = Duration(hours: 0, minutes: 0, seconds: 0);
  String imageUrl = '';
  LanguageType language = LanguageType.none;
  List<String> languages = [];
  List<String> genres = [];
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
  restriced, // X, RC
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
const String movieResultDTORelated = 'related';
const String movieResultDTOUninitialised = '-1';
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
  MovieResultDTO fromPrimitives(Object? data) {
    if (data != null && data is String) {
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
      jsonEncode(dto.toMap(excludeCopywritedData: false));
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
  List<MovieResultDTO> fromPrimitives(Object? data) {
    if (data != null && data is String) {
      final decoded = jsonDecode(data);
      if (decoded is List) {
        return value.decodeList(decoded);
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
  List<MovieResultDTO> decodeList(Iterable<dynamic> encoded) {
    List<MovieResultDTO> retval = [];
    for (var json in encoded) {
      var decoded = jsonDecode(json.toString());
      if (decoded is Map) retval.add(decoded.toMovieResultDTO());
    }
    return retval;
  }

  /// Convert a [List] of [MovieResultDTO] objects into a [List] of json encoded [String]s
  ///
  List<String> encodeList() {
    List<String> retval = [];
    for (var dto in this) {
      retval.add(jsonEncode(dto.toMap(excludeCopywritedData: false)));
    }
    return retval;
  }
}

extension MapDTOConversion on Map {
  String _getString(dynamic val) {
    if (val is String) return val;
    return '';
  }

  int _getInt(dynamic val) {
    if (val is int) return val;
    if (val is String) return int.tryParse(val) ?? 0;
    if (val == null) return 0;
    return int.tryParse(val.toString()) ?? 0;
  }

  double _getDouble(dynamic val) {
    if (val is double) return val;
    if (val is String) return double.tryParse(val) ?? 0;
    if (val == null) return 0;
    return 0;
  }

  /// Convert a [Map] into a [MovieResultDTO] object
  ///
  MovieResultDTO toMovieResultDTO() {
    final dto = MovieResultDTO();
    dto.uniqueId = _getString(this[movieResultDTOUniqueId]);
    dto.alternateId = _getString(this[movieResultDTOAlternateId]);
    dto.title = _getString(this[movieResultDTOTitle]);
    dto.alternateTitle = _getString(this[movieResultDTOAlternateTitle]);

    dto.description = _getString(this[movieResultDTODescription]);
    dto.year = _getInt(this[movieResultDTOYear]);
    dto.yearRange = _getString(this[movieResultDTOYearRange]);
    dto.userRating = _getDouble(this[movieResultDTOUserRating]);
    dto.userRatingCount = _getInt(this[movieResultDTOUserRatingCount]);
    dto.runTime = Duration(seconds: _getInt(this[movieResultDTORunTime]));
    dto.imageUrl = _getString(this[movieResultDTOImageUrl]);

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
    dto.languages = ListHelper.fromJson(
      _getString(
        this[movieResultDTOLanguages],
      ),
    );
    dto.genres = ListHelper.fromJson(
      _getString(
        this[movieResultDTOGenres],
      ),
    );
    //TODO related
    return dto;
  }
}

extension MovieResultDTOHelpers on MovieResultDTO {
  static int _lastError = -1;
  MovieResultDTO error() {
    _lastError = _lastError - 1;
    this.uniqueId = _lastError.toString();
    return this;
  }

  /// Convert a [MovieResultDTO] object into a [Map].
  ///
  Map<String, String> toMap({bool excludeCopywritedData = true}) {
    Map<String, String> map = Map();
    var defaultVals = MovieResultDTO();
    if (this.source != defaultVals.source)
      map[movieResultDTOSource] = this.source.toString();
    if (this.uniqueId != defaultVals.uniqueId)
      map[movieResultDTOUniqueId] = this.uniqueId;
    if (this.alternateId != defaultVals.alternateId)
      map[movieResultDTOAlternateId] = this.alternateId;
    if (this.title != defaultVals.title) map[movieResultDTOTitle] = this.title;
    if (this.alternateTitle != defaultVals.alternateTitle)
      map[movieResultDTOAlternateTitle] = this.alternateTitle;

    if (this.type != defaultVals.type)
      map[movieResultDTOType] = this.type.toString();
    if (this.year != defaultVals.year)
      map[movieResultDTOYear] = this.year.toString();
    if (this.yearRange != defaultVals.yearRange)
      map[movieResultDTOYearRange] = this.yearRange;
    if (this.runTime != defaultVals.runTime)
      map[movieResultDTORunTime] = this.runTime.inSeconds.toString();
    if (this.language != defaultVals.language)
      map[movieResultDTOLanguage] = this.language.toString();

    if (!excludeCopywritedData) {
      if (this.languages != defaultVals.languages)
        map[movieResultDTOLanguages] = json.encode(this.languages);
      if (this.genres != defaultVals.genres)
        map[movieResultDTOGenres] = json.encode(this.genres);
      if (this.description != defaultVals.description)
        map[movieResultDTODescription] = this.description;
      if (this.userRating != defaultVals.userRating)
        map[movieResultDTOUserRating] = this.userRating.toString();
      if (this.userRatingCount != defaultVals.userRatingCount)
        map[movieResultDTOUserRatingCount] = this.userRatingCount.toString();
      if (this.censorRating != defaultVals.censorRating)
        map[movieResultDTOCensorRating] = this.censorRating.toString();
      if (this.imageUrl != defaultVals.imageUrl)
        map[movieResultDTOImageUrl] = this.imageUrl;
    }
    //TODO: related
    Map<String, String> related = {};
    this.related.forEach((key, childMap) => // Get comma delimted uniqueIds
        related[key] = (childMap).keys.toString());
    map[movieResultDTORelated] = related.toString();
    return map;
  }

  /// Add [relatedDto] into the related movies list of a [MovieResultDTO] in the [key] section.
  ///
  addRelated(String key, MovieResultDTO relatedDto) {
    if (!this.related.containsKey(key)) {
      this.related[key] = {};
    }
    if (!this.related[key]!.containsKey(relatedDto.uniqueId)) {
      this.related[key]![relatedDto.uniqueId] = relatedDto;
    } else {
      this.related[key]![relatedDto.uniqueId]!.merge(relatedDto);
    }
  }

  /// Combine information from [newValue] into a [MovieResultDTO].
  ///
  void merge(MovieResultDTO newValue) {
    //TODO alternate ID
    if (newValue.userRatingCount > this.userRatingCount ||
        0 == this.userRatingCount ||
        DataSourceType.imdb == newValue.source) {
      this.source = bestval(newValue.source, this.source);
      if (DataSourceType.imdb == newValue.source && "" != newValue.title) {
        this.title = newValue.title;
      } else {
        this.title = bestval(newValue.title, this.title);
      }

      this.alternateTitle =
          bestval(newValue.alternateTitle, this.alternateTitle);
      this.description = bestval(newValue.description, this.description);
      this.type = bestval(newValue.type, this.type);
      this.year = bestval(newValue.year, this.year);
      this.yearRange = bestval(newValue.yearRange, this.yearRange);
      this.runTime = bestval(newValue.runTime, this.runTime);
      this.type = bestval(newValue.type, this.type);
      this.censorRating = bestval(newValue.censorRating, this.censorRating);
      this.imageUrl = bestval(newValue.imageUrl, this.imageUrl);
      this.language = bestval(newValue.language, this.language);
      this.languages = bestList(newValue.languages, this.languages);
      this.genres = bestList(newValue.genres, this.genres);
      this.userRating = bestUserRating(
        newValue.userRating,
        newValue.userRatingCount,
        this.userRating,
        this.userRatingCount,
      );
      this.userRatingCount =
          bestval(newValue.userRatingCount, this.userRatingCount);
      mergeDtoMapMap(this.related, newValue.related);
    }
  }

  /// Combine related movie information from [existingDtos] into a [MovieResultDTO].
  ///
  void mergeDtoMapMap(Map<String, Map<String, MovieResultDTO>> existingDtos,
      Map<String, Map<String, MovieResultDTO>> newDtos) {
    for (var key in newDtos.keys) {
      if (!existingDtos.containsKey(key)) {
        // Create empty list to pass through to merge function.
        existingDtos[key] = {};
      }
      mergeDtoList(existingDtos[key]!, newDtos[key]!);
    }
  }

  /// Update [existingDtos] to also contain movies from [newDtos].
  ///
  void mergeDtoList(Map<String, MovieResultDTO> existingDtos,
      Map<String, MovieResultDTO> newDtos) {
    for (var dto in newDtos.entries) {
      if (existingDtos.keys.contains(dto.key)) {
        existingDtos[dto.key]!.merge(dto.value);
      } else {
        existingDtos[dto.key] = dto.value;
      }
    }
  }

  /// Compare [a] with [b] and return the most relevent value.
  ///
  /// [a] and [b] can be numbers, strings, durations, enums
  T bestval<T>(T a, T b) {
    if (a is MovieContentType && b is MovieContentType) bestType(a, b);
    if (a is CensorRatingType && b is CensorRatingType) bestCensorRating(a, b);
    if (a is DataSourceType && b is DataSourceType) bestSource(a, b);
    if (a is LanguageType && b is LanguageType) bestLanguage(a, b);
    if (a is num && b is num && a < b) return b;
    if (a is Duration && b is Duration && a < b) return b;
    if (a.toString().length < b.toString().length) return b;
    if (lastNumberFromString(a.toString()) < lastNumberFromString(b.toString()))
      return b;
    return a;
  }

  /// Combine [a] and [b] excluding duplicate entries from the result.
  ///
  List<String> bestList(List<String> a, List<String> b) {
    Set<String> result = {};
    result.addAll(a);
    result.addAll(b);

    return result.toList();
  }

  /// Compare [rating1] with [rating2] and return the most relevent value.
  ///
  /// The rating with the highest count is the best rating.
  double bestUserRating(
      double rating1, num count1, double rating2, num count2) {
    if (count1 > count2) return rating1;
    return rating2;
  }

  /// Compare [a] with [b] and return the most relevent value.
  ///
  MovieContentType bestType(MovieContentType a, MovieContentType b) {
    if (b.index > a.index) return b;
    return a;
  }

  /// Compare [a] with [b] and return the most relevent value.
  ///
  CensorRatingType bestCensorRating(CensorRatingType a, CensorRatingType b) {
    if (b.index > a.index) return b;
    return a;
  }

  /// Compare [a] with [b] and return the most relevent value.
  ///
  DataSourceType bestSource(DataSourceType a, DataSourceType b) {
    if (b == DataSourceType.imdb) return b;
    return a;
  }

  /// Compare [a] with [b] and return the most relevent value.
  ///
  LanguageType bestLanguage(LanguageType a, LanguageType b) {
    if (b.index > a.index) return b;
    return a;
  }

  /// Create a string representation of a [MovieResultDTO].
  ///
  String toPrintableString() {
    return this.toMap(excludeCopywritedData: false).toString();
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
    dto.related = related;
    return dto;
  }

  /// Test framework matcher to compare current [MovieResultDTO] to [other]
  ///
  /// Explains any difference found.
  bool matches(MovieResultDTO other) {
    if (this.title == other.title && this.title == 'unknown') return true;

    return this.source == other.source &&
        this.uniqueId == other.uniqueId &&
        this.alternateId == other.alternateId &&
        this.title == other.title &&
        this.alternateTitle == other.alternateTitle &&
        this.description == other.description &&
        this.type == other.type &&
        this.year == other.year &&
        this.yearRange == other.yearRange &&
        this.userRating == other.userRating &&
        this.censorRating == other.censorRating &&
        this.runTime == other.runTime &&
        this.language == other.language &&
        this.languages.toString() == other.languages.toString() &&
        this.genres.toString() == other.genres.toString() &&
        this.imageUrl == other.imageUrl;
    // TODO reinstate when toMovieResultDTO can convert text to related.
    // this.related.toPrintableString() == other.related.toPrintableString();
  }
}

extension IterableMovieResultDTOHelpers on Iterable<MovieResultDTO> {
  /// Create a string representation of a [List]<[MovieResultDTO]>.
  ///
  String toPrintableString() {
    String listContents = '';
    String separator = '';
    for (var key in this) {
      listContents += '$separator${key.toPrintableString()}';
      separator = ',\n';
    }
    return 'List<MovieResultDTO>(${this.length})[\n$listContents\n]';
  }

  /// Create a json encoded representation of a [List]<[MovieResultDTO]>.
  ///
  String toJson() {
    List<String> listContents = [];
    for (var key in this) {
      listContents.add(jsonEncode(key.toMap(excludeCopywritedData: false)));
    }
    return jsonEncode(listContents);
  }
}

extension StringMovieResultDTOHelpers on String {
  /// Decode a json encoded representation of a [List]<[MovieResultDTO]>.
  ///
  List<MovieResultDTO> jsonToList() {
    final List<MovieResultDTO> dtos = [];
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

extension mapMovieResultDTOHelpers on Map<dynamic, MovieResultDTO> {
  /// Create a string representation of a [Map]<[String],[MovieResultDTO]>.
  ///
  String toPrintableString() {
    String listContents = '';
    String separator = '';
    for (var key in keys) {
      listContents += '$separator${this[key]!.toPrintableString()}';
      separator = ',\n';
    }
    return 'List<MovieResultDTO>(${this.length})[\n$listContents\n]';
  }

  /// Create a short string representation of a [Map]<[dynamic],[MovieResultDTO]>.
  ///
  /// Output will be less than 1000 chars long, truncating if required.
  String toShortString() {
    String listContents = '';
    String separator = '';
    for (var key in keys) {
      listContents += '$separator${this[key]!.title}';
      separator = ',\n';
    }
    if (listContents.length > 1000) {
      listContents = listContents.substring(0, 500) + '...';
    }
    return listContents;
  }
}

extension MapMapMovieResultDTOHelpers
    on Map<dynamic, Map<dynamic, MovieResultDTO>> {
  /// Create a string representation of a Map<[dynamic], Map<[dynamic], [MovieResultDTO]>>>.
  ///
  String toPrintableString() {
    String listContents = '';
    String separator = '';
    for (var key in this.keys) {
      listContents +=
          '$separator${key.toString()}:${this[key]!.toPrintableString()}';
      separator = ',\n';
    }
    return '{$listContents}';
  }

  /// Create a short string representation of a Map<[dynamic], Map<[dynamic], [MovieResultDTO]>>>.
  ///
  String toShortString() {
    String listContents = '';
    String separator = '';
    for (var key in this.keys) {
      listContents +=
          '$separator${key.toString()}:${this[key]!.toShortString()}';
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
    if (this.uniqueId == movieResultDTOUninitialised &&
        other.uniqueId != movieResultDTOUninitialised) return -1;
    if (this.uniqueId != movieResultDTOUninitialised &&
        other.uniqueId == movieResultDTOUninitialised) return 1;
    // Preference people > movies.
    if (this.contentCategory() != other.contentCategory())
      return this.contentCategory().compareTo(other.contentCategory());
    // See how many people have rated this movie.
    if (this.userRatingCategory() != other.userRatingCategory())
      return this.userRatingCategory().compareTo(other.userRatingCategory());
    // Preference movies > series > short film > episodes.
    if (this.titleContentCategory() != other.titleContentCategory())
      return this
          .titleContentCategory()
          .compareTo(other.titleContentCategory());
    // Preference English > Foreign Language.
    if (this.language.index != other.language.index)
      return this.languageCategory().compareTo(other.languageCategory());
    // Rank older (less than 2000) and low rated movies lower.
    if (this.popularityCategory() != other.popularityCategory())
      return this.popularityCategory().compareTo(other.popularityCategory());
    // If all things are equal, sort by year.
    return this.yearCompare(other);
  }

  /// Rank movies based on popularity.
  ///
  /// 0-99, 100-9999, 10000+
  int userRatingCategory() {
    if (this.userRatingCount == 0) return 0;
    if (this.userRatingCount < 100) return 1;
    if (this.userRatingCount < 10000) return 2;
    return 3;
  }

  /// Rank movies based on type of content.
  ///
  /// movie > miniseries > tv series > short > series episode > game & unknown
  int titleContentCategory() {
    if (this.type == MovieContentType.none ||
        this.type == MovieContentType.custom) return 0;
    if (this.type == MovieContentType.episode) return 1;
    if (this.type == MovieContentType.short) return 2;
    if (this.type == MovieContentType.series) return 3;
    if (this.type == MovieContentType.miniseries) return 4;
    return 5;
  }

  /// Rank dto based on type (person Vs movie).
  ///
  /// person > movie
  int contentCategory() {
    if (this.type == MovieContentType.person) {
      return 1;
    }
    return 0;
  }

  /// Rank movies based on spoken language.
  ///
  /// English > mostly English > some English > no English > silent
  int languageCategory() {
    // Need to reverse the enum order for use with CompareTo().
    return this.language.index * -1;
  }

  /// Rank movies based on popular opinion.
  ///
  /// Any movie with a super low rating is probably not worth watching.
  /// A rating of 2 out of 5 is not great but better than nothing.
  /// Movies and series made before 2000 have a lower relevancy to today.
  int popularityCategory() {
    if (this.userRating < 2) return 0;
    if (this.maxYear() < 2000) return 1;
    return 2;
  }

  /// Rank movies based on year released.
  ///
  /// For series use year of most recent episode.
  int yearCompare(MovieResultDTO? other) {
    final thisYear = this.maxYear();
    final otherYear = other?.maxYear() ?? 0;
    return (thisYear.compareTo(otherYear));
  }

  /// Extract year release or year of most recent episode.
  ///
  int maxYear() {
    return max(this.year, this.yearRangeAsNumber());
  }

  /// Extract year of most recent episode.
  ///
  int yearRangeAsNumber() {
    return lastNumberFromString(this.yearRange);
  }

  /// Extract numeric digits from end of string.
  ///
  /// String can optionally end with a dash.
  int lastNumberFromString(String str) {
    // one or more numeric digits ([0-9]+)
    // followed by 0 or more dashes ([\-]*)
    var match = RegExp(r'([0-9]+)([\-]*)$').firstMatch(str);
    if (null != match) {
      if (null != match.group(1)) {
        return int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return 0;
  }
}
