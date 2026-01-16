import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/converters/tvdb_common.dart';
import 'package:my_movie_search/movies/web_data_providers/imdb_json/imdb_converter_base.dart';
import 'package:my_movie_search/utilities/extensions/tree_map_list_extensions.dart';

const nodeSources = 'remoteIds';

const sourceEntry = 'sourceName';
const sourceImdb = 'IMDB';
const sourceTvdb = 'TheMovieDB.com';
const sourceEidr = 'EIDR';
const sourceInstagam = 'Instagram';
const sourceOfficialWebsite = 'Official Website';
const sourceReddit = 'Reddit';
const sourceTvMaze = 'TV Maze';
const sourceWikidata = 'Wikidata';
const sourceWikipedia = 'Wikipedia';
const sourceX = 'X (Twitter)';

const eidrUrlPrefix = 'https://ui.eidr.org/content/';
const instagramUrlPrefix = 'https://www.instagram.com/';
const netflixUrlPrefix = 'https://www.netflix.com/title/';
const redditUrlPrefix = 'https://www.reddit.com/r/';
const tvMazeUrlPrefix = 'https://www.tvmaze.com/shows/';
const wikipediaUrlPrefix = 'https://en.wikipedia.org/wiki/';
const twitterUrlPrefix = 'https://twitter.com/';
const wikidataUrlPrefix = 'https://www.wikidata.org/wiki/';

const tvdbNotFound = 'NotFoundException: not found';

const nameField = 'sourceName';
const idField = 'id';

class TvdbMovieDetailConverter extends TvdbCommonConverter {
  TvdbMovieDetailConverter(this.contentType);

  MovieContentType contentType;

  @override
  MovieContentType parseResultTypeAndData(
    Map<dynamic, dynamic> inputData,
    Map<dynamic, dynamic> outputData,
  ) {
    // {"data": [{ lists: {[{ remoteIds [{ id: ..., sourceName:..., }]}]}}]}
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

      final sources = inputData.deepSearch(nodeSources, multipleMatch: true);
      final id = getId(sources, sourceTvdb);
      if (id == null) {
        return MovieContentType.none;
      }
      outputData[elementIdentity] = id;
      imdbId = getId(sources, sourceImdb) ?? imdbId;
      final sourceUrls = <String, String>{};
      getKnownUrl(sourceUrls, sources, sourceEidr, eidrUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceInstagam, instagramUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceOfficialWebsite, netflixUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceOfficialWebsite, netflixUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceReddit, redditUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceTvMaze, tvMazeUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceWikidata, wikidataUrlPrefix);
      getKnownUrl(sourceUrls, sources, sourceWikipedia, wikipediaUrlPrefix);
      getOtherUrls(sourceUrls, sources);

      outputData[elementSourceUrls] = sourceUrls;
      return contentType;
    } catch (_) {}
    failureMessage = 'Unable to interpret results $inputData';
    return MovieContentType.error;
  }

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

  void getKnownUrl(
    Map<String, String> sourceUrls,
    List<dynamic>? sources,
    String source,
    String prefix,
  ) {
    final id = getId(sources, source);
    if (id != null) {
      if (id.startsWith('http')) {
        sourceUrls[source] = id;
      } else {
        sourceUrls[source] = '$prefix$id';
      }
    }
  }

  void getOtherUrls(Map<String, String> sourceUrls, List<dynamic>? sources) {
    for (final map in sources ?? []) {
      if (map is Map) {
        for (final entry in map.entries) {
          final source = entry.value;
          if (source is String && source.startsWith('http')) {
            sourceUrls[entry.key!.toString()] = source;
          }
        }
      }
    }
  }
}
