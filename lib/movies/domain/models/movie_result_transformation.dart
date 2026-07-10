import 'package:html_unescape/html_unescape_small.dart';
import 'package:meta/meta.dart';
import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';
import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/enum.dart';
import 'package:my_movie_search/utilities/extensions/num_extensions.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';

extension TransformationMovieResultDTOHelpers on MovieResultDTO {
  static final _htmlDecode = HtmlUnescape();

  /// Create a MovieResultDTO with supplied data.
  ///
  MovieResultDTO init({
    DataSourceType bestSource = .none,
    String? uniqueId = movieDTOUninitialized,
    String? title = '',
    String? alternateTitle = '',
    String? characterName = '',
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
    String? links = '[]',
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
    this.characterName = characterName ?? '';
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
    this.links = dynamicToStringMap(links);

    // Enumerations, work with what we get
    this.type = MovieContentType.values.byFullName(type) ?? .none;
    this.censorRating =
        CensorRatingType.values.byFullName(censorRating) ?? .none;
    this.language =
        LanguageType.values.byFullName(language) ?? getLanguageType();

    if (this.type != .searchprompt && this.type != .episode) {
      this.type = bestValue(
        setMovieContentType(
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

  /// Reinitialise the source for a movie.
  ///
  void setSource({DataSourceType? newSource, String? newUniqueId}) {
    uniqueId = newUniqueId ?? uniqueId;

    if (newSource != null) {
      bestSource = newSource;
    }
    final readIndicator = getReadIndicator();

    sources.clear();
    sources[bestSource] = uniqueId;

    if (readIndicator != null) setReadIndicator(readIndicator);
  }

  /// Combine information from [newValue] into a [MovieResultDTO].
  ///
  void merge(MovieResultDTO newValue, {bool excludeRelated = false}) {
    // if (uniqueId == 'tt0405159') {
    //   // log before and after values
    //   AppLogger.instance.fatal(
    //     'Merging MovieResultDTO with uniqueId $uniqueId. ${this.type} / ${newValue.type}'
    //     '\n  This: ${this.toJson(includeRelated: false)}, \n  That: ${newValue.toJson(includeRelated: false)}',
    //   );
    // }

    if (newValue.userRatingCount >= userRatingCount ||
        0 == userRatingCount ||
        newValue.sources.containsKey(DataSourceType.imdb) ||
        newValue.sources.containsKey(DataSourceType.torrentDownloadDetail) ||
        newValue.sources.containsKey(DataSourceType.wikidataDetail)) {
      bestSource = bestValue(bestSource, newValue.bestSource);

      final oldTitle = title;
      if (newValue.bestSource == .imdb && '' != newValue.title) {
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
      description = bestValue(newValue.description, description);
      creditsOrder = bestValue(newValue.creditsOrder, creditsOrder);
      userRating = bestUserRating(
        newValue.userRating,
        newValue.userRatingCount,
        userRating,
        userRatingCount,
      );
      userRatingCount = bestValue(newValue.userRatingCount, userRatingCount);
    }
    characterName = bestValue(newValue.characterName, characterName);
    type = bestValue(newValue.type, type);
    year = bestValue(newValue.year, year);
    yearRange = bestValue(newValue.yearRange, yearRange);
    runTime = bestValue(newValue.runTime, runTime);
    type = bestValue(newValue.type, type);
    censorRating = bestValue(newValue.censorRating, censorRating);
    imageUrl = bestValue(newValue.imageUrl, imageUrl);

    type = bestValue(
      setMovieContentType(
            '$genres $yearRange',
            IntHelper.fromText(runTime),
            uniqueId,
          ) ??
          type,
      type,
    );
    genres.addAll(newValue.genres);
    keywords.addAll(newValue.keywords);
    links.addAll(newValue.links);
    sources.addAll(newValue.sources);
    languages.addAll(newValue.languages);
    getLanguageType();
    if (!excludeRelated) {
      mergeRelatedDtos(related, newValue.related);
    }

    // if (uniqueId == 'tt0405159') {
    //   // log before and after values
    //   AppLogger.instance.fatal(
    //     'Merging MovieResultDTO with uniqueId $uniqueId. ${this.type}'
    //     '\n  After: ${toJson(includeRelated: false)}',
    //   );
    // }
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

  /// Create a placeholder for a value that can not be easily represented
  /// as a [MovieResultDTO].
  ///
  @factory
  // Linter does not understand that toUnknown is a factory method.
  // ignore: invalid_factory_method_impl
  MovieResultDTO toUnknown() => MovieResultDTO()
    ..bestSource = bestSource
    ..uniqueId = uniqueId
    ..title = 'unknown'
    ..alternateTitle = alternateTitle
    ..characterName = characterName
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
    ..links = links
    ..sources = sources
    ..related = related;

  /// Compare [a] with [b] and return the most relevant value.
  ///
  /// [a] and [b] can be numbers, strings, durations, enums
  static T bestValue<T>(T a, T b) {
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
    if (a.toString().lastNumber() < b.toString().lastNumber()) {
      return b;
    }
    return a;
  }

  /// Compare [a] with [b] and return the most relevant value.
  ///
  /// The string with the longest length is the best string
  /// unless it ends in ...
  static String bestString(String a, String b) {
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
  static double bestUserRating(
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
  static MovieContentType bestType(
    MovieContentType existing,
    MovieContentType candidate,
  ) {
    if (candidate.index > existing.index) return candidate;
    return existing;
  }

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  static CensorRatingType bestCensorRating(
    CensorRatingType existing,
    CensorRatingType candidate,
  ) {
    if (candidate.index > existing.index) return candidate;
    return existing;
  }

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  static DataSourceType bestBestSource(
    DataSourceType existing,
    DataSourceType candidate,
  ) {
    if (candidate == .imdb) return candidate;
    return existing;
  }

  /// Compare [existing] with [candidate] and return the most relevant value.
  ///
  static LanguageType bestLanguage(
    LanguageType existing,
    LanguageType candidate,
  ) {
    if (candidate.index > existing.index) return candidate;
    return existing;
  }

  /// update title type based on information in the dto.
  MovieContentType getContentType() => type =
      setMovieContentType(
        yearRange,
        runTime.inSeconds,
        uniqueId,
        existing: type,
      ) ??
      type;

  /// Use movie type string to lookup [MovieContentType] movie type.
  static MovieContentType? setMovieContentType(
    Object? info,
    int? seconds,
    String id, {
    MovieContentType? existing,
  }) {
    final string = info?.toString() ?? '';
    final type = _lookupMovieContentType(
      string,
      seconds,
      id,
      existing: existing,
    );
    if (null != type || null == info) return type;
    return null;
  }

  /// Look at information provided
  /// to see if [MovieContentType] can be determined.
  ///
  /// info is in the form  ' (1988–1993) (TV Series)'
  static MovieContentType? _lookupMovieContentType(
    String info,
    int? seconds,
    String id, {
    MovieContentType? existing,
  }) {
    if (id.startsWith(imdbPersonPrefix)) return .person;
    if (id == movieDTOUninitialized) return .none;
    if (id.startsWith(movieDTOMessagePrefix)) return .error;
    final title = info.toLowerCase().replaceAll('sci-fi', '');
    if (title.lastIndexOf('game') > -1) return .custom;
    if (title.lastIndexOf('creativework') > -1) return .custom;
    if (title.lastIndexOf('music') > -1) return .custom;
    // mini includes TV Mini-series
    if (title.lastIndexOf('mini') > -1) return .miniseries;
    if (title.lastIndexOf('episode') > -1) return .episode;
    if (title.lastIndexOf('series') > -1) return .series;
    if (title.lastIndexOf('-') > -1) return .series;
    if (title.lastIndexOf('–') > -1) return .series;
    if (title.lastIndexOf('special') > -1) return .series;
    if (title.lastIndexOf('short') > -1) return .short;
    if (seconds != null && seconds < (30 * 60) && seconds > 0) {
      if (existing == .series) return .series;
      return .short;
    }
    if (seconds != null && seconds < (60 * 60) && seconds > 0) {
      if (existing == .series) return .series;
      return .episode;
    }
    if (title.lastIndexOf('movie') > -1) return .movie;
    if (title.lastIndexOf('video') > -1) return .movie;
    if (title.lastIndexOf('feature') > -1) return .movie;
    if (id.startsWith(imdbTitlePrefix)) {
      return bestType(existing ?? .title, .title);
    }
    return existing;
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
    links.clear();

    for (final category in related.keys) {
      for (final dto in related[category]!.values) {
        dto.clearCopyrightedData();
      }
    }
  }
}
