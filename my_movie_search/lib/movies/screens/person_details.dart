import 'package:flutter/foundation.dart' show describeEnum;
import 'package:flutter/material.dart';

import 'package:my_movie_search/movies/models/movie_result_dto.dart';
import 'package:my_movie_search/movies/models/search_criteria_dto.dart';
import 'package:my_movie_search/movies/screens/styles.dart';
import 'package:my_movie_search/movies/web_data_providers/common/imdb_helpers.dart';
import 'package:my_movie_search/movies/web_data_providers/detail/imdb_name.dart';
import 'package:my_movie_search/movies/widgets/controls.dart';
import 'package:my_movie_search/utilities/navigation/web_nav.dart';
import 'package:my_movie_search/utilities/thread.dart';

class PersonDetailsPage extends StatefulWidget {
  const PersonDetailsPage({Key? key, required this.person}) : super(key: key);

  final MovieResultDTO person;

  @override
  _PersonDetailsPageState createState() => _PersonDetailsPageState();
}

class _PersonDetailsPageState extends State<PersonDetailsPage>
    with RestorationMixin {
  late MovieResultDTO _person;
  final _restorablePerson = RestorableMovie();
  var _mobileLayout = true;

  _PersonDetailsPageState();

  @override
  void initState() {
    super.initState();
    _person = widget.person;
    final detailCriteria = SearchCriteriaDTO();
    detailCriteria.criteriaTitle = _person.uniqueId;
    _getDetails(detailCriteria);
  }

  /// Fetch full person details from cache or imdb.
  Future _getDetails(
    SearchCriteriaDTO criteria,
  ) async {
    final thread = SlowThread.namedThread('SlowThread');
    print(
        'Temp-_PersonDetailsPageState._getDetails: checking cache for $criteria');
    final fastResults = await thread.run(_getCachedDetails, criteria);

    if (fastResults is List<MovieResultDTO> && fastResults.isNotEmpty) {
      print(
          'Temp-_PersonDetailsPageState._getDetails: got cache merging details');
      setState(() => mergeDetails(fastResults));
    } else {
      print('Temp-_PersonDetailsPageState._getDetails: uncached, getting slow');
      final slowResults = await _getIMDBPersonDetails(criteria);
      setState(() => mergeDetails(slowResults));
    }
  }

  /// Fetch person details from imdb in current thread.
  Future<List<MovieResultDTO>> _getIMDBPersonDetails(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBNameDetails().readList(criteria);

  /// Fetch person details from cache maintained by a seperate thread.
  static Future<List<MovieResultDTO>> _getCachedDetails(
    SearchCriteriaDTO criteria,
  ) =>
      QueryIMDBNameDetails().readCachedList(criteria);

  void mergeDetails(List<MovieResultDTO> details) {
    for (final dto in details) {
      _person.merge(dto);
    }
  }

  @override
  // The restoration bucket id for this page.
  String get restorationId => 'PersonDetails${_person.uniqueId}';

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

  @override
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
      children: <Widget>[
        SelectableText(_person.title, style: hugeFont),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            if (_person.yearRange.isEmpty)
              Text('Born: ${_person.year.toString()}')
            else
              Text('Lifespan: ${_person.yearRange}'),
          ],
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ExpandedColumn(children: <Widget>[leftColumn()]),

              // Only show right column on tablet
              if (!_mobileLayout) ExpandedColumn(children: [posterSection()])
            ],
          ),
        ),
      ],
    );
  }

  Widget leftColumn() {
    return Wrap(
      children: <Widget>[
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
              child: const Text('IMDB'),
            ),

            // Only show poster in left column on mobile
            if (_mobileLayout) posterSection(),

            Text(
              '\nDescription: \n${_person.description} ',
              style: biggerFont,
            ),
          ] +
          related(),
    );
  }

  Widget posterSection() {
    return Row(
      children: <Widget>[
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
    );
  }

  List<Widget> related() {
    final categories = <Widget>[];
    for (final category in _person.related.entries) {
      final rolesMap = category.value;
      final rolesLabel = category.key;
      final description = rolesMap.toShortString(); // Get a list of movie roles
      categories.add(BoldLabel('$rolesLabel:'));
      categories.add(
        Center(
          child: GestureDetector(
            onTap: () => searchForRelated(
              // Open search details when tapped.
              '$rolesLabel: ${_person.title}',
              rolesMap.values.toList(),
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
