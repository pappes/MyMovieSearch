import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/movie_search_results.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  const MovieSearchCriteriaPage({Key? key}) : super(key: key);

  final String title = "Movie Search Criteria";

  @override
  _MovieSearchCriteriaPageState createState() =>
      _MovieSearchCriteriaPageState();
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage>
    with SearchCriteriaDTO {
  void searchForMovie({String? criteria}) {
    this.criteriaTitle = criteria ?? this.criteriaTitle;
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      criteriaUrl = "xhttps://www.imdb.com/find?q=$criteriaTitle";
    });
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsPage(criteria: this)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: _MovieSearchCriteriaBody(this),
      floatingActionButton: FloatingActionButton(
        onPressed: searchForMovie,
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),
    );
  }
}

class _MovieSearchCriteriaBody extends Center {
  _MovieSearchCriteriaBody(_MovieSearchCriteriaPageState state)
      : super(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _MovieSearchCrieriaTop(state),
            _MovieSearchCritriaMid(state),
          ],
        ));
}

class _MovieSearchCrieriaTop extends Center {
  // Center is a layout widget. It takes a single child and positions it
  // in the middle of the parent.
  _MovieSearchCrieriaTop(_MovieSearchCriteriaPageState state)
      : super(
            child: Column(
          // Column takes a list of children and arranges them vertically.
          // By default, it sizes itself to fit it's children horizontally
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              textInputAction: TextInputAction.search,
              autofocus: true,
              autocorrect: true,
              autofillHints: [AutofillHints.sublocality],
              decoration: InputDecoration(
                labelText: "Movie",
                hintText: "Enter movie or tv series to search for",
              ),
              onChanged: (text) {
                state.criteriaTitle = text;
              },
              onSubmitted: (text) {
                state.searchForMovie(criteria: text);
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: "URL"),
            ),
          ],
        ));
}

class _MovieSearchCritriaMid extends Center {
  _MovieSearchCritriaMid(_MovieSearchCriteriaPageState state)
      : super(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'You have pushed the button this many times:',
              ),
              Text(
                state.criteriaUrl,
                style: Theme.of(state.context).textTheme.headline4,
              ),
            ],
          ),
        );
}
