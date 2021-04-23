import 'package:flutter/material.dart';
//import 'package:my_movie_search/screens/home.dart';
import 'package:my_movie_search/movies/screens/movie_search_criteria.dart';
//import 'package:my_movie_search/screens/webveiw/webview_testing.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Movie Search',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system, //dark or light or system
      home: MovieSearchCriteriaPage(),
      //   home: MovieHomePage(),
    );
  }
}
