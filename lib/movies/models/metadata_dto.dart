enum DetailLevel {
  none,
  some, //            name, id and other easy to access details
  most, //            all details shown in a summary
  all, //             every attribute for the main record
  allPlusChildren, // the main record plus some details for related records
  custom, //          context specific
}

enum ReadHistory {
  none,
  starred, //         Want to come back to this one later.
  read, //            Read the text, got the tshirt to prove it.
  reading, //         Give me a minute, sheesh.
  custom, //          context specific.
}

enum DataSourceType {
  none,
  imdb,
  imdbSearch,
  imdbSuggestions,
  imdbJson,
  imdbCast,
  imdbKeywords,
  omdb,
  tmdbPerson,
  tmdbMovie,
  tmdbSearch,
  tmdbFinder,
  tvdbDetails,
  google,
  mssearch,
  fbmmsnavlog,
  wiki,
  tpb,
  magnetDl,
  solidTorrents,
  torrentDownloadDetail,
  torrentDownloadSearch,
  torrentz2,
  gloTorrents,
  ytsSearch,
  ytsDetails,
  uhttBarcode,
  picclickBarcode,
  libsaBarcode,
  fishpondBarcode,
  other,
  custom,
}

class MetaDataDTO {
  DataSourceType type = DataSourceType.none;
  String uniqueId = '';
  DetailLevel populationDetailLevel = DetailLevel.none;
  DetailLevel viewDetailLevel = DetailLevel.none;
}
