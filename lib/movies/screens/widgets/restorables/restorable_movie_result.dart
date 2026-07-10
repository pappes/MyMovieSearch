import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:my_movie_search/data/persistence/dto_cache.dart';
import 'package:my_movie_search/movies/data/movie_result_mappers.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_formatting.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_transformation.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/restorables/restorable_search_criteria.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';

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

  static Map<String, Object?> _getMap(GoRouterState state) {
    final criteria = state.extra;
    if (criteria != null && criteria is Map<String, Object?>) return criteria;
    return {};
  }

  static Map<String, Object> routeState(MovieResultDTO dto) {
    DtoCache.singleton().merge(dto);
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
    final criteriaDto = RestorableSearchCriteria.getDto(state);
    if (criteriaDto.criteriaList.length == 1) {
      return criteriaDto.criteriaList[0];
    }
    return criteriaDto.criteriaContext ?? MovieResultDTO();
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
  // Linter does not understand that fromPrimitives is a factory method.
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
  static Object dtoToPrimitives(MovieResultDTO dto) =>
      jsonEncode({'dto': dto.uniqueId, 'nextId': '${nextId + 1}'})..observe();
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
  // Linter does not understand that fromPrimitives is a factory method.
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
      jsonEncode(list.encodeList())..observe();
}
