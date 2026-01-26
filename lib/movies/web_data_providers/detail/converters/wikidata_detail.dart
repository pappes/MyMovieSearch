import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/xxdb_common.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

const languageEnglish = 'en';
const linkEnglish = 'enwiki';

const nodeMultipleResults = 'results';
const nodeMultipleResultCollection = 'bindings';
const nodeSingleResult = 'entities';
const nodeType = 'type';
const nodeName = 'labels';
const nodeDescription = 'descriptions';
const nodeWikiLinks = 'sitelinks';
const nodeExternalLinks = 'claims';
const nodeRottentomatoes = 'P1258';
const nodeImdb = 'P345';
const nodeFacebook = 'P2013';
const nodeOfficialWebsite = 'P856';

const multipleTypeId = 'typeQIDs';
const multipleName = 'movieName';
const multipleDescription = 'description';
const multipleRuntime = 'runtime';
const multipleIMDB = 'movieIMDB';

const typeMovie = 'Q11424'; // Film
const typeTV = 'Q506240'; // TV Movie
const typeSilent = 'Q226730'; // Silent Film
const typeDirect = 'Q120243801'; //-to-Video
const typeSpecial = 'Q4414442'; // TV Special
const typeDoc = 'Q93204'; // Documentary
const typeMiniseries = 'Q125922'; // Miniseries
const typeAnimated = 'Q11073'; // Animated Film
const typeAnimatedSeries = 'Q581714'; // Animated Series
const typeSoapOpera = 'Q474441'; // Soap Opera
const typeSeries = 'Q5398426'; // TV Series
const typeEpisode = 'Q19830628'; // TV Episode
const typeWebSeries = 'Q2031124'; // Series
const typeMusicVideo = 'Q193916'; // Music Video
const typePlay = 'Q40446'; // Play
const typeConcert = 'Q120243801'; // Film
const typeMusical = 'Q2743'; // Musical
const typeOpera = 'Q1344'; // Opera
const typeShort = 'Q24862'; // Short Film
const typeVideoGame = 'Q7889'; // Video Game

const nodeText = 'value';
const nodeUrl = 'url';

const linkStatus = 'rank';
const linkInactive = 'deprecated';
const linkActive = 'normal';

const sourceEntry = 'sourceName';

const wikiNotFound = 'No matching data found';

const nameField = 'sourceName';
const idField = 'id';
const imdbIdField = 'movieIMDB';

const sourceImdb = 'IMDB';
const sourceTvdb = 'TheMovieDB.com';

const tvdbSourceToEnumMapping = {
  'P345': XxdbSource.imdb,
  'P4947': XxdbSource.tvdb,
  'P2704': XxdbSource.eidr,
  'P2003': XxdbSource.instagram,
  'P1874': XxdbSource.netflix,
  'P856': XxdbSource.officialWebsite,
  'P2013': XxdbSource.facebook,
  'P1258': XxdbSource.rottenTomatoes,
  //'Reddit': XxdbSource.reddit,
  'P8600': XxdbSource.tvMaze,
  //'Wikidata': XxdbSource.wikidata,
  XxdbSource.wikipedia: XxdbSource.wikipedia,
  'P2002': XxdbSource.twitter,
};

class WikidataDetailConverter {
  String? imdbId;
  String? failureMessage;
  final dataSource = DataSourceType.wikidataDetail;
  late String dataSourceName = 'WikidataDetailConverter';

  List<MovieResultDTO> dtoFromCompleteJsonMap(Map<dynamic, dynamic> map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];
    final resultData = <dynamic, dynamic>{};
    dataSourceName = dataSource.name; //datasource

    final singleResult = map[nodeSingleResult];
    if (singleResult != null) {
      final resultType = parseSingleResultTypeAndData(map, resultData);
      if (resultType == MovieContentType.none) {
        return searchResults;
      } else if (failureMessage == null) {
        searchResults.add(dtoFromMap(resultData));
      } else {
        searchResults.add(
          MovieResultDTO().error(
            '[$dataSourceName] $failureMessage',
            dataSource,
          ),
        );
      }
    }
    final multipleResult = map[nodeMultipleResults];
    if (multipleResult != null) {
      final resultType = parseMultipleResultTypeAndData(map, resultData);
      if (resultType == MovieContentType.none) {
        return searchResults;
      } else if (failureMessage == null) {
        searchResults.addAll(dtosFromMaps(resultData));
      } else {
        searchResults.add(
          MovieResultDTO().error(
            '[$dataSourceName] $failureMessage',
            dataSource,
          ),
        );
      }
    }
    return searchResults;
  }

  Iterable<MovieResultDTO> dtosFromMaps(Map<dynamic, dynamic> resultData) {
    final dtos = <MovieResultDTO>[];
    for (final result in resultData.entries) {
      final rawData = result.value;
      if (rawData is Map) {
        final dto = dtoFromMap(rawData);
        dtos.add(dto);
      }
    }
    return dtos;
  }

  MovieResultDTO dtoFromMap(Map<dynamic, dynamic> resultData) {
    final id = resultData[idField]!.toString();
    final movie = MovieResultDTO()
      ..setSource(newSource: dataSource, newUniqueId: id);

    movie
      ..uniqueId = id
      ..type = resultData[nodeType] as MovieContentType? ?? movie.type
      ..title = resultData[nodeName]?.toString() ?? movie.title
      ..description =
          resultData[nodeDescription]?.toString() ?? movie.description
      ..links.addAll(dynamicToStringMap(resultData[nodeExternalLinks]))
      ..getContentType()
      ..getLanguageType();

    return movie;
  }

  MovieContentType parseMultipleResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> outputData,
  ) {
    // [{head: { }, results: {bindings: [{...}]}}]
    var result = MovieContentType.none;
    final inputCollection = inputData.deepSearch(nodeMultipleResultCollection);
    if (inputCollection != null && inputCollection.isNotEmpty) {
      final inputMap = inputCollection.first;
      if (inputMap is List) {
        for (final row in inputMap) {
          if (row is Map) {
            final outputRow = <String, dynamic>{};
            // insert data into map
            outputRow[nodeName] = getStringValue(row, branchText: multipleName);
            outputRow[nodeDescription] = getStringValue(
              row,
              branchText: multipleDescription,
            );
            final imdbId = getStringValue(row, branchText: multipleIMDB);
            outputRow[idField] = imdbId;
            outputRow[nodeExternalLinks] = getMultipleLinks(row);
            final movieType = getMovieType(row, imdbId ?? '');
            outputRow[nodeType] = movieType;
            if (movieType != MovieContentType.none) {
              result = MovieContentType.title;
            }

            outputData[imdbId] = outputRow;
          }
        }
      }
    }
    return result;
  }

  Map<String, String> getMultipleLinks(Map<dynamic, dynamic> rawData) {
    final destinationUrls = <String, String>{};
    for (final row in rawData.entries) {
      var websiteDescription = row.key.toString();
      final attributes = row.value;
      if (attributes is Map && attributes.keys.contains(nodeText)) {
        final url = attributes[nodeText].toString();
        if (url.startsWith(webAddressPrefix)) {
          // check for a better description for the url
          websiteDescription = getWebsiteDescription(url) ?? websiteDescription;

          destinationUrls[websiteDescription] = url;
        }
      }
    }
    return destinationUrls;
  }

  MovieContentType parseSingleResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> outputData,
  ) {
    try {
      var movieType = MovieContentType.none;
      final nameData = inputData.deepSearch(nodeName);
      final descriptionData = inputData.deepSearch(nodeDescription);
      final wikiLinksData = inputData
          .deepSearch(nodeWikiLinks)
          ?.deepSearch(linkEnglish);
      final rawLinkData = inputData.deepSearch(nodeExternalLinks);
      // ...'en':...'value':'xxx'
      outputData[nodeName] = getStringValue(nameData);
      outputData[nodeDescription] = getStringValue(descriptionData);

      final destinationUrls = <String, String>{};
      final wikiUrl = wikiLinksData?.searchForString(key: nodeUrl);
      getExternalUrl(destinationUrls, XxdbSource.wikipedia, wikiUrl);
      getExternalLinks(destinationUrls, rawLinkData);
      outputData[nodeExternalLinks] = destinationUrls;

      // We should now have IMDBid.
      final bestID = getId(inputData);
      outputData[idField] = bestID;
      if (bestID.startsWith(imdbPersonPrefix)) {
        movieType = MovieContentType.person;
      } else if (bestID.startsWith(imdbTitlePrefix)) {
        movieType = MovieContentType.title;
      } else if (bestID.startsWith(wikiNotFound)) {
        movieType = MovieContentType.error;
      }
      outputData[nodeType] = movieType;
      return movieType;
    } catch (_) {}
    failureMessage = 'Unable to interpret results $inputData';
    return MovieContentType.error;
  }

  /// Grab the URL part for the active external link (ignore deprecated).
  void getExternalLinks(
    Map<String, String> destinationUrls,
    List<dynamic>? rawData,
  ) {
    for (final linkCode in tvdbSourceToEnumMapping.keys) {
      final linkType = tvdbSourceToEnumMapping[linkCode];
      final externalSiteData = rawData
          ?.deepSearch(linkCode)
          ?.deepSearch(linkStatus, returnParent: true, multipleMatch: true);
      for (final link in externalSiteData ?? []) {
        // Discard deprecated links.
        if (link is Map && link[linkStatus] == linkActive) {
          final identifier = link.searchForString(key: nodeText);
          getExternalUrl(
            destinationUrls,
            linkType,
            identifier,
            skipImdb: false,
          );

          if (linkCode == nodeImdb) {
            imdbId = identifier;
          }
        }
      }
    }
  }

  /// Search the returned data for a specific id (wikiData or IMDB)
  String getId(Map<dynamic, dynamic> sources) {
    final wikidataId = sources.searchForString(key: idField);
    return imdbId ?? wikidataId ?? wikiNotFound;
  }

  MovieContentType getMovieType(Map<dynamic, dynamic> rawData, String imdbId) {
    if (imdbId.startsWith(imdbPersonPrefix)) {
      return MovieContentType.person;
    }
    final type = getStringValue(rawData, branchText: multipleTypeId);
    if (type != null) {
      // Type string may contain multiple values so look for
      // most specific values first e.g. Animated series before series
      if (type.contains(typeShort)) {
        return MovieContentType.short;
      } else if (type.contains(typeSilent)) {
        return MovieContentType.custom;
      } else if (type.contains(typeDoc)) {
        return MovieContentType.custom;
      } else if (type.contains(typeAnimatedSeries)) {
        return MovieContentType.custom;
      } else if (type.contains(typeAnimated)) {
        return MovieContentType.custom;
      } else if (type.contains(typeWebSeries)) {
        return MovieContentType.series;
      } else if (type.contains(typeEpisode)) {
        return MovieContentType.episode;
      } else if (type.contains(typeSoapOpera)) {
        return MovieContentType.series;
      } else if (type.contains(typeSeries)) {
        return MovieContentType.series;
      } else if (type.contains(typePlay)) {
        return MovieContentType.custom;
      } else if (type.contains(typeConcert)) {
        return MovieContentType.custom;
      } else if (type.contains(typeMusical)) {
        return MovieContentType.custom;
      } else if (type.contains(typeOpera)) {
        return MovieContentType.custom;
      } else if (type.contains(typeVideoGame)) {
        return MovieContentType.custom;
      } else if (type.contains(typeMusicVideo)) {
        return MovieContentType.short;
      } else if (type.contains(typeMiniseries)) {
        return MovieContentType.miniseries;
      } else if (type.contains(typeTV)) {
        return MovieContentType.movie;
      } else if (type.contains(typeSpecial)) {
        return MovieContentType.movie;
      } else if (type.contains(typeDirect)) {
        return MovieContentType.movie;
      } else if (type.contains(typeMovie)) {
        return MovieContentType.movie;
      }
    }
    return MovieContentType.title;
  }

  String? getStringValue(
    dynamic rawData, {
    String branchText = languageEnglish,
    String leafText = nodeText,
  }) {
    final type = TreeHelper(
      rawData,
    ).deepSearch(branchText)?.searchForString(key: leafText);
    if (type == null || type.isEmpty) {
      return null;
    }
    return type;
  }

  int? getNumberValue(Map<dynamic, dynamic> rawData, String branchText) {
    final type = rawData.deepSearch(branchText)?.searchForString(key: nodeText);
    if (type == null || type.isEmpty) {
      return null;
    }
    return int.tryParse(type);
  }

  DateTime? getDateValue(Map<dynamic, dynamic> rawData, String branchText) {
    final type = rawData.deepSearch(branchText)?.searchForString(key: nodeText);
    if (type == null || type.isEmpty) {
      return null;
    }
    return DateTime.tryParse(type);
  }
}
