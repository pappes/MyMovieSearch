import 'dart:io';

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/screens/web_page.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/utilities/extensions/duration_extensions.dart';

import 'movie_search_results.dart';

class PersonDetailsPage extends StatefulWidget {
  PersonDetailsPage({Key? key, required MovieResultDTO person})
      : _person = person,
        super(key: key);

  final _person;

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState(_person);

  fetchPersonDetails() {}
}

class _PersonDetailsPageState extends State<PersonDetailsPage> {
  _PersonDetailsPageState(this._person);
  MovieResultDTO _person;
  void searchForRelated(String description, List<MovieResultDTO> movies) {
    var criteria = SearchCriteriaDTO();
    criteria.criteriaList.addAll(movies);
    criteria.criteriaTitle = description;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MovieSearchResultsNewPage(criteria: criteria)),
    );
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.

    return Scaffold(
      appBar: AppBar(
        // Get title from the StatefulWidget PersonDetailsPage.
        title: Text(widget._person.title),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          children: <Widget>[
            Container(
              height:
                  9000, //TODO: work out how to set the container to have variable height in a list view
              child: Center(child: bodySection()),
            )
          ],
        ),
      ),
    );
  }

  Column bodySection() {
    return Column(
      children: [
        SelectableText(widget._person.title, style: hugeFont),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget._person.year == ''
                ? Text('Year Range: ${widget._person.yearRange}')
                : Text('Year: ${widget._person.year.toString()}'),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              leftColumn(),
              rightColumn(),
            ],
          ),
        ),
      ],
    );
  }

  Expanded rightColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widget._person.imageUrl.startsWith('http')
              ? Image(
                  image: NetworkImage(getBigImage(widget._person.imageUrl)),
                  alignment: Alignment.topCenter,
                )
              : Text('NoImage'),
          SelectableText(widget._person.imageUrl, style: tinyFont),
        ],
      ),
    );
  }

  Expanded leftColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(children: [
            Text('Source: ${describeEnum(widget._person.source)}      '),
            Text('UniqueId: ${widget._person.uniqueId}'),
            Link(
              uri: Uri.parse('https://flutter.dev'),
              builder: makeLink,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () => _viewImdbPage(widget._person.uniqueId),
                child: Text('webview'),
              ),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Text(
                '\nDescription: \n${widget._person.description} ',
                style: biggerFont,
              ),
            ),
          ]),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: related()),
          ),
        ],
      ),
    );
  }

  List<Widget> related() {
    List<Widget> categories = [];
    for (var category in _person.related.entries) {
      String description = category.value.toShortString();
      categories.add(Text('${category.key}:'));
      categories.add(
        Center(
          child: GestureDetector(
            onTap: () => searchForRelated(
              '${category.key}: ${_person.title}',
              category.value,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return categories;
  }

  Widget makeLink(BuildContext, FollowLink? followLink) {
    //return Text('hyperlink');

    return ElevatedButton(
      onPressed: followLink,
      child: Text('Hyperlink'),
    );

    /*
    return ElevatedButton(
      onPressed: followLink, child: Text('hyperlink'),
      // ... other properties here ...
    );*/
  }

  void _launchURL() async => await canLaunch('https://flutter.dev')
      ? await launch('https://flutter.dev')
      : throw 'Could not launch https://flutter.dev';

  void _viewImdbPage(String pageRef) {
    if (Platform.isAndroid) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebPage(url: makeImdbUrl(pageRef))),
      );
    }
  }
}
