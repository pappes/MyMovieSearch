# my_movie_search

An application for searching movies.

## Getting Started

For linux builds the libc6-dev c library is used for the linux_webview dart library
you may need to install it with:
sudo apt-get install libc6-dev

Before compiling it is recommended to generate your own API keys.
For all supported options for API keys see [Settings] in lib/utilities/settings.dart
From the command line at build time:
```shell
flutter build apk --flavor=prod --dart-define OMDB_KEY="xxxxxxxx" --dart-define TMDB_KEY="xxxxxxxx" \
        --dart-define MEILISEARCH_KEY="xxxxxxxx"  --dart-define GOOGLE_KEY="xxxxxxxx" \
        --dart-define TVDB_KEY="xxxxxxxx" \
        --dart-define GOOGLE_URL="xxxxxxxx" --dart-define SECRETS_LOCATION="xxxxxxxx" \
        --dart-define MAGNET_SERVER="xxxxxxxx" --dart-define MAGNET_PORT="xxxxxxxx" \
        --dart-define MAGNET_USERNAME="xxxxxxxx" --dart-define MAGNET_PASSWORD="xxxxxxxx" \
        --dart-define LOGGING_KEY="xxxxxxxx" \
        --dart-define OFFLINE="!true" 
```

## Secrets and API keys

Never commit real keys. The CI pipeline runs a [gitleaks](https://github.com/gitleaks/gitleaks)
scan on every push and pull request (see the `secrets-scan` job in
`.github/workflows/ci.yml`), and the repository is public.

The app reads settings (including API keys) from these sources, in order of
precedence (see the documentation in `lib/utilities/settings.dart`):

1. Compiled `--dart-define` values, e.g. `--dart-define TMDB_KEY="..."`.
2. Google Cloud Secret Manager, when `SECRETS_LOCATION` (the GCP project id)
   is provided via `--dart-define` or an environment variable.
3. Environment variables with the same names (`OMDB_KEY`, `TMDB_KEY`,
   `TVDB_KEY`, `MEILISEARCH_KEY`, `MEILIADMIN_KEY`, `GOOGLE_KEY`, `GOOGLE_URL`,
   `SECRETS_LOCATION`, `MAGNET_SERVER`, `MAGNET_PORT`, `MAGNET_USERNAME`,
   `MAGNET_PASSWORD`, `LOGGING_KEY`, `OFFLINE`).
4. SharedPreferences (the in-app settings page), as a fallback.

Notes:

- `assets/secrets.json` is a legacy local file kept out of source control by
  `.gitignore`; it is not read by the app. Use the mechanisms above instead.
- The Firebase configuration files (`lib/firebase_options.dart`,
  `android/app/google-services.json`, `.firebaserc`) contain public
  client-side identifiers, not secrets. The Firebase Web API key is not
  sufficient protection by itself: restrict it in the Google Cloud console
  (API and Android/iOS app restrictions), enable App Check, and configure
  Firestore security rules and Firebase Auth appropriately.
- Runtime secrets (e.g. the TVDB session token) are registered with
  `Secrets()` so they are redacted from logs.

## Tips and Tricks

To rebuild test mocks after major changes run
```dart run build_runner build```

ADB tip: to install on a device that is not directly connected to the dev machine, use wireless debugging or a remote adb server

wireless debugging:
```shell
adb pair 192.168.86.21:12345 <enter pairing code>
adb connect 192.168.86.21:54321
adb devices
flutter install
```

remote server that has already run the command ```adb -a -P 8080 nodaemon server```
```shell
adb -H 192.168.86.189 -P 8080 devices
adb -H 192.168.86.189 -P 8080 install build/app/outputs/apk/release/prod/app-prod-release.apk
```