import 'package:my_movie_search/movies/domain/models/movie_result_enums.dart';
import 'package:my_movie_search/movies/domain/models/search_criteria_formatting.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/widgets/restorables/restorable_movie_result.dart';
import 'package:my_movie_search/movies/screens/widgets/restorables/restorable_search_criteria.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/utilities/extensions/string_extensions.dart';
import 'package:my_movie_search/utilities/navigation/route_info.dart';

/// Helper functions to get routes for the movie DTO.
extension MovieResultRouteHelper on MovieResultDTO {
  /// Construct route to Material user interface page
  /// as appropriate for the dto.
  ///
  /// Chooses a MovieDetailsPage or PersonDetailsPage
  /// based on the IMDB unique ID or ErrorDetailsPage otherwise
  RouteInfo getDetailsPage() {
    if (uniqueId.startsWith(imdbPersonPrefix) || type == .person) {
      // Open person details.
      return RouteInfo(
        .persondetails,
        RestorableMovie.routeState(this),
        uniqueId,
        title.truncate(50),
      );
    } else if (uniqueId.startsWith(imdbTitlePrefix) ||
        type == .movie ||
        type == .miniseries ||
        type == .short ||
        type == .series ||
        type == .episode ||
        type == .title) {
      // Open Movie details.
      return RouteInfo(
        .moviedetails,
        RestorableMovie.routeState(this),
        uniqueId,
        title.truncate(50),
      );
    } else {
      // Open error details.
      return RouteInfo(
        .errordetails,
        RestorableMovie.routeState(this),
        MovieContentType.error.toString(),
        'Error details for ${title.truncate(50)}',
      );
    }
  }
}

/// Helper functions to get routes for the search criteria DTO.
extension SearchCriteriaRouteHelper on SearchCriteriaDTO {
  /// Construct route to the search results page MovieSearchResultsNewPage
  /// as appropriate for the dto.
  ///
  RouteInfo getSearchResultsPage() => RouteInfo(
    .searchresults,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    criteriaTitle.truncate(50),
  );

  /// Construct route to the search criteria page MovieSearchCriteriaPage
  /// as appropriate for the dto.
  ///
  /// Always chooses MovieSearchResultsNewPage.
  RouteInfo getSearchCriteriaPage() => RouteInfo(
    .search,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    'Search for ${criteriaTitle.truncate(50)}',
  );

  /// Construct route to the about page.
  ///
  /// Always chooses AboutPage.
  RouteInfo getAboutPage() => RouteInfo(
    .about,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    'About Aperture',
  );

  /// Construct route to the changelog page.
  ///
  /// Always chooses ChangelogPage.
  RouteInfo getChangelogPage() => RouteInfo(
    .changelog,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    'Changelog',
  );

  /// Construct route to the navigation history page.
  ///
  /// Always chooses NavigationHistoryPage.
  RouteInfo getNavigationHistoryPage() => RouteInfo(
    .navigationHistory,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    'Navigation History',
  );

  /// Construct route to the error details page.
  ///
  /// Always chooses ErrorDetailsPage.
  RouteInfo getErrorPage() => RouteInfo(
    .errordetails,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    'Error details for ${criteriaTitle.truncate(50)}',
  );

  /// Construct route to the settings page.
  ///
  /// Always chooses SettingsPage.
  RouteInfo getSettingsPage() => RouteInfo(
    .settings,
    RestorableSearchCriteria.routeState(this),
    toUniqueReference(),
    'Settings',
  );
}
