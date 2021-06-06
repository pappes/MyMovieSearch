import 'dart:convert' show json;
import 'package:html/dom.dart' show Document, Element;
import 'package:html/parser.dart' show parse;
import 'package:flutter/foundation.dart' show describeEnum;

import 'package:my_movie_search/movies/models/metadata_dto.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/web_data/provider_controller.dart';
import 'package:my_movie_search/utilities/web_data/web_redirect.dart';
import 'converters/imdb.dart';
import 'offline/imdb.dart';

const SEARCH_RESULTS_TABLE = 'findList';
const COLUMN_MOVIE_TEXT = 'result_text';
const COLUMN_MOVIE_POSTER = 'primary_photo';

/// Implements [SearchProvider] for the IMDB search html webscraper.
class QueryIMDBDetails extends WebFetchBase<MovieResultDTO, SearchCriteriaDTO> {
  static final baseURL = 'https://www.imdb.com/title/';
  static final baseURLsuffix = '/?ref_=fn_tt_tt_1';

  /// Describe where the data is comming from.
  @override
  String dataSourceName() {
    return describeEnum(DataSourceType.imdb);
  }

  /// Static snapshot of data for offline operation.
  /// Does not filter data based on criteria.
  @override
  DataSourceFn offlineData() {
    return streamImdbHtmlOfflineData;
  }

  /// Scrape movie data from rows in the html table named findList.
  @override
  Stream<MovieResultDTO> transformStream(Stream<String> str) async* {
    // Combine all HTTP chunks together for HTML parsing.
    final content = await str.reduce((value, element) => '$value$element');

    var movieData = scrapeWebPage(content);
    if (movieData[outer_element_description] == null) {
      yield constructError("imdb webscraper json data not detected");
    }
    yield* Stream.fromIterable(transformMapSafe(movieData));
  }

  /// converts <INPUT_TYPE> to a string representation.
  @override
  String toText(dynamic contents) {
    return contents!.criteriaTitle;
  }

  /// API call to IMDB search returning the top matching results for [searchText].
  @override
  Uri constructURI(String searchCriteria, {int pageNumber = 1}) {
    var url = '$baseURL$searchCriteria$baseURLsuffix';
    print("fetching imdb details $url");
    return WebRedirect.constructURI(url);
  }

  /// Convert IMDB map to MovieResultDTO records.
  @override
  List<MovieResultDTO> transformMap(Map map) =>
      ImdbMoviePageConverter.dtoFromCompleteJsonMap(map);

  /// Include entire map in the movie title when an error occurs.
  @override
  MovieResultDTO constructError(String message) {
    var error = MovieResultDTO();
    error.title = '[${this.runtimeType}] $message';
    error.type = MovieContentType.custom;
    error.source = DataSourceType.imdb;
    return error;
  }

  /// Collect JSON and webpage text to construct a map of the movie data.
  Map scrapeWebPage(String content) {
    // Extract embedded JSON.
    var document = parse(content);
    var movieData = json.decode(getMovieJson(document));

    getRecomendations(movieData, document.querySelectorAll('div.rec_overview'));

    getAttributeValue(movieData, document, inner_element_rating_count);
    getAttributeValue(movieData, document, inner_element_rating_value);

    movieData['id'] = getCriteriaText ?? movieData['id'];
    return movieData;
  }

  /// Use CSS selector to find the JSON script on the page
  /// and extract values from the JSON.
  String getMovieJson(Document document) {
    var scriptElement =
        document.querySelector('script[type="application/ld+json"]');
    if (scriptElement == null || scriptElement.innerHtml.length == 0) {
      return '{}';
    }
    return scriptElement.innerHtml;
  }

  /// Use CSS selector to find the text on the page
  /// and extract values from the page.
  void getAttributeValue(Map moviedata, Document document, String attribute) {
    if (moviedata[attribute] != null) return;
    var elements = document.querySelectorAll('span[itemprop="$attribute"]');
    for (var element in elements) {
      if (element.text.length > 1) {
        var webPageText = element.text;
        moviedata[attribute] = webPageText;
      }
    }
  }

  /// Extract the movie recommendations from the current movie.
  void getRecomendations(movieData, List<Element> recommendations) {
    recommendations.forEach((element) => getRecomendation(movieData, element));
  }

  getRecomendation(movieData, Element recommendation) {
    Map attributes = {};
    attributes['id'] = recommendation
        .querySelector('div[data-tconst]')
        ?.attributes['data-tconst']; //"tt1037705"
    attributes['name'] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('b')
        ?.innerHtml; //The Book of Eli
    attributes['year'] = recommendation
        .querySelector('div.rec-title')
        ?.querySelector('span')
        ?.innerHtml; //(2010)
    attributes['poster'] =
        recommendation.querySelector('img')?.attributes['src'];
    attributes['ratingValue'] = recommendation
        .querySelector('span.rating-rating')
        ?.querySelector('span.value')
        ?.innerHtml; //6.9
    attributes['ratingCount'] = recommendation
            .querySelector('span.rating-list')
            ?.attributes[
        'title']; //"Users rated this 6.9/10 (297,550 votes) - click stars to rate"
    attributes['description'] = recommendation
        .querySelector('div.rec-outline')
        ?.querySelector('p')
        ?.innerHtml; //A post-apocalyptic tale... saving humankind.

/*<div class="rec_overview" data-tconst="tt1037705" style="">
    <div class="rec_poster" data-info="" data-spec="p13nsims:tt1111422" data-tconst="tt1037705">
        <div class="rec_overlay">
            <div class="rec_filter"></div>
            <div class="glyph rec_watchlist_glyph"></div>
            <div class="glyph rec_blocked_glyph"></div>
            <div class="glyph rec_rating_glyph"></div>
            <div class="glyph rec_pending_glyph"></div>                        
        </div>            
        <a href="/title/tt1037705/?ref_=tt_sims_tti"><img height="190" width="128" alt="The Book of Eli" title="The Book of Eli" src="https://m.media-amazon.com/images/M/MV5BNTE1OWI1YzgtZjEyMy00MjQ4LWE0NWMtYTNhYjc0ZDQ3ZGRkXkEyXkFqcGdeQXVyNDQ2MTMzODA@._V1_UX128_CR0,0,128,190_AL_.jpg" class="loadlate rec_poster_img"> <br></a>    </div>

       <div class="rec_details">
         <div class="rec-info">
           <div class="rec-jaw-upper">
            <div class="rec-title">
              <a href="/title/tt1037705/?ref_=tt_sims_tt"><b>The Book of Eli</b></a>
                    <span class="nobr">(2010)</span>
            </div>
            <div class="rec-cert-genre rec-elipsis">
                    <span title="Ratings certificate for The Book of Eli (2010)" class="gb_15 titlePageSprite absmiddle"></span>
                     Action     <span class="ghost">|</span> 
                     Adventure     <span class="ghost">|</span> 
                     Drama
            </div>
            <div class="rec-rating">
              <div class="rating rating-list" data-starbar-class="rating-list" data-csrf-token="" data-user="" 
                 id="tt1037705|imdb|6.9|6.9|p13nsims-title|tt1111422|title|main" data-ga-identifier="" 
                 title="Users rated this 6.9/10 (297,550 votes) - click stars to rate">
                <span class="rating-bg">&nbsp;</span>
                <span class="rating-imdb " style="width: 96.6px">&nbsp;</span>
                <span class="rating-stars">
                      <a rel="nofollow" title="Register or login to rate this title"><span>1</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>2</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>3</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>4</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>5</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>6</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>7</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>8</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>9</span></a>
                      <a rel="nofollow" title="Register or login to rate this title"><span>10</span></a>
                </span>
                <span class="rating-rating "><span class="value">6.9</span><span class="grey">/</span><span class="grey">10</span></span>
                <span class="rating-cancel "><a title="Delete" rel="nofollow"><span>X</span></a></span>
                &nbsp;
              </div>
              <div class="rec-outline">
                <p>A post-apocalyptic tale... saving humankind.    </p>
              </div>
            </div>
          </div>
          <div class="rec-jaw-lower">
            <div class="rec-jaw-teeth"></div>
            <div class="rec-director rec-ellipsis">
              <b>Directors:</b> Albert Hughes, Allen Hughes  
            </div>
            <div class="rec-actor rec-ellipsis"> <span>
              <b>Stars:</b> Denzel Washington, Mila Kunis, Ray Stevenson</span>
            </div>
          </div>
      </div>
  </div>
</div>*/
  }
}
