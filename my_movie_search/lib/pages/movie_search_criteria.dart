import 'package:flutter/material.dart';

class MovieSearchCriteriaPage extends StatefulWidget {
  MovieSearchCriteriaPage({Key key}) : super(key: key);

  final String title = "Movie Search Criteria";

  @override
  _MovieSearchCriteriaPageState createState() =>
      _MovieSearchCriteriaPageState();
}

class _MovieSearchCriteriaPageState extends State<MovieSearchCriteriaPage> {
  String _title = "";
  String _url = "";

  void _searchForMovie() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values.
      _url = "xhttps://www.imdb.com/find?q=${_title}";
    });
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
        onPressed: _searchForMovie,
        tooltip: 'Search',
        child: Icon(Icons.search),
      ),
    );
  }
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
              autofocus: true,
              autocorrect: true,
              autofillHints: [AutofillHints.sublocality],
              decoration: InputDecoration(
                labelText: "Movie",
                hintText: "Enter movie or tv series to search for",
              ),
              onChanged: (text) {
                state._title = text;
              },
              onSubmitted: (text) {
                print("First text field: $text");
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
                state._url.toString(),
                style: Theme.of(state.context).textTheme.headline4,
              ),
            ],
          ),
        );
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
