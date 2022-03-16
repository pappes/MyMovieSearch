import 'package:flutter_test/flutter_test.dart' as tst;

import 'package:my_movie_search/movies/screens/widgets/controls.dart';

import '../test_helper.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  tst.testWidgets('Poster without a valid url shows placeholder text',
      (tst.WidgetTester tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(
      TestApp(children: [
        Poster(url: 'stuff'),
      ]),
    );

    // Create the Finders.
    final imageFinder = tst.find.text('NoImage');

    tst.expect(imageFinder, tst.findsOneWidget);
  });

// All URLs are currently throwing HTTP 400 (https and http)
  // testWidgets('Poster with a valid url does not show placeholder text',
  //     (WidgetTester tester) async {
  //   // Create the widget by telling the tester to build it.
  //   await tester.pumpWidget(const TestApp(
  //       url:
  //           'http://www.learningcontainer.com/wp-content/uploads/2020/08/Sample-Small-Image-PNG-file-Download.png'));

  //   // Create the Finders.
  //   final imageFinder = find.text('NoImage');

  //   expect(imageFinder, findsNothing);
  // });
}
