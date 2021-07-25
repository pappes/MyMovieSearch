import 'dart:io';

import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
//import 'package:my_movie_search/movies/screens/web_custom_tabs_page.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';

import 'movie_search_results.dart';

class PersonDetailsPage extends StatefulWidget {
  PersonDetailsPage({Key? key, required MovieResultDTO person})
      : _person = person,
        super(key: key);

  final _person;

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState(_person);
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with RestorationMixin {
  var _person = MovieResultDTO();
  var _restorablePerson = RestorableMovie();

  _PersonDetailsPageState(this._person) {
    var detailCriteria = SearchCriteriaDTO();
    detailCriteria.criteriaTitle = _person.uniqueId;
    // Pull back details at this point because it is very slow and CPU intensive
    final imdbDetails = QueryIMDBNameDetails();
    imdbDetails.readList(detailCriteria).then((searchResults) {
      setState(() => mergeDetails(searchResults));
    });
  }
  mergeDetails(List<MovieResultDTO> details) {
    details.forEach((dto) => _person.merge(dto));
  }

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

  @override
  // The restoration bucket id for this page.
  String get restorationId => runtimeType.toString() + _person.uniqueId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // Register our property to be saved every time it changes,
    // and to be restored every time our app is killed by the OS!
    registerForRestoration(_restorablePerson, _person.uniqueId);
  }

  @override
  void dispose() {
    // Restorables must be disposed when no longer used.
    _restorablePerson.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    _restorablePerson.value = _person;
    return Scaffold(
      appBar: AppBar(
        // Get title from the StatefulWidget PersonDetailsPage.
        title: Text(_person.title),
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
        SelectableText(_person.title, style: hugeFont),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _person.yearRange == ''
                ? Text('Born: ${_person.year.toString()}')
                : Text('Lifespan: ${_person.yearRange}'),
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
          _person.imageUrl.startsWith('http')
              ? Image(
                  image: NetworkImage(getBigImage(_person.imageUrl)),
                  alignment: Alignment.topCenter,
                )
              : Text('NoImage'),
          SelectableText(_person.imageUrl, style: tinyFont),
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
            Text('Source: ${describeEnum(_person.source)}      '),
            Text('UniqueId: ${_person.uniqueId}'),
            ElevatedButton(
              onPressed: () => _launchURL(
                makeImdbUrl(
                  _person.uniqueId,
                  mobile: true,
                ),
              ),
              child: Text('IMDB'),
            ),
          ]),
          Row(children: [
            Expanded(
              child: Text(
                '\nDescription: \n${_person.description} ',
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
      var map = category.value;
      String description = map.toShortString();
      categories.add(Text('${category.key}:'));
      categories.add(
        Center(
          child: GestureDetector(
            onTap: () => searchForRelated(
              '${category.key}: ${_person.title}',
              category.value.values.toList(),
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

  void _launchURL(String url) async {
    try {
      if (Platform.isAndroid) {
        await launch(
          url,
          customTabsOption: CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
            enableDefaultShare: true,
            enableUrlBarHiding: true,
            showPageTitle: true,
          ),
        );
      }
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
