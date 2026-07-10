import 'dart:convert';

import 'package:my_movie_search/movies/data/movie_result_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

extension FormatMovieResultDTOHelpers on MovieResultDTO {
  /// Create a string representation of a [MovieResultDTO].
  ///
  String toPrintableString() => toMap().toString();
}

extension IterableMovieResultDTOHelpers on Iterable<MovieResultDTO> {
  /// Create a string representation of a [List]<[MovieResultDTO]>.
  ///
  String toPrintableString() {
    final listContents = StringBuffer();
    var separator = '';
    for (final entry in this) {
      listContents.write('$separator${entry.toPrintableString()}');
      separator = ',\n';
    }
    return 'List<MovieResultDTO>($length)[\n$listContents\n]';
  }

  /// return a string containing valid json
  String toJsonString() {
    final listContents = StringBuffer();
    var separator = '';
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
    formatted = formatted.replaceAll('"related":{"', '\n  "related":{"');
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
    formatted = formatted.replaceAll(r'"links":"[\"', '\n      "links":"[\\"');
    formatted = formatted.replaceAll(
      '"description":"',
      '\n      "description":"',
    );
    formatted = formatted.replaceAll(
      '"userRating":"',
      '\n      "userRating":"',
    );
    formatted = formatted.replaceAll('}},"', '}},\n      "');
    formatted = formatted.replaceAll('}}},\n  ', '}}},\n');
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

extension MapMovieResultDTOHelpers on MovieCollection {
  /// Create a string representation of a `Map<String,MovieResultDTO>`.
  ///
  String toPrintableString() {
    final listContents = StringBuffer();
    var separator = '';
    for (final key in keys) {
      listContents.write('$separator${this[key]!.toPrintableString()}');
      separator = ',\n';
    }
    return 'List<MovieResultDTO>($length)[\n$listContents\n]';
  }

  /// Create a short string representation
  /// of a `Map<String,MovieResultDTO>`.
  ///
  /// Output will be less than 1000 chars long, truncating if required.
  String toShortString() {
    final listContents = StringBuffer();
    var separator = '';
    for (final key in keys) {
      listContents.write('$separator${this[key]!.title}');
      separator = ',\n';
    }
    if (listContents.length > 1000) {
      return '${listContents.toString().truncate(500)}...';
    }
    return listContents.toString();
  }
}

extension MapMapMovieResultDTOHelpers on RelatedMovieCategories {
  /// Create a string representation
  /// of a `Map<String, Map<String, MovieResultDTO>>`.
  ///
  String toPrintableString() {
    final listContents = StringBuffer();
    var separator = '';
    for (final key in keys) {
      listContents.write('$separator$key:${this[key]!.toPrintableString()}');
      separator = ',\n';
    }
    return '{$listContents}';
  }

  /// Create a short string representation
  /// of a `Map<String, Map<String, MovieResultDTO>>`.
  ///
  String toShortString() {
    final listContents = StringBuffer();
    var separator = '';
    for (final key in keys) {
      listContents.write('$separator$key:${this[key]!.toShortString()}');
      separator = ',\n';
    }
    return '$listContents';
  }
}
