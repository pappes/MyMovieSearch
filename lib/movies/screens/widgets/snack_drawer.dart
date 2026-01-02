import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

Drawer getDrawer(BuildContext context) => Drawer(
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(child: Text('Navigation')),
      ListTile(
        title: const Text('New Movie Search'),
        onTap: () async {
          Navigator.pop(context);
          final searchType = SearchCriteriaDTO()
            ..init(SearchCriteriaType.movieTitle);
          await MMSNav(context).showCriteriaPage(searchType);
        },
      ),
      ListTile(
        title: const Text('DVD Locations'),
        onTap: () async {
          Navigator.pop(context);
          await MMSNav(context).showDVDsPage();
        },
      ),
      ListTile(
        title: const Text('DVD Search'),
        onTap: () async {
          Navigator.pop(context);
          final searchType = SearchCriteriaDTO()
            ..init(SearchCriteriaType.meilisearch);
          await MMSNav(context).showCriteriaPage(searchType);
        },
      ),
    ],
  ),
);
