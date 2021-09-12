import 'dart:convert';
import 'dart:math' show max;

import 'package:flutter/material.dart';
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
final String movieResultDTOSource = 'source';
final String movieResultDTOUniqueId = 'uniqueId';
final String movieResultDTOAlternateId = 'alternateId';
final String movieResultDTOTitle = 'title';
final String movieResultDTOAlternateTitle = 'alternateTitle';
final String movieResultDTODescription = 'description';
final String movieResultDTOType = 'type';
final String movieResultDTOYear = 'year';
final String movieResultDTOYearRange = 'yearRange';
final String movieResultDTOUserRating = 'userRating';
final String movieResultDTOUserRatingCount = 'userRatingCount';
final String movieResultDTOCensorRating = 'censorRating';
final String movieResultDTORunTime = 'runTime';
final String movieResultImageUrl = 'imageUrl';
final String movieResultLanguage = 'language';
final String movieResultRelated = 'related';
final String movieResultDTOUninitialised = '-1';
final String movieResultDTOMessagePrefix = '-';

class RestorableMovie extends RestorableValue<MovieResultDTO> {
  @override
  MovieResultDTO createDefaultValue() => MovieResultDTO();

  @override
  void didUpdateValue(MovieResultDTO? oldValue) {
    if (oldValue == null || !oldValue.matches(value)) {
      notifyListeners();
    }
  }

  @override
  MovieResultDTO fromPrimitives(Object? data) {
    if (data != null) {
      Map<String, String> map = jsonDecode(data as String);
      return map.toMovieResultDTO();
    }
    return MovieResultDTO();
  }

  @override
  Object toPrimitives() =>
      jsonEncode(value.toMap(excludeCopywritedData: false));
}

class RestorableMovieList extends RestorableValue<List<MovieResultDTO>> {
  @override
  List<MovieResultDTO> createDefaultValue() => [];

  @override
  void didUpdateValue(List<MovieResultDTO>? oldValue) {
    if (oldValue == null ||
        oldValue.toPrintableString() != value.toPrintableString()) {
      notifyListeners();
    }
  }

  @override
  List<MovieResultDTO> fromPrimitives(Object? data) {
    if (data != null) {
      List<String> list = jsonDecode(data as String);
      return value.decodeList(list);
    }
    return [];
  }

  @override
  Object toPrimitives() => jsonEncode(value.encodeList());
}

extension ListDTOConversion on List<MovieResultDTO> {
  List<MovieResultDTO> decodeList(List<String> encoded) {
    List<MovieResultDTO> retval = [];
    for (var json in encoded) {
      retval.add(jsonDecode(json));
    }
    return retval;
  }

  List<String> encodeList() {
    List<String> retval = [];
    for (var dto in this) {
      retval.add(jsonEncode(dto.toMap(excludeCopywritedData: false)));
    }
    return retval;
  }
}

extension MapDTOConversion on Map<String, String> {
  MovieResultDTO toMovieResultDTO() {
    var dto = MovieResultDTO();
    dto.source =
        getEnumFromString(this[movieResultDTOSource], DataSourceType.values) ??
            dto.source;
    dto.uniqueId = this[movieResultDTOUniqueId] ?? dto.uniqueId;
    dto.alternateId = this[movieResultDTOAlternateId] ?? dto.alternateId;
    dto.title = this[movieResultDTOTitle] ?? dto.title;
    dto.alternateTitle =
        this[movieResultDTOAlternateTitle] ?? dto.alternateTitle;

    dto.description = this[movieResultDTODescription] ?? dto.description;
    dto.type =
        getEnumFromString(this[movieResultDTOType], MovieContentType.values) ??
            dto.type;
    dto.year = int.tryParse(this[movieResultDTOYear] ?? '') ?? dto.year;
    dto.yearRange = this[movieResultDTOYearRange] ?? dto.yearRange;
    dto.userRating =
        double.tryParse(this[movieResultDTOUserRating] ?? '') ?? dto.userRating;
    dto.userRatingCount =
        int.tryParse(this[movieResultDTOUserRatingCount] ?? '') ??
            dto.userRatingCount;
    dto.censorRating = getEnumFromString(
            this[movieResultDTOCensorRating], CensorRatingType.values) ??
        dto.censorRating;
    int? seconds = int.tryParse(this[movieResultDTORunTime] ?? '');
    dto.runTime = seconds != null ? Duration(seconds: seconds) : dto.runTime;
    dto.imageUrl = this[movieResultImageUrl] ?? dto.imageUrl;
    dto.language =
        getEnumFromString(this[movieResultLanguage], LanguageType.values) ??
            dto.language;
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

  Map<String, dynamic> toMap({bool excludeCopywritedData = true}) {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source.toString();
    map[movieResultDTOUniqueId] = this.uniqueId;
    if ('' != this.alternateId)
      map[movieResultDTOAlternateId] = this.alternateId;
    if ('' != this.title) map[movieResultDTOTitle] = this.title;
    if ('' != this.alternateTitle)
      map[movieResultDTOAlternateTitle] = this.alternateTitle;

    map[movieResultDTOType] = this.type.toString();
    if ('' != this.year) map[movieResultDTOYear] = this.year;
    if ('' != this.yearRange) map[movieResultDTOYearRange] = this.yearRange;
    if (0 != this.runTime.inSeconds)
      map[movieResultDTORunTime] = this.runTime.inSeconds;
    map[movieResultLanguage] = this.language.toString();

    if (!excludeCopywritedData) {
      if ('' != this.description)
        map[movieResultDTODescription] = this.description;
      if (0 != this.userRating) map[movieResultDTOUserRating] = this.userRating;
      if (0 != this.userRatingCount)
        map[movieResultDTOUserRatingCount] = this.userRatingCount;
      map[movieResultDTOCensorRating] = this.censorRating.toString();
      if ('' != this.imageUrl) map[movieResultImageUrl] = this.imageUrl;
    }
    //TODO: related
    Map<String, String> related = {};
    this.related.forEach((key, childMap) => // Get comma delimted uniqueIds
        related[key] = (childMap).keys.toString());
    map[movieResultRelated] = related;
    return map;
  }

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

  void merge(MovieResultDTO newValue) {
    if (newValue.description != '') {
      print(newValue.description);
    }
    if (DataSourceType.imdb == newValue.source) {
      print(newValue.description);
    }
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

  double bestUserRating(
      double rating1, num count1, double rating2, num count2) {
    if (count1 > count2) return rating1;
    return rating2;
  }

  MovieContentType bestType(MovieContentType a, MovieContentType b) {
    if (b.index > a.index) return b;
    return a;
  }

  CensorRatingType bestCensorRating(CensorRatingType a, CensorRatingType b) {
    if (b.index > a.index) return b;
    return a;
  }

  DataSourceType bestSource(DataSourceType a, DataSourceType b) {
    if (b == DataSourceType.imdb) return b;
    return a;
  }

  LanguageType bestLanguage(LanguageType a, LanguageType b) {
    if (b.index > a.index) return b;
    return a;
  }

  String toPrintableString() {
    return this.toMap(excludeCopywritedData: false).toString();
  }

  Map toUnknown() {
    Map<String, dynamic> map = Map();
    map[movieResultDTOSource] = this.source;
    map[movieResultDTOUniqueId] = this.uniqueId;
    map[movieResultDTOAlternateId] = this.alternateId;
    map[movieResultDTOTitle] = 'unknown';
    map[movieResultDTOAlternateTitle] = this.alternateTitle;

    map[movieResultDTODescription] = this.description;
    map[movieResultDTOType] = this.type;
    map[movieResultDTOYear] = this.year;
    map[movieResultDTOYearRange] = this.yearRange;
    map[movieResultDTOUserRating] = this.userRating;
    map[movieResultDTOUserRatingCount] = this.userRatingCount;
    map[movieResultDTOCensorRating] = this.censorRating;
    map[movieResultDTORunTime] = this.runTime;
    map[movieResultImageUrl] = this.imageUrl;
    map[movieResultLanguage] = this.language;
    map[movieResultRelated] = this.related;
    return map;
  }

  bool matches(MovieResultDTO other) {
    if (this.title == other.title && this.title == 'unknown') return true;

    if (this.source != other.source)
      print('source mismatch left(${this.source}) right (${other.source})');
    if (this.uniqueId != other.uniqueId)
      print(
          'uniqueId mismatch left(${this.uniqueId}) right (${other.uniqueId})');
    if (this.alternateId != other.alternateId)
      print(
          'alternateId mismatch left(${this.alternateId}) right (${other.alternateId})');
    if (this.title != other.title)
      print('title mismatch left(${this.title}) right (${other.title})');
    if (this.alternateTitle != other.alternateTitle)
      print(
          'alternateTitle mismatch left(${this.alternateTitle}) right (${other.alternateTitle})');
    if (this.description != other.description)
      print(
          'description mismatch left(${this.description}) right (${other.description})');
    if (this.type != other.type)
      print('type mismatch left(${this.type}) right (${other.type})');
    if (this.year != other.year)
      print('year mismatch left(${this.year}) right (${other.year})');
    if (this.yearRange != other.yearRange)
      print(
          'yearRange mismatch left(${this.yearRange}) right (${other.yearRange})');
    if (this.userRating != other.userRating)
      print(
          'userRating mismatch left(${this.userRating}) right (${other.userRating})');
    if (this.censorRating != other.censorRating)
      print(
          'censorRating mismatch left(${this.censorRating}) right (${other.censorRating})');
    if (this.runTime != other.runTime)
      print('runTime mismatch left(${this.runTime}) right (${other.runTime})');
    if (this.language != other.language)
      print(
          'language mismatch left(${this.language}) right (${other.language})');
    if (this.imageUrl != other.imageUrl)
      print(
          'imageUrl mismatch left(${this.imageUrl}) right (${other.imageUrl})');
    if (this.related.toPrintableString() != other.related.toPrintableString())
      print(
          'related mismatch left(${this.related.toPrintableString()}) right (${other.related.toPrintableString()})');

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
        this.imageUrl == other.imageUrl;
    // TODO reinstate when toMovieResultDTO can convert text to related.
    // this.related.toPrintableString() == other.related.toPrintableString();
  }
}

extension ListMovieResultDTOHelpers on List<MovieResultDTO> {
  String toPrintableString() {
    String listContents = '';
    String separator = '';
    for (var key in this) {
      listContents += '$separator${key.toPrintableString()}';
      separator = ',\n';
    }
    return 'List<MovieResultDTO>(${this.length})[\n$listContents\n]';
  }

  String toJson() {
    List<String> listContents = [];
    for (var key in this) {
      listContents.add(jsonEncode(key.toMap(excludeCopywritedData: false)));
    }
    return jsonEncode(listContents);
  }
}

extension StringMovieResultDTOHelpers on String {
  List<MovieResultDTO> jsonToList() {
    List<String> listContents = jsonDecode(this);
    List<MovieResultDTO> dtos = [];
    for (String json in listContents) {
      Map<String, String> map = jsonDecode(json);
      dtos.add(map.toMovieResultDTO());
    }
    return dtos;
  }
}

extension mapMovieResultDTOHelpers on Map<String, MovieResultDTO> {
  String toPrintableString() {
    String listContents = '';
    String separator = '';
    for (var key in keys) {
      listContents += '$separator${this[key]!.toPrintableString()}';
      separator = ',\n';
    }
    return 'List<MovieResultDTO>(${this.length})[\n$listContents\n]';
  }

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
    on Map<String, Map<String, MovieResultDTO>> {
  String toPrintableString() {
    String listContents = '';
    String separator = '';
    for (var key in this.keys) {
      listContents += '$separator$key:${this[key]!.toPrintableString()}';
      separator = ',\n';
    }
    return '{$listContents}';
  }

  String toShortString() {
    String listContents = '';
    String separator = '';
    for (var key in this.keys) {
      listContents += '$separator$key:${this[key]!.toShortString()}';
      separator = ',\n';
    }
    return '$listContents';
  }
}

extension DTOCompare on MovieResultDTO {
  //Rank movies against each other for sorting
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

  int userRatingCategory() {
    if (this.userRatingCount == 0) return 0;
    if (this.userRatingCount < 100) return 1;
    if (this.userRatingCount < 10000) return 2;
    return 3;
  }

  int titleContentCategory() {
    if (this.type == MovieContentType.none ||
        this.type == MovieContentType.custom) return 0;
    if (this.type == MovieContentType.episode) return 1;
    if (this.type == MovieContentType.short) return 2;
    if (this.type == MovieContentType.series) return 3;
    if (this.type == MovieContentType.miniseries) return 4;
    return 5;
  }

  int contentCategory() {
    if (this.type == MovieContentType.person) {
      return 1;
    }
    return 0;
  }

  int languageCategory() {
    // Need to reverse the enum order for use with CompareTo().
    return this.language.index * -1;
  }

  int popularityCategory() {
    // Any movie with a super low rating is probably not worth watching.
    // A rating of 2 out of 5 is not great but better than nothing.
    if (this.userRating < 2) return 0;
    // Movies and series made before 2000 have a lower relevancy to today.
    if (this.maxYear() < 2000) return 1;
    return 2;
  }

  int yearCompare(MovieResultDTO? other) {
    final thisYear = this.maxYear();
    final otherYear = other?.maxYear() ?? 0;
    return (thisYear.compareTo(otherYear));
  }

  int maxYear() {
    return max(this.year, this.yearRangeAsNumber());
  }

  int yearRangeAsNumber() {
    return lastNumberFromString(this.yearRange);
  }

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
