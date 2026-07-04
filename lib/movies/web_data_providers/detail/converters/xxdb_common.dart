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
import 'package:my_movie_search/utilities/extensions/dom_extensions.dart';

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
  kym,
  metacritic,
  filmaffinity,
  tvtropes,
  youtube,
  letterboxd,
  lezwatchtv,
  ratingraph,
  tmdb,
  plex,
}

const Map<XxdbSource, String> xxdbSouceDescriptions = {
  .imdb: 'IMDB',
  .tmdb: 'TMDB',
  .eidr: 'EIDR',
  .instagram: 'Instagram',
  .netflix: 'Netflix',
  .officialWebsite: 'Official Website',
  .facebook: 'Facebook',
  .reddit: 'Reddit',
  .rottenTomatoes: 'Rotten Tomatoes',
  .tvMaze: 'TV Maze',
  .wikidata: 'Wikidata',
  .wikipedia: 'Wikipedia',
  .twitter: 'X (Twitter)',
  .kym: 'Know Your Meme',
  .metacritic: 'Metacritic',
  .filmaffinity: 'FilmAffinity',
  .tvtropes: 'TV Tropes',
  .youtube: 'YouTube',
  .letterboxd: 'Letterboxd',
  .lezwatchtv: 'LezWatchTV',
  .ratingraph: 'Ratingraph',
  .tvdb: 'TVDB',
  .plex: 'Plex',
};

const Map<XxdbSource, String> sourceWebsiteMapping = {
  // do not need to add imbd explicitly 'imdb_id': sourceImdb,
  .eidr: 'https://ui.eidr.org',
  .instagram: 'https://www.instagram.com',
  .netflix: 'https://www.netflix.com',
  .reddit: 'https://www.reddit.com',
  .rottenTomatoes: 'https://www.rottentomatoes.com',
  .facebook: 'https://www.facebook.com',
  .tvMaze: 'https://www.tvmaze.com',
  .wikidata: 'https://www.wikidata.org',
  .wikipedia: 'https://en.wikipedia.org',
  .twitter: 'https://twitter.com',
  .kym: 'https://knowyourmeme.com',
  .metacritic: 'https://www.metacritic.com',
  .filmaffinity: 'https://www.filmaffinity.com',
  .tvtropes: 'https://tvtropes.org',
  .youtube: 'https://www.youtube.com',
  .letterboxd: 'https://letterboxd.com',
  .lezwatchtv: 'https://lezwatchtv.com',
  .ratingraph: 'https://www.ratingraph.com',
  .tmdb: 'https://www.themoviedb.org',
  .tvdb: 'https://thetvdb.com',
  .plex: 'https://app.plex.tv',
};
const Map<XxdbSource, String> sourceWebsitePath = {
  // do not need to add imbd explicitly 'imdb_id': sourceImdb,
  .eidr: '/content/',
  .instagram: '/',
  .netflix: '/title/',
  .reddit: '/r/',
  .rottenTomatoes: '/',
  .facebook: '/',
  .tvMaze: '/shows/',
  .wikidata: '/wiki/',
  .wikipedia: '/wiki/',
  .twitter: '/',
  .kym: '/memes/',
  .metacritic: '/',
  .filmaffinity: '/en/film',
  .tvtropes: '/pmwiki/pmwiki.php/Main/',
  .youtube: '/watch?v=',
  .letterboxd: '/film/',
  .lezwatchtv: '/show/',
  .ratingraph: '/tv-shows/',
  .tmdb: '/',
  .tvdb: '/dereferrer/',
  .plex:
      '/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/',
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
}) {
  final linkDescription = xxdbSouceDescriptions[source];
  if (identifier != null && linkDescription != null) {
    // Assemble the fully qualified URL from the parts and store it in the map.
    if (identifier.startsWith(webAddressPrefix)) {
      destinationUrls[linkDescription] = identifier;
    } else if (sourceWebsiteMapping.containsKey(source)) {
      final website = sourceWebsiteMapping[source];
      final path = sourceWebsitePath[source];
      if (source != .tmdb && source != .tvdb) {
        // tvdb and tmdb need more info to construct the url.
        destinationUrls[linkDescription] = '$website$path$identifier';
      }
    }
    if (source == .imdb && !skipImdb) {
      destinationUrls[linkDescription] = makeImdbUrl(identifier);
    }
  }
}

String? getWebsiteDescription(String website) {
  for (final entry in sourceWebsiteMapping.entries) {
    final firstWww = RegExp(r'^https?://(www\.)?');
    final websiteSansWww = website.replaceFirst(firstWww, '');
    final entryWebsiteSansWww = entry.value.replaceFirst(firstWww, '');
    if (websiteSansWww.startsWith(entryWebsiteSansWww)) {
      return xxdbSouceDescriptions[entry.key];
    }
  }
  return null;
}
