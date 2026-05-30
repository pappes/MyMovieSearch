import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_movie_search/movies/screens/settings_page.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});

    final newValues = <SettingKey, String>{
      SettingKey.magnetServer: 'http://old-server',
      SettingKey.magnetPort: '8080',
      SettingKey.magnetUsername: 'old-user',
      SettingKey.magnetPassword: 'old-password',
      SettingKey.loggingKey: 'old-logging-key',
      SettingKey.googleUrl: 'http://google',
      SettingKey.googleKey: 'g-key',
      SettingKey.omdbKey: 'o-key',
      SettingKey.tmdbKey: 't-key',
      SettingKey.tvdbKey: 'tv-key',
      SettingKey.meiliUrl: 'http://meili',
      SettingKey.meiliSearchKey: 'ms-key',
      SettingKey.meiliAdminKey: 'ma-key',
      SettingKey.firebaseSecretsLocation: 'secret-loc',
      SettingKey.seVirtualMachineKey: 'se-key',
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

    // Tap Save Settings
    // Ensure button is visible by scrolling
    await tester.ensureVisible(find.text('Save Settings'));
    await tester.tap(find.text('Save Settings'));
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

    // Verify snackbar
    expect(find.textContaining('Settings saved.'), findsOneWidget);
  });
}
