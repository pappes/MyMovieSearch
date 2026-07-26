import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:my_movie_search/data/persistence/dto_cache.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_comparison.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';

extension MovieResultDTOMapper on MovieResultDTO {
  /// Convert a json [String] to a [MovieResultDTO].
  ///
  @factory
  MovieResultDTO fromJson(Object? json) {
    if (json != null) {
      final decoded = jsonDecode(json.toString());
      if (decoded is Map) return decoded.toMovieResultDTO();
    }
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
    int? relatedSampleQuantity,
    bool condensed = false,
    bool flattenRelated = false,
  }) {
    final result = <String, Object>{};
    final defaultValues = MovieResultDTO();
    result[movieDTOUniqueId] = uniqueId;
    if (title != defaultValues.title) result[movieDTOTitle] = title;
    if (description != defaultValues.description) {
      result[movieDTODescription] = description;
    }
    if (alternateTitle != defaultValues.alternateTitle) {
      result[movieDTOAlternateTitle] = alternateTitle;
    }
    if (!condensed) {
      if (bestSource != defaultValues.bestSource) {
        result[movieDTOBestSource] = bestSource.toString();
      }
      if (characterName != defaultValues.characterName) {
        result[movieDTOCharacterName] = characterName;
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
      if (links != defaultValues.links && links.isNotEmpty) {
        result[movieDTOLinks] = json.encode(links);
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
        toMapRelated(
          relatedMap,
          flattenRelated: flattenRelated,
          relatedSampleQuantity: relatedSampleQuantity,
        );
        result[movieDTORelated] = relatedMap;
      }
    }
    return result;
  }

  void toMapRelated(
    Map<String, Object> relatedMap, {
    bool flattenRelated = false,
    int? relatedSampleQuantity,
  }) {
    // Progressivly add related movies to the map.
    for (final category in related.entries) {
      var relatedCount = 0;
      if (flattenRelated) {
        // Present related values as a List.
        final movies = <Map<String, Object>>[];
        for (final dto in category.value.entries) {
          final movieMap = dto.value.toMap();
          movies.add(movieMap);
          relatedCount++;
          if (relatedSampleQuantity != null &&
              relatedCount >= relatedSampleQuantity) {
            break;
          }
        }
        relatedMap[category.key] = movies;
      } else {
        // Present related values as a Map.
        final movies = <String, Object>{};
        for (final dto in category.value.entries) {
          final movieMap = dto.value.toMap();
          movies[dto.value.uniqueId] = movieMap;
          relatedCount++;
          if (relatedSampleQuantity != null &&
              relatedCount >= relatedSampleQuantity) {
            break;
          }
        }
        relatedMap[category.key] = movies;
      }
    }
  }

  MovieResultDTO inflate() =>
      DtoCache.singleton().fetchSynchronously(uniqueId) ?? this;

  @factory
  // Linter does not understand that clone is a factory method.
  // ignore: invalid_factory_method_impl
  MovieResultDTO clone({bool condensed = false}) =>
      toMap(condensed: condensed).toMovieResultDTO();
}

extension ListDTOConversion on Iterable<MovieResultDTO> {
  /// Convert a [List] of json encoded [String]s
  /// into a [List] of [MovieResultDTO] objects
  ///
  @factory
  // Linter does not understand that decodeList is a factory method.
  // ignore: invalid_factory_method_impl
  static List<MovieResultDTO> decodeList(Iterable<Object?> encoded) {
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
  List<MovieResultDTO> shallowCopy() {
    final newList = <MovieResultDTO>[];
    forEach(newList.add);
    return newList;
  }
}

extension MapResultDTOConversion on Map<Object?, Object?> {
  /// Convert a `Map` into a `MovieResultDTO` object
  ///
  @factory
  // Linter does not understand that toMovieResultDTO is a factory method.
  // ignore: invalid_factory_method_impl
  MovieResultDTO toMovieResultDTO() {
    final dto = MovieResultDTO()
      ..uniqueId = dynamicToString(this[movieDTOUniqueId])
      ..title = dynamicToString(this[movieDTOTitle])
      ..alternateTitle = dynamicToString(this[movieDTOAlternateTitle])
      ..characterName = dynamicToString(this[movieDTOCharacterName])
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
      ..links = dynamicToStringMap(this[movieDTOLinks])
      ..related = stringToRelated(this[movieDTORelated]);

    dto
      ..bestSource =
          DataSourceType.values.byFullName(this[movieDTOBestSource]) ??
          dto.bestSource
      ..type =
          MovieContentType.values.byFullName(this[movieDTOType]) ?? dto.type
      ..censorRating =
          CensorRatingType.values.byFullName(this[movieDTOCensorRating]) ??
          dto.censorRating
      ..language =
          LanguageType.values.byFullName(this[movieDTOLanguage]) ?? dto.language
      ..sources = stringToSources(this[movieDTOSources]);
    if (!dto.sources.containsKey(dto.bestSource) && !dto.isMessage()) {
      dto.sources[dto.bestSource] = dto.uniqueId;
    }
    return dto;
  }

  /// Convert json encoded `Map<String, String>`
  /// to `Map<DataSourceType,String>`.
  ///
  /// Discards anything that cannot be converted.
  MovieSources stringToSources(Object? input) {
    final MovieSources sources = {};
    if (input is Map) {
      for (final sourceEntry in input.entries) {
        final value = sourceEntry.value;
        if (sourceEntry.key is String && value is String) {
          final sourceEnum = DataSourceType.values.byFullName(sourceEntry.key);
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
  RelatedMovieCategories stringToRelated(Object? categories) {
    final RelatedMovieCategories related = {};
    if (categories is Map) {
      // Find the categories that movie are collected under
      // e.g. "director", "writer", etc
      for (final category in categories.entries) {
        if (category.value is Map || category.value is Iterable) {
          final categoryText = category.key.toString();
          final categoryContents = category.value;

          // Convert the contents of the category to a list.
          Iterable<Object?> movieList = [];
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
