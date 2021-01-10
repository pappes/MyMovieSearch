enum DetailLevel {
  none,
  some, //            name, id and other easy to access details
  most, //            all details shown in a summary
  all, //             every attribute for the main record
  allPlusChildren, // the main record plus some details for related records
  custom, //          context specific
}

class MetaDataDTO {
  //MovieContentType type = MovieContentType.none;
  String uniqueId = "";
  DetailLevel populationDetailLevel = DetailLevel.none;
  DetailLevel viewDetailLevel = DetailLevel.none;
}
