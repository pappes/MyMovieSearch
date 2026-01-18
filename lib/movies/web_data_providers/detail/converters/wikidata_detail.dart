import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/xxdb_common.dart';
import 'package:my_movie_search/utilities/extensions/dynamic_extensions.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

const languageEnglish = 'en';
const linkEnglish = 'enwiki';

const nodeName = 'labels';
const nodeDescription = 'descriptions';
const nodeWikiLinks = 'sitelinks';
const nodeExternalLinks = 'claims';
const nodeRottentomatoes = 'P1258';
const nodeImdb = 'P345';
const nodeFacebook = 'P2013';
const nodeOfficialWebsite = 'P856';

const nodeText = 'value';
const nodeUrl = 'url';

const linkStatus = 'rank';
const linkInactive = 'deprecated';
const linkActive = 'normal';

const sourceEntry = 'sourceName';

const tvdbNotFound = 'NotFoundException: not found';

const nameField = 'sourceName';
const idField = 'id';
const imdbIdField = 'id';

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
  late String dataSourceName = 'TvdbDetailConverter';

  List<MovieResultDTO> dtoFromCompleteJsonMap(Map<dynamic, dynamic> map) {
    // deserialise outer json from map then iterate inner json
    final searchResults = <MovieResultDTO>[];
    final resultData = <dynamic, dynamic>{};
    dataSourceName = dataSource.name; //datasource

    final resultType = parseResultTypeAndData(map, resultData);
    if (resultType == MovieContentType.none) {
      return searchResults;
    } else if (failureMessage == null) {
      searchResults.add(dtoFromMap(resultType, resultData));
    } else {
      searchResults.add(
        MovieResultDTO().error('[$dataSourceName] $failureMessage', dataSource),
      );
    }
    return searchResults;
  }

  MovieResultDTO dtoFromMap(
    MovieContentType resultType,
    Map<dynamic, dynamic> resultData,
  ) {
    final id = resultData[idField]!.toString();
    final movie = MovieResultDTO()
      ..setSource(newSource: dataSource, newUniqueId: id)
      ..type = resultType;

    movie
      ..uniqueId = id
      ..title = resultData[nodeName]?.toString() ?? movie.title
      ..description =
          resultData[nodeDescription]?.toString() ?? movie.description
      ..links.addAll(dynamicToStringMap(resultData[nodeExternalLinks]))
      ..getContentType()
      ..getLanguageType();

    return movie;
  }

  MovieContentType parseResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> outputData,
  ) {
    try {
      final nameData = inputData
          .deepSearch(nodeName)
          ?.deepSearch(languageEnglish);
      final descriptionData = inputData
          .deepSearch(nodeDescription)
          ?.deepSearch(languageEnglish);
      final wikiLinksData = inputData
          .deepSearch(nodeWikiLinks)
          ?.deepSearch(linkEnglish);
      final rawLinkData = inputData.deepSearch(nodeExternalLinks);
      outputData[nodeName] = nameData?.searchForString(key: nodeText);
      outputData[nodeDescription] = descriptionData?.searchForString(
        key: nodeText,
      );

      final destinationUrls = <String, String>{};
      final wikiUrl = wikiLinksData?.searchForString(key: nodeUrl);
      getExternalUrl(destinationUrls, XxdbSource.wikipedia, wikiUrl);
      getExternalLinks(destinationUrls, rawLinkData);
      outputData[nodeExternalLinks] = destinationUrls;

      // We should now have IMDBid.
      final bestID = getId(inputData);
      outputData[idField] = bestID;
      if (bestID.startsWith(imdbPersonPrefix)) {
        return MovieContentType.person;
      } else if (bestID.startsWith(imdbTitlePrefix)) {
        return MovieContentType.title;
      } else if (bestID.startsWith(tvdbNotFound)) {
        return MovieContentType.error;
      }
      return MovieContentType.none;
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
    return imdbId ?? wikidataId ?? tvdbNotFound;
  }
}
