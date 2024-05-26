import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_search/persistence/firebase/firebase_common.dart';
import 'package:my_movie_search/utilities/settings.dart';
import 'package:universal_io/io.dart';

import 'settings_test.mocks.dart';

@GenerateMocks([FirebaseApplicationState])
void main() {
  group('getSecretsServiceAccount', () {
    test('returns null for invalid secretsLocation format', () async {
      // Arrange
      final mockFb = MockFirebaseApplicationState();
      final settings = Settings();

      // Act
      final result = await settings.getSecretsServiceAccount(
        mockFb,
        'invalid_format',
      );

      // Assert
      expect(result, isNull);
    });

    test('returns null for non-existent record', () async {
      // Arrange
      final mockFb = MockFirebaseApplicationState();
      final settings = Settings();
      when(mockFb.fetchRecord('collection', id: 'id'))
          .thenAnswer((_) async => null);

      // Act
      final result = await settings.getSecretsServiceAccount(
        mockFb,
        'collection/id',
      );

      // Assert
      expect(result, isNull);
    });

    test('returns secret from record', () async {
      // Arrange
      final mockFb = MockFirebaseApplicationState();
      final settings = Settings();
      when(mockFb.fetchRecord('collection', id: 'id'))
          .thenAnswer((_) async => {'file': 'secret'});

      // Act
      final result = await settings.getSecretsServiceAccount(
        mockFb,
        'collection/id',
      );

      // Assert
      expect(result, 'secret');
    });

    test('returns secret from deeply stored record', () async {
      // Arrange
      final mockFb = MockFirebaseApplicationState();
      final settings = Settings();
      when(mockFb.fetchRecord('deeply/stored/collection', id: 'id'))
          .thenAnswer((_) async => {'file': 'secret'});

      // Act
      final result = await settings.getSecretsServiceAccount(
          mockFb, 'deeply/stored/collection/id');

      // Assert
      expect(result, 'secret');
    });

    group('getSecretFromEnv', () {
      test('returns environment variable value if set', () {
        // Arrange
        const environmentVar = 'PATH';
        const compiledValue = '';
        final environmentValue = Platform.environment[environmentVar];

        // Act
        final result =
            Settings().getSecretFromEnv(environmentVar, compiledValue);

        // Assert
        expect(result, environmentValue);
      });

      test('returns compiled value if environment variable is not set', () {
        // Arrange
        const environmentVar = 'MissingTEST_ENV_VAR';
        const compiledValue = 'compiled_value';

        // Act
        final result =
            Settings().getSecretFromEnv(environmentVar, compiledValue);

        // Assert
        expect(result, compiledValue);
      });

      test(
          'returns null if both environment variable and compiled value are not set',
          () {
        // Arrange
        const environmentVar = 'MissingTEST_ENV_VAR';
        const compiledValue = '';

        // Act
        final result =
            Settings().getSecretFromEnv(environmentVar, compiledValue);

        // Assert
        expect(result, isNull);
      });
    });
  });
}
