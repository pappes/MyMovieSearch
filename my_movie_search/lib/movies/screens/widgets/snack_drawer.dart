import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

Drawer getDrawer(BuildContext context) => Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text('Navigation'),
          ),
          ListTile(
            title: const Text('New Movie Search'),
            onTap: () {
              unawaited(MMSNav(context).showCriteriaPage());
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('DVD Locations'),
            onTap: () {
              unawaited(MMSNav(context).showDVDsPage());
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
