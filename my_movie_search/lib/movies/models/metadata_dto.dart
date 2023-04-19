enum DetailLevel {
  none,
  some, //            name, id and other easy to access details
  most, //            all details shown in a summary
  all, //             every attribute for the main record
  allPlusChildren, // the main record plus some details for related records
  custom, //          context specific
}

enum DataSourceType {
  none,
  imdb,
  imdbSearch,
  imdbSuggestions,
  imdbKeywords,
  omdb,
  tmdbPerson,
  tmdbMovie,
  tmdbSearch,
  tmdbFinder,
  google,
  wiki,
  tpb,
  magnetDl,
  gloTorrents,
  ytsSearch,
  ytsDetails,
  other,
  custom,
}

class MetaDataDTO {
  DataSourceType type = DataSourceType.none;
  String uniqueId = "";
  DetailLevel populationDetailLevel = DetailLevel.none;
  DetailLevel viewDetailLevel = DetailLevel.none;
}
