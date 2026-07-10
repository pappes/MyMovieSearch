enum MovieContentType {
  none,
  error,
  information,
  keyword,
  barcode,
  searchprompt, // freetext dto to be used in a search criteria
  person,
  title, //      unknown movie type
  download, //   e.g. magnet from tpb
  navigation, // e.g. next page
  movie, //      includes "tv movie"
  short, //      anything less that an hour long that does not repeat
  series, //     a short that repeats or movie repeats more than 4 times
  miniseries, // anything more that an hour long that does repeat
  episode, //    anything that is part of a series or mini-series
  custom,
  status,
}

enum CensorRatingType {
  none,
  kids, //      C G
  family, //    PG
  mature, //    M
  adult, //     M15+, R
  restricted, // X, RC
  custom,
}

enum LanguageType {
  none,
  allEnglish,
  mostlyEnglish,
  someEnglish,
  silent,
  foreign,
  custom,
}

enum ReadHistory {
  none,
  starred, //         Want to come back to this one later.
  read, //            Read the text, got the tshirt to prove it.
  reading, //         Give me a minute, sheesh.
  custom, //          context specific.
}
