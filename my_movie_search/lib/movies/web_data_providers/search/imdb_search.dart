import 'package:html/dom.dart' show Element;
import 'package:html/parser.dart' show parse;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/search/converters/imdb_search.dart';
import 'package:my_movie_search/movies/web_data_providers/search/offline/imdb_search.dart';
import 'package:my_movie_search/utilities/extensions/dom_extentions.dart';
import 'package:my_movie_search/utilities/web_data/web_fetch.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';

const _searchResultsTable = 'findList';
const _columnMovieText = 'result_text';
const _columnMoviePoster = 'primary_photo';

/// Implements [WebFetchBase] for the IMDB search html webscraper.
class QueryIMDBSearch extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static const _baseURL = 'https://www.imdb.com/find?s=tt&ref_=fn_al_tt_mr&q=';

  /// Describe where the data is comming from.
  @override
  String myDataSourceName() {
    return DataSourceType.imdbSearch.name;
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn myOfflineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape movie data from html table(s) named findList.
  @override
  Stream<MovieResultDTO> baseTransformTextStreamToOutput(
    Stream<String> str,
  ) async* {
    // Combine all HTTP chunks together for HTML parsing
    final content = await str.reduce((value, element) => '$value\n$element');
    final document = parse(content);

    // Extract required tables from the dom (anthing named findList).
    final tables = document.getElementsByClassName(_searchResultsTable);
    final rows = extractRowsFromTables(tables);
    for (final row in rows) {
      yield* Stream.fromIterable(baseTransformMapToOutputHandler(row));
    }
  }

  /// Extract movie data from rows in html table(s).
  List<Map> extractRowsFromTables(List<Element> tables) {
    final htmlMovies = <Map>[];

    for (final table in tables) {
      final rows = table.getElementsByType(ElementType.row);
      for (final row in rows) {
        htmlMovies.add(extractRowData(row));
      }
    }

    return htmlMovies;
  }

  /// Convert HTML row element into a map of individual field data.
  /// <a title>       -> Title
  /// <img>           -> Image
  /// <a href>        -> AnchorAddress
  /// <td> text </td> -> Info (year and type)
  Map<String, String?> extractRowData(Element tableRow) {
    final rowData = <String, String?>{};
    for (final tableColumn in tableRow.children) {
      if (tableColumn.className == _columnMovieText) {
        // <td> text </td> -> Info
        rowData[innerElementInfo] = tableColumn.text;
        tableColumn.getElementsByType(ElementType.anchor).forEach((element) {
          // <a href> -> AnchorAddress
          rowData[innerElementIdentity] =
              element.getAttribute(AttributeType.address);
          // <a title> -> Title
          rowData[innerElementTitle] = element.text;
        });
      } else if (tableColumn.className == _columnMoviePoster) {
        // <img> -> Image
        tableColumn.getElementsByType(ElementType.image).forEach((element) {
          rowData[innerElementImage] =
              element.getAttribute(AttributeType.source);
        });
      }
    }
    return rowData;
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> myTransformMapToOutput(Map map) =>
      ImdbSearchConverter.dtoFromCompleteJsonMap(map);

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String myFormatInputAsText(dynamic contents) {
    final criteria = contents as SearchCriteriaDTO;
    return criteria.criteriaTitle;
  }

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO myYieldError(String message) {
    final error = MovieResultDTO();
    error.title = '[QueryIMDBSearch] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdbSearch;
    return error;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri myConstructURI(String searchCriteria, {int pageNumber = 1}) {
    final url = '$_baseURL$searchCriteria';
    return WebRedirect.constructURI(url);
  }
}
