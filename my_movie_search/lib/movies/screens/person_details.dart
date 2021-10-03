import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';

import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/widgets/controls.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';

class PersonDetailsPage extends StatefulWidget {
  PersonDetailsPage({Key? key, required MovieResultDTO person})
      : _person = person,
        super(key: key);

  final MovieResultDTO _person;

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState(_person);
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with RestorationMixin {
  var _person = MovieResultDTO();
  var _restorablePerson = RestorableMovie();
  var _mobileLayout = true;

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
    _mobileLayout = useMobileLayout(context);
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
                  ExpandedColumn(children: [leftColumn()])
                ] +
                (_mobileLayout // Only show right column on tablet
                    ? []
                    : [ExpandedColumn(children: posterSection())]),
          ),
        ),
      ],
    );
  }

  Widget leftColumn() {
    return Wrap(
      children: [
            Text('Source: ${describeEnum(_person.source)}      '),
            Text('UniqueId: ${_person.uniqueId}'),
            ElevatedButton(
              onPressed: () => viewWebPage(
                makeImdbUrl(
                  _person.uniqueId,
                  mobile: true,
                ),
                context,
              ),
              child: Text('IMDB'),
            ),
          ] +
          // Only show poster in left column on mobile
          (_mobileLayout ? posterSection() : []) +
          [
            Text(
              '\nDescription: \n${_person.description} ',
              style: biggerFont,
            ),
          ] +
          related(),
    );
  }

  List<Widget> posterSection() {
    return [
      Row(
        children: [
          ExpandedColumn(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: poster(
              _person.imageUrl,
              onTap: () => viewWebPage(
                makeImdbUrl(_person.uniqueId, photos: true, mobile: true),
                context,
              ),
            ),
          )
        ],
      ),
    ];
  }

  List<Widget> related() {
    List<Widget> categories = [];
    for (var category in _person.related.entries) {
      var map = category.value;
      String description = map.toShortString();
      categories.add(BoldLabel('${category.key}:'));
      categories.add(
        Center(
          child: GestureDetector(
            onTap: () => searchForRelated(
              '${category.key}: ${_person.title}',
              category.value.values.toList(),
              context,
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
}
