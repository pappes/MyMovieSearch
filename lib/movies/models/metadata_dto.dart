enum DetailLevel {
  none,
  some, //            name, id and other easy to access details
  most, //            all details shown in a summary
  all, //             every attribute for the main record
  allPlusChildren, // the main record plus some details for related records
  custom, //          context specific
}

/// The data source from which a `MovieResultDTO` was populated.
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
  wikidataDetail,
  wikidataSearch,
  tpb,
  magnetDl,
  eztv,
  eztvApi,
  solidTorrents,
  torrentDownloadDetail,
  torrentDownloadSearch,
  torrentz2,
  gloTorrents,
  ytsSearch,
  ytsDetails,
  ytsDetailApi,
  uhttBarcode,
  picclickBarcode,
  libsaBarcode,
  fishpondBarcode,
  other,
  custom,
}

/// The metadata for a `MovieResultDTO`.
class MetaDataDTO {
  DataSourceType type = .none;
  String uniqueId = '';
  DetailLevel populationDetailLevel = .none;
  DetailLevel viewDetailLevel = .none;
}
