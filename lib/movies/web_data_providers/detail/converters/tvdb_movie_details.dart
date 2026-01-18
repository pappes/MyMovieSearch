import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tvdb_common.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/xxdb_common.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

const nodeExternalLinks = 'remoteIds';

const sourceEntry = 'sourceName';

const tvdbNotFound = 'NotFoundException: not found';

const nameField = 'sourceName';
const idField = 'id';

const sourceImdb = 'IMDB';
const sourceTvdb = 'TheMovieDB.com';

const tvdbSourceToEnumMapping = {
  'IMDB': XxdbSource.imdb,
  'TheMovieDB.com': XxdbSource.tvdb,
  'EIDR': XxdbSource.eidr,
  'Instagram': XxdbSource.instagram,
  'Netflix': XxdbSource.netflix,
  'Official Website': XxdbSource.officialWebsite,
  'Reddit': XxdbSource.reddit,
  'TV Maze': XxdbSource.tvMaze,
  'Wikidata': XxdbSource.wikidata,
  'Wikipedia': XxdbSource.wikipedia,
  'X (Twitter)': XxdbSource.twitter,
};

class TvdbMovieDetailConverter extends TvdbCommonConverter {
  TvdbMovieDetailConverter(this.contentType);

  MovieContentType contentType;

  @override
  MovieContentType parseResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> outputData,
  ) {
    // {"data": [{ lists: {[{ remoteIds: [{ id: ..., sourceName:..., }]}]}}]}
    // {"status": "success", "data": null }

    dataSourceName = 'TvdbMovieDetailConverter';
    try {
      if (inputData.containsKey(outerElementFailureIndicator)) {
        final returnedData = inputData[outerElementFailureIndicator];
        if (returnedData == tvdbNotFound) {
          // No data found
          return MovieContentType.none;
        }
      }
      failureMessage = getFailureReasonFromMap(inputData);
      if (null != failureMessage) {
        return MovieContentType.error;
      }

      final rawLinkData = inputData.deepSearch(
        nodeExternalLinks,
        multipleMatch: true,
      );
      final id = getId(rawLinkData, sourceTvdb);
      if (id == null) {
        return MovieContentType.none;
      }
      outputData[elementIdentity] = id;
      imdbId = getId(rawLinkData, sourceImdb) ?? imdbId;
      final fqdnUrls = constructUrls(rawLinkData);
      getRawUrls(fqdnUrls, rawLinkData);

      outputData[elementSourceUrls] = fqdnUrls;
      return contentType;
    } catch (_) {}
    failureMessage = 'Unable to interpret results $inputData';
    return MovieContentType.error;
  }

  /// use the tvdb type and id to create a description and FQDN for each URL
  // [[{ "id": "tt13443470", "type": 2, sourceName": "IMDB" }]]
  Map<String, String> constructUrls(List<dynamic>? rawData) {
    final fqdnUrls = <String, String>{};
    final links = rawData?.deepSearch(
      idField,
      multipleMatch: true,
      returnParent: true,
    );
    for (final link in links ?? []) {
      if (link is Map) {
        final linkDescription = link[sourceEntry]?.toString();
        final id = link[idField]?.toString();
        final sourceType = tvdbSourceToEnumMapping[linkDescription];

        getExternalUrl(fqdnUrls, sourceType, id);
      }
    }
    return fqdnUrls;
  }

  /// Search the returned data for a specific id (TVDB or IMDB)
  String? getId(List<dynamic>? sources, String source) {
    String? idValue;
    String? extractId(Map<dynamic, dynamic> map) {
      if (map.containsKey(nameField) && map[nameField] == source) {
        return idValue = map[idField]?.toString() ?? idValue;
      }
      return null;
    }

    for (final match in sources ?? []) {
      if (match is List) {
        ConverterHelper().forEachMap(match, extractId);
        if (idValue != null && idValue!.isNotEmpty) {
          return idValue;
        }
      }
    }
    return null;
  }

  /// get a list of all external URLs that are already FQDN and dont need 
  /// extra processing
  void getRawUrls(Map<String, String> sourceUrls, List<dynamic>? sources) {
    for (final map in sources ?? []) {
      if (map is Map) {
        for (final entry in map.entries) {
          final source = entry.value;
          if (source is String && source.startsWith(webAddressPrefix)) {
            sourceUrls[entry.key!.toString()] = source;
          }
        }
      }
    }
  }
}
