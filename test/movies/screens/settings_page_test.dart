import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/screens/settings_page.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});

    final newValues = <SettingKey, String>{
      .magnetServer: 'http://old-server',
      .magnetPort: '8080',
      .magnetUsername: 'old-user',
      .magnetPassword: 'old-password',
      .loggingKey: 'old-logging-key',
      .googleUrl: 'http://google',
      .googleKey: 'g-key',
      .omdbKey: 'o-key',
      .tmdbKey: 't-key',
      .tvdbKey: 'tv-key',
      .meiliUrl: 'http://meili',
      .meiliSearchKey: 'ms-key',
      .meiliAdminKey: 'ma-key',
      .firebaseSecretsLocation: 'secret-loc',
      .seVirtualMachineKey: 'se-key',
    };

    Settings()
      ..offline = false
      ..saveToLocal(newValues);
  });

  testWidgets('SettingsPage renders correctly and updates Settings', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));

    // Wait for animation
    await tester.pumpAndSettle();

    // Verify some initial values
    expect(find.text('http://old-server'), findsOneWidget);
    expect(find.text('g-key'), findsOneWidget);
    expect(find.text('ms-key'), findsOneWidget);

    // Enter new values (only testing a few to keep test concise,
    // but covering the main path)
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Server URL'),
      'http://new-server',
    );
    await tester.enterText(find.widgetWithText(TextFormField, 'Port'), '9091');
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Google Key'),
      'new-g-key',
    );

    // Close the form, which saves the settings
    (tester.state(find.byType(Navigator)) as NavigatorState).pop();
    await tester.pumpAndSettle();

    // Verify Settings singleton was updated
    expect(Settings().magnetServer, 'http://new-server');
    expect(Settings().magnetPort, '9091');
    expect(Settings().googleKey, 'new-g-key');

    // Verify SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('MAGNET_SERVER'), 'http://new-server');
    expect(prefs.getString('MAGNET_PORT'), '9091');
    expect(prefs.getString('GOOGLE_KEY'), 'new-g-key');
  });
}
