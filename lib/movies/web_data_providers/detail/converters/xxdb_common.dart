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

const xxdbSouceDescriptions = {
  XxdbSource.imdb: 'IMDB',
  XxdbSource.tmdb: 'TMDB',
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
  XxdbSource.kym: 'Know Your Meme',
  XxdbSource.metacritic: 'Metacritic',
  XxdbSource.filmaffinity: 'FilmAffinity',
  XxdbSource.tvtropes: 'TV Tropes',
  XxdbSource.youtube: 'YouTube',
  XxdbSource.letterboxd: 'Letterboxd',
  XxdbSource.lezwatchtv: 'LezWatchTV',
  XxdbSource.ratingraph: 'Ratingraph',
  XxdbSource.tvdb: 'TVDB',
  XxdbSource.plex: 'Plex',
};

const sourceWebsiteMapping = {
  // do not need to add imbd explicitly 'imdb_id': sourceImdb,
  XxdbSource.eidr: 'https://ui.eidr.org',
  XxdbSource.instagram: 'https://www.instagram.com',
  XxdbSource.netflix: 'https://www.netflix.com',
  XxdbSource.reddit: 'https://www.reddit.com',
  XxdbSource.rottenTomatoes: 'https://www.rottentomatoes.com',
  XxdbSource.facebook: 'https://www.facebook.com',
  XxdbSource.tvMaze: 'https://www.tvmaze.com',
  XxdbSource.wikidata: 'https://www.wikidata.org',
  XxdbSource.wikipedia: 'https://en.wikipedia.org',
  XxdbSource.twitter: 'https://twitter.com',
  XxdbSource.kym: 'https://knowyourmeme.com',
  XxdbSource.metacritic: 'https://www.metacritic.com',
  XxdbSource.filmaffinity: 'https://www.filmaffinity.com',
  XxdbSource.tvtropes: 'https://tvtropes.org',
  XxdbSource.youtube: 'https://www.youtube.com',
  XxdbSource.letterboxd: 'https://letterboxd.com',
  XxdbSource.lezwatchtv: 'https://lezwatchtv.com',
  XxdbSource.ratingraph: 'https://www.ratingraph.com',
  XxdbSource.tmdb: 'https://www.themoviedb.org',
  XxdbSource.plex: 'https://app.plex.tv',
  XxdbSource.tvdb: 'https://thetvdb.com',
};
const sourceWebsitePath = {
  // do not need to add imbd explicitly 'imdb_id': sourceImdb,
  XxdbSource.eidr: '/content/',
  XxdbSource.instagram: '/',
  XxdbSource.netflix: '/title/',
  XxdbSource.reddit: '/r/',
  XxdbSource.rottenTomatoes: '/',
  XxdbSource.facebook: '/',
  XxdbSource.tvMaze: '/shows/',
  XxdbSource.wikidata: '/wiki/',
  XxdbSource.wikipedia: '/wiki/',
  XxdbSource.twitter: '/',
  XxdbSource.kym: '/memes/',
  XxdbSource.metacritic: '/',
  XxdbSource.filmaffinity: '/en/film',
  XxdbSource.tvtropes: '/pmwiki/pmwiki.php/Main/',
  XxdbSource.youtube: '/watch?v=',
  XxdbSource.letterboxd: '/film/',
  XxdbSource.lezwatchtv: '/show/',
  XxdbSource.ratingraph: '/tv-shows/',
  XxdbSource.tmdb: '/dereferrer/',
  XxdbSource.plex:
      '/desktop/#!/provider/tv.plex.provider.metadata/details?key=/library/metadata/',
  XxdbSource.tvdb: '/',
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
      final path = sourceWebsitePath[source];
      destinationUrls[linkDescription] = '$website$path$identifier';
    }
    if (source == XxdbSource.imdb && !skipImdb) {
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
