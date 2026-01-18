/*const sourceImdb = 'IMDB';
const sourceTvdb = 'TheMovieDB.com';
const sourceEidr = 'EIDR';
const sourceInstagam = 'Instagram';
const sourceNetflix = 'Netflix';
const sourceOfficialWebsite = 'Official Website';
const sourceFacebook = 'Facebook';
const sourceReddit = 'Reddit';
const sourceTvMaze = 'TV Maze';
const sourceWikidata = 'Wikidata';
const sourceWikipedia = 'Wikipedia';
const sourceX = 'X (Twitter)';*/
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

enum XxdbSource {
  imdb,
  tvdb,
  eidr,
  instagram,
  netflix,
  officialWebsite,
  facebook,
  reddit,
  rottenTomatoes,
  tvMaze,
  wikidata,
  wikipedia,
  twitter,
}

const xxdbSouceDescriptions = {
  XxdbSource.imdb: 'IMDB',
  XxdbSource.tvdb: 'TheMovieDB.com',
  XxdbSource.eidr: 'EIDR',
  XxdbSource.instagram: 'Instagram',
  XxdbSource.netflix: 'Netflix',
  XxdbSource.officialWebsite: 'Official Website',
  XxdbSource.facebook: 'Facebook',
  XxdbSource.reddit: 'Reddit',
  XxdbSource.rottenTomatoes: 'Rotten Tomatoes',
  XxdbSource.tvMaze: 'TV Maze',
  XxdbSource.wikidata: 'Wikidata',
  XxdbSource.wikipedia: 'Wikipedia',
  XxdbSource.twitter: 'X (Twitter)',
};

const sourceWebsiteMapping = {
  // do not need to add imbd explicitly 'imdb_id': sourceImdb,
  XxdbSource.eidr: 'https://ui.eidr.org/content/',
  XxdbSource.instagram: 'https://www.instagram.com/',
  XxdbSource.netflix: 'https://www.netflix.com/title/',
  XxdbSource.reddit: 'https://www.reddit.com/r/',
  XxdbSource.rottenTomatoes: 'https://www.rottentomatoes.com/',
  XxdbSource.facebook: 'https://www.facebook.com/',
  XxdbSource.tvMaze: 'https://www.tvmaze.com/shows/',
  XxdbSource.wikidata: 'https://www.wikidata.org/wiki/',
  XxdbSource.wikipedia: 'https://en.wikipedia.org/wiki/',
  XxdbSource.twitter: 'https://twitter.com/',
};

/// Create FQDN for instagram, wikipedia, etc.
///
/// destinationUrls: a writable map to put the URL into
/// source:          the key to use to insert into the map
/// prefix:          http://www.something.com/
/// identifier:      url suffix for the specific webpage
void getExternalUrl(
  Map<String, String> destinationUrls,
  XxdbSource? source,
  String? identifier, {
  bool skipImdb = true,
}
) {
  final linkDescription = xxdbSouceDescriptions[source];
  if (identifier != null && linkDescription != null) {
    // Assemble the fully qualified URL from the parts and store it in the map.
    if (identifier.startsWith(webAddressPrefix)) {
      destinationUrls[linkDescription] = identifier;
    } else if (sourceWebsiteMapping.containsKey(source)) {
      final website = sourceWebsiteMapping[source];
      destinationUrls[linkDescription] = '$website$identifier';
    }
    if (source == XxdbSource.imdb && !skipImdb) {
      destinationUrls[linkDescription] = makeImdbUrl(identifier);
    }
  }
}
