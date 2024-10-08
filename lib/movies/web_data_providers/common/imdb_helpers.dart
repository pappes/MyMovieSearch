import 'dart:convert';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';

const dataSource = 'source';
const outerElementIdentity = 'id';
const outerElementSearchResults = 'searchResults';
const outerElementNameResults = 'nameResults';
const outerElementTitleResults = 'titleResults';
const outerElementDetailResults = 'data';

const outerElementOfficialTitle = 'name';
const outerElementAlternateTitle = 'alternateTitle';
const outerElementCharactorName = 'charactorName';
const outerElementDescription = 'description';
const outerElementKeywords = 'keywords';
const outerElementGenre = 'genre';
const outerElementYear = 'datePublished';
const outerElementYearRange = 'yearRange';
const outerElementDuration = 'duration';
const outerElementCensorRating = 'contentRating';
const outerElementRating = 'aggregateRating';
const innerElementRatingValue = 'ratingValue';
const innerElementRatingCount = 'ratingCount';
const outerElementType = '@type';
const outerElementImage = 'image';
const outerElementLanguage = 'language';
const outerElementLanguages = 'languages';
const outerElementRelated = 'related';
const outerElementActors = 'actor';
const outerElementDirector = 'director';
const outerElementLink = 'url';

const outerElementBorn = 'birthDate';
const outerElementDied = 'deathDate';

const imdbTitlePrefix = 'tt';
const imdbPersonPrefix = 'nm';
const imdbTitlePath = '/title/';
const imdbPersonPath = '/name/';

const imdbBaseURL = 'https://www.imdb.com';
const imdbMobileURL = 'https://m.imdb.com';
const imdbSuffixURL = '?ref_=nv_sr_srsg_0';
const imdbPhotosPath = 'mediaindex';
const imdbParentalPath = 'parentalguide';

// Fields common to person and title
// primaryImage can be repeated for related movies - use first instance only
const deepImageHeader = 'primaryImage';
const deepImageField = 'url';
const deepRelatedMovieContainer = 'node';
const deepRelatedHeader = 'mainColumnData';

// Fields exclusive to title
const deepTitleId1 = 'titleId';
const deepTitleId2 = 'tconst';
const deepTitleRelatedCastHeader = 'cast';
const deepTitleRelatedCastContainer = 'node';
const deepTitleRelatedDirectorHeader = 'directors';
const deepTitleRelatedDirectorContainer = 'name';
const deepTitleRelatedTitlesHeader = 'moreLikeThisTitles';
const deepTitleResults = 'titleListItems';

// Fields exclusive to person
const deepPersonId = 'nmconst';
// nameText can be repeated for related movies - use first instance only
const deepPersonNameHeader = 'nameText';
const deepPersonDescriptionHeader = 'bio';
const deepPersonDescriptionField = 'plainText';
const deepPersonStartDateHeader = 'birthDate';
const deepPersonStartDateField = 'year';
const deepPersonEndDateHeader = 'deathDate';
const deepPersonEndDateField = 'year';
const deepPersonPopularityHeader = 'meterRanking';
const deepPersonPopularityField = 'currentRank';
const deepPersonActorHeader = 'actor_credits';
const deepPersonActressHeader = 'actress_credits';
const deepPersonProducerHeader = 'producer_credits';
const deepPersonDirectorHeader = 'director_credits';
const deepPersonWriterHeader = 'writer_credits';

// Credits is repeated inside the category as "credits"
// so use case sensative compare
const deepPersonRelatedSuffix = 'Credits';
// category repeated inside the node
// source the first instance for the credits section
const deepRelatedCategoryHeader = 'category';
const deepRelatedMovieHeader = 'title';
// characters are same map depth as title
const deepRelatedMovieParentCharactorHeader = 'characters';
// name is same map depth as title
const deepRelatedMovieParentCharactorField = 'name';
// id is repeated inside other children of the title - do not do a deep search
const deepRelatedMovieId = 'id';
const deepRelatedMoviePlot = 'plot';
const deepRelatedMoviePlotHeader = 'plotText';
const deepRelatedMoviePlotField = 'plainText';
// originalTitleText, akas, titleText and titleType child key = text
const deepRelatedMovieOriginalTitle = 'originalTitleText';
const deepRelatedMovieAlternateTitle = 'akas';
const deepRelatedMovieTitle = 'titleText';
const deepRelatedMovieType = 'titleType';

const deepRelatedMovieUserRating = 'aggregateRating';
const deepRelatedMovieUserRatingCount = 'voteCount';
const deepRelatedMovieYearHeader = 'releaseYear';
const deepRelatedMovieYearStart = 'year';
const deepRelatedMovieYearEnd = 'endYear';
const deepRelatedMovieDurationHeader = 'runtime';
const deepRelatedMovieDURATIONHeader = 'runTime';
const deepRelatedMovieDurationField = 'seconds';
const deepRelatedMovieCensorRatingHeader = 'certificate';
const deepRelatedMovieCensorRatingField = 'rating';
const deepRelatedMovieGenreHeader = 'genres';
const deepRelatedMovieGenreField = 'text';
const deepRelatedMovieKeywordHeader = 'keywords';
const deepRelatedMovieKeywordField = 'text';
const deepRelatedMovieLanguageHeader = 'spokenLanguages';
const deepRelatedMovieLanguageField = 'text';

const deepRelatedPersonId = 'id';

const deepJsonResults = 'results';
const deepJsonResultsSuffix = 'Results';

/// Create a URL from the IMDB identifier.
///
/// ```dart
/// getIdFromIMDBLink('tt0145681');
/// //returns 'https://www.imdb.com/title/tt0145681/?ref_=nm_sims_nm_t_9'
/// ```
String makeImdbUrl(
  String key, {
  String path = '/',
  bool mobile = false,
  bool photos = false,
  bool parentalGuide = false,
}) {
  final url = StringBuffer()..write(mobile ? imdbMobileURL : imdbBaseURL);
  if (key.startsWith(imdbTitlePrefix)) {
    url.write(imdbTitlePath);
  }
  if (key.startsWith(imdbPersonPrefix)) {
    url.write(imdbPersonPath);
  }
  url.write(key + path);
  if (photos) {
    url.write(imdbPhotosPath);
  }
  if (parentalGuide) {
    url.write(imdbParentalPath);
  }
  url.write(imdbSuffixURL);
  return url.toString();
}

/// Extract the IMDB identifier from a URL.
///
/// ```dart
/// getIdFromIMDBLink('https://www.imdb.com/title/tt0145681/?ref_=nm_sims_nm_t_9');
/// //returns 'tt0145681'
/// ```

String getIdFromIMDBLink(String? link) {
  if (null == link || link.isEmpty) {
    return '';
  }

  const regexStartString = '^';
  const regexMultipleAlphaNumericUnderscore = '[a-zA-Z0-9_]*';
  const regexMultipleAnything = '.*';
  const regexEndString = r'$';

  // Convert /title/tt0145681/?ref_=nm_sims_nm_t_9 to tt0145681
  // Or      /title/tt0145681?ref_=nm_sims_nm_t_9 to tt0145681
  const titleRegexpFormula = '$regexStartString$imdbTitlePath'
      '($regexMultipleAlphaNumericUnderscore)'
      '$regexMultipleAnything$regexEndString';
  // Convert /name/nm0145681/?ref_=nm_sims_nm_t_9 to nm0145681
  // Or      /name/nm0145681?ref_=nm_sims_nm_t_9 to nm0145681
  const nameRegexpFormula = '$regexStartString$imdbPersonPath'
      '($regexMultipleAlphaNumericUnderscore)'
      '$regexMultipleAnything$regexEndString';

  // stuff(group1)stuff - only care about group 1 - regexMultipleNonSlash
  return _getRegexGroupInBrackets(link, titleRegexpFormula) ??
      _getRegexGroupInBrackets(link, nameRegexpFormula) ??
      '';
}

/// Converts human readable censor ratings
/// to [CensorRatingType] rating categories.
CensorRatingType? getImdbCensorRating(String? type) {
  // Details available at
  // https://help.imdb.com/article/contribution/titles/certificates/GU757M8ZJ9ZPXB39
  if (type == null) return null;
  if (type.lastIndexOf('Unrated') > -1) return CensorRatingType.none;
  if (type.lastIndexOf('Banned') > -1) return CensorRatingType.adult;
  if (type.lastIndexOf('X') > -1) return CensorRatingType.adult;
  if (type.lastIndexOf('R21') > -1) return CensorRatingType.adult;
  if (type.lastIndexOf('21') > -1) return CensorRatingType.adult;
  // Suitable for Only Adults
  if (type.lastIndexOf('SOA') > -1) return CensorRatingType.adult;

  if (type.lastIndexOf('Z') > -1) return CensorRatingType.restricted;
  if (type.lastIndexOf('Mature') > -1) return CensorRatingType.restricted;
  if (type.lastIndexOf('Adult') > -1) return CensorRatingType.restricted;
  if (type.lastIndexOf('GA') > -1) return CensorRatingType.restricted;
  //18 includes 18, R18, M18, RP18, 18+, VM18
  if (type.lastIndexOf('18') > -1) return CensorRatingType.restricted;
  if (type.lastIndexOf('19') > -1) return CensorRatingType.restricted;
  if (type.lastIndexOf('17') > -1) return CensorRatingType.restricted; //NC-17

  // 16 includes 16, NC16, R16, RP16, VM 16
  if (type.lastIndexOf('16') > -1) return CensorRatingType.mature;
  // 15 includes 15+, B15, R15+, 15A, 15PG
  if (type.lastIndexOf('15') > -1) return CensorRatingType.mature;
  if (type.lastIndexOf('14') > -1) return CensorRatingType.mature; // 14+, VM14
  if (type.lastIndexOf('GY') > -1) return CensorRatingType.mature;
  if (type.lastIndexOf('D') > -1) return CensorRatingType.mature;
  if (type.lastIndexOf('LH') > -1) return CensorRatingType.mature;

  if (type.lastIndexOf('Approved') > -1) return CensorRatingType.family;
  // 13 includes PG-13, 13+, R13, RP13
  if (type.lastIndexOf('13') > -1) return CensorRatingType.family;
  // 12 includes 12+, 12A, PG12, 12A, 12PG
  if (type.lastIndexOf('12') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('11') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('10') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('9') > -1) return CensorRatingType.family; // 9+
  if (type.lastIndexOf('8') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('Teen') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('TE') > -1) return CensorRatingType.family;
  if (type.lastIndexOf('7') > -1) return CensorRatingType.family; // 7+
  if (type.lastIndexOf('6') > -1) return CensorRatingType.family; // 6+
  if (type.lastIndexOf('S') > -1) return CensorRatingType.family;
  // G includes G, PG, PG-13
  if (type.lastIndexOf('G') > -1) return CensorRatingType.family;

  if (type.lastIndexOf('C') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('Y') > -1) return CensorRatingType.kids; //TV-Y
  if (type.lastIndexOf('U') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('Btl') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('TP') > -1) return CensorRatingType.kids;
  if (type.lastIndexOf('0') > -1) return CensorRatingType.kids; // 0+

  //R includes R, R(A), RP18
  if (type.lastIndexOf('R') > -1) return CensorRatingType.restricted;
  // M includes M, MA, TV-MA
  if (type.lastIndexOf('M') > -1) return CensorRatingType.mature;

  // A includes A, All, AL, AA
  if (type.lastIndexOf('A') > -1) return CensorRatingType.kids;

  if (type.lastIndexOf('T') > -1) return CensorRatingType.family; // T
  if (type.lastIndexOf('B') > -1) return CensorRatingType.family;

  return CensorRatingType.none;
}

/// Strip image size information from an imdb url.
///
/// ```dart
/// getBigImage('https://m.media-amazon.com/images/M/MV5BODQxYWM2ODItYjE4ZC00YzAxLTljZDQtMjRjMmE0ZGMwYzZjXkEyXkFqcGdeQXVyODIyOTEyMzY@._V1_UY268_CR9,0,182,268_AL_.jpg');
/// // strips out '._V1_UY268_CR9,0,182,268_AL_'
/// // returns https://m.media-amazon.com/images/M/MV5BODQxYWM2ODItYjE4ZC00YzAxLTljZDQtMjRjMmE0ZGMwYzZjXkEyXkFqcGdeQXVyODIyOTEyMzY@.jpg
/// ```
String getBigImage(String? smallImage) {
  if (null != smallImage &&
      smallImage.startsWith('https://m.media-amazon.com/images')) {
    // http followed by zero or more of anything "(http.*)""
    // followed by a period then multiple non periods "\.[^.]*""
    // followed by file extension including one more period "\.jpg"

    const regexStartString = '^';
    const regexBeforeLastFulStop = 'http.*';
    const regexLastFulStopOnwards = r'\.[^.]*';
    const regexFileExtension = r'\.jpg';
    const regexEndString = r'$';

    const imageRegexpFormula = '$regexStartString'
        '($regexBeforeLastFulStop)'
        '$regexLastFulStopOnwards$regexFileExtension$regexEndString';
    var truncated = _getRegexGroupInBrackets(smallImage, imageRegexpFormula);
    if (null != truncated) {
      truncated = '$truncated.jpg';
    }
    final result = Uri.decodeFull(truncated ?? smallImage);
    return result;
  }
  return smallImage ?? '';
}

String? _getRegexGroupInBrackets(String stringToSearch, String regexFormula) {
  final match = RegExp(regexFormula).firstMatch(stringToSearch);
  if (null != match) {
    if (null != match.group(1)) {
      return match.group(1);
    }
  }
  return null;
}

/// Use text searching on raw imdb HTML to extract json content.
///
/// Bypasses the need to perform a large html parse operation
/// and an expensive querySelector operation.
List<dynamic> fastParse(String webText) {
  final startTag = webText.indexOf('{"props":{"pageProps":{');
  if (-1 != startTag) {
    final endTag = webText.indexOf('</script>', startTag);
    if (-1 != endTag) {
      // Assume text is json encoded.
      final json = webText.substring(startTag, endTag);
      try {
        final tree = jsonDecode(json);
        return [tree];
      } on FormatException {
        throw FastParseException('Json decode failed!');
      }
    }
  }
  throw FastParseException('Fast parse unsuccessful, try a slow parse!');
}

class FastParseException implements Exception {
  FastParseException(this.cause);
  String cause;

  @override
  String toString() => cause;
}
