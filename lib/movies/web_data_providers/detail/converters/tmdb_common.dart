import 'package:my_movie_search/movies/web_data_providers/detail/converters/xxdb_common.dart';

const outerElementFailureIndicator = 'success';
const outerElementFailureReason = 'status_message';
const innerElementIdentity = 'id';
const innerElementImdbId = 'imdb_id';
const innerElementExternalIds = 'external_ids';

const tvdbSourceToEnumMapping = {
  'imdb_id': XxdbSource.imdb,
  'wikidata_id': XxdbSource.wikidata,
  'facebook_id': XxdbSource.facebook,
  'instagram_id': XxdbSource.instagram,
  'twitter_id': XxdbSource.twitter,
};

  /// use the tmdb type and id to create a description and FQDN for each URL
  Map<String, String> getTmdbUrls(dynamic sources) {
    final destinationUrls = <String, String>{};
    if (sources is Map) {
      for (final entry in sources.entries) {
        // Convert the raw data {"facebook_id": "FightClub"}
        // to dto data {"Facebook": "http://www.facebook.com/FightClub"}
        final value = entry.value?.toString();
        final sourceType = tvdbSourceToEnumMapping[entry.key];

        getExternalUrl(destinationUrls, sourceType, value);
      }
    }

    return destinationUrls;
  }
