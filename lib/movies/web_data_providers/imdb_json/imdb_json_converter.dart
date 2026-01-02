import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_factory.dart';
import 'package:my_movie_search/utilities/extensions/collection_extensions.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

class ImdbJsonConverter extends ImdbConverterBase
    with
        ReleatedMoviesForPredefinedCategory,
        ReleatedPeopleForPredefinedCategory {
  @override
  /// Get basic details for the movie or person from [data].
  dynamic getMovieOrPerson(MovieResultDTO dto, Map<dynamic, dynamic> data) {
    if (data.containsKey(outerElementIdentity)) {
      // Used by QueryIMDBJson* and QueryIMDBSearch
      _shallowConvert(dto, data);
    } else {
      return [
        dto.error('Unable to interpret IMDB contents from data $data', source),
      ];
    }
  }

  void _shallowConvert(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie.setSource(
      newSource: map[dataSource],
      newUniqueId: map[outerElementIdentity]!.toString(),
    );
    if (movie.uniqueId.startsWith(imdbPersonPrefix)) {
      _shallowConvertPerson(movie, map);
    } else if (movie.uniqueId.startsWith(imdbTitlePrefix)) {
      _shallowConvertTitle(movie, map);
    }
  }

  void _shallowConvertPerson(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie.type = MovieContentType.person;
    final name = map[outerElementOfficialTitle] ?? map[deepPersonNameHeader];
    if (name != null && name is Map) {
      movie.title = name.searchForString() ?? movie.imageUrl;
    } else {
      movie.title = name?.toString() ?? movie.imageUrl;
    }
    final url = map[deepImageHeader] ?? map[outerElementImage];
    if (url != null && url is Map) {
      movie.imageUrl =
          url.searchForString(key: outerElementLink) ?? movie.imageUrl;
    } else {
      movie.imageUrl = url?.toString() ?? movie.imageUrl;
    }

    final credits =
        map.deepSearch(
          deepPersonRelatedSuffix, // '*Credits' e.g. releasedCredits
          suffixMatch: true,
          multipleMatch: true,
        ) ??
        [];
    final creditsV2 =
        map
            .deepSearch(
              deepPersonRelatedChunk,
              multipleMatch: true,
            ) // '*CreditV2'
            ?.deepSearch(
              deepRelatedMovieCollection,
              multipleMatch: true,
            ) // edges;
            ?.getGrandChildren() ??
        [];

    movie
      ..description =
          map[outerElementDescription]?.toString() ?? movie.description
      ..related = _getDeepPersonRelatedCategories([...creditsV2, ...credits]);

    combineMovies(
      movie.related,
      personRelatedActorLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonActorHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedActressLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonActressHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedDirectorLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonDirectorHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedProducerLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonProducerHeader]),
    );
    combineMovies(
      movie.related,
      personRelatedWriterLabel,
      _getDeepPersonRelatedMoviesForCategory(map[deepPersonWriterHeader]),
    );

    // Reintialise the source after setting the ID
    movie.setSource(newSource: source);
  }

  void _shallowConvertTitle(MovieResultDTO movie, Map<dynamic, dynamic> map) {
    movie
      ..type = MovieContentType.title
      ..title = map[outerElementOfficialTitle]?.toString() ?? movie.title
      ..alternateTitle =
          map[outerElementAlternateTitle]?.toString() ?? movie.alternateTitle;
    if (movie.title == movie.alternateTitle) {
      movie.alternateTitle = '';
    }
    movie
      ..description =
          map[outerElementDescription]?.toString() ?? movie.description
      ..imageUrl = map[outerElementImage]?.toString() ?? movie.imageUrl
      ..year = map[outerElementYear]?.toString().getYear() ?? movie.year
      ..yearRange = map[outerElementYearRange]?.toString() ?? movie.yearRange
      ..year = movie.maxYear()
      ..censorRating =
          getImdbCensorRating(map[outerElementCensorRating]?.toString()) ??
          movie.censorRating
      ..userRating =
          DoubleHelper.fromText(
            (map[outerElementRating] as Map?)?[innerElementRatingValue],
            nullValueSubstitute: movie.userRating,
          )!
      ..userRatingCount =
          IntHelper.fromText(
            (map[outerElementRating] as Map?)?[innerElementRatingCount],
            nullValueSubstitute: movie.userRatingCount,
          )!;

    final language = map[outerElementLanguage];
    if (language is LanguageType) {
      movie.language = language;
    }
    final movieType = map[outerElementType];
    if (movieType is MovieContentType) {
      movie.type = movieType;
    }

    try {
      movie.runTime = Duration.zero.fromIso8601(map[outerElementDuration]);
      // Make deserialisation robust against invalid data.
      // ignore: avoid_catching_errors
    } on ArgumentError catch (_) {}

    movie
      ..genres.combineUnique(map[outerElementGenre])
      ..keywords.combineUnique(map[outerElementKeywords])
      ..languages.combineUnique(map[outerElementLanguages])
      ..getLanguageType();

    for (final person in _getPeopleFromJson(map[outerElementDirector])) {
      movie.addRelated(titleRelatedDirectorsLabel, person);
    }
    for (final person in _getPeopleFromJson(map[outerElementActors])) {
      movie.addRelated(titleRelatedCastLabel, person);
    }
    //_getRelated(movie, map[outerElementActors], relatedActorsLabel);
    _getRelated(movie, map[outerElementRelated], titleRelatedMoviesLabel);

    final related = map[outerElementRelated];
    _getRelatedSections(related, movie);

    // Reinitialise the source after setting the ID
    movie.setSource(newSource: source);
  }

  void _getRelated(MovieResultDTO movie, dynamic related, String label) {
    void convertRelatedMapToDto(Map<dynamic, dynamic> related) {
      final converter = ImdbJsonConverterFactory().getConverter(related);
      for (final dto in converter.dtoFromCompleteJsonMap(related, source)) {
        movie.addRelated(label, dto);
      }
    }

    ConverterHelper().forEachMap(
      related,
      convertRelatedMapToDto,
      fallback: true,
    );
  }

  static List<MovieResultDTO> _getPeopleFromJson(dynamic people) {
    final result = <MovieResultDTO>[];
    void addPerson(Map<dynamic, dynamic> person) {
      final dto = _dtoFromPersonMap(person);
      if (dto != null) {
        result.add(dto);
      }
    }

    ConverterHelper().forEachMap(people, addPerson, fallback: true);
    return result;
  }

  static MovieResultDTO? _dtoFromPersonMap(Map<dynamic, dynamic> map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (map[outerElementType] != 'Person' || id == '') {
      return null;
    }
    return MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: map[outerElementOfficialTitle]?.toString(),
    );
  }

  static void _getRelatedSections(dynamic related, MovieResultDTO movie) {
    void processSection(Map<dynamic, dynamic> section) =>
        _getMovieCategories(section, movie);

    ConverterHelper().forEachMap(related, processSection, fallback: true);
  }

  static void _getMovieCategories(
    Map<dynamic, dynamic> related,
    MovieResultDTO movie,
  ) {
    for (final category in related.entries) {
      void getMovie(Map<dynamic, dynamic> movies) {
        final dto = _dtoFromRelatedMap(movies);
        if (null != dto) {
          movie.addRelated(category.key.toString(), dto);
        }
      }

      ConverterHelper().forEachMap(category, getMovie, fallback: true);
    }
  }

  static MovieResultDTO? _dtoFromRelatedMap(Map<dynamic, dynamic> map) {
    final id = getIdFromIMDBLink(map[outerElementLink]?.toString());
    if (id == '') {
      return null;
    }
    return MovieResultDTO().init(
      bestSource: DataSourceType.imdbSuggestions,
      uniqueId: id,
      title: map[outerElementOfficialTitle]?.toString(),
    );
  }

  /// Get the movie category information for a person.
  RelatedMovieCategories _getDeepPersonRelatedCategories(dynamic list) {
    final RelatedMovieCategories result = {};

    /// Search movie information to add to the movie collection.
    void getCategory(Map<dynamic, dynamic> item) {
      final movies = _getDeepPersonRelatedMoviesForCategory(item);
      final categories = ImdbConverterBase.getRolesFromCreditsV2(
        item.deepSearch(deepRelatedCategoryHeaderV2),
      );
      for (final category in categories) {
        ConverterHelper().combineMovies(
          result,
          category.addColonIfNeeded(),
          movies,
        );
      }
    }

    if (list is List) {
      for (final related in list) {
        ConverterHelper().forEachMap(related, getCategory, fallback: true);
      }
    }
    return result;
  }

  /// extract collections of movies for a specific category for the person
  /// from a map or a list.
  MovieCollection _getDeepPersonRelatedMoviesForCategory(dynamic category) {
    final MovieCollection result = {};

    void getRelated(Map<dynamic, dynamic> node) {
      final title = node.deepSearch(deepRelatedMovieHeader)?.first;
      final movieDto = getRelatedMovieCharacter(title, node);
      if (movieDto != null) {
        result[movieDto.uniqueId] = movieDto;
      }
    }

    // ...{'node':...}
    final nodes = TreeHelper(
      category,
    ).deepSearch(deepRelatedMovieContainer, multipleMatch: true);
    ConverterHelper().forEachMap(nodes, getRelated);
    return result;
  }
}
