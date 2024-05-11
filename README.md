# my_movie_search

An application for searching movies.

## Getting Started

Before compiling it is recommended to generate your own API keys.
For all supported options for API keys see [Settings] in lib/utlities/settings.dart
From the command line at build time:
```shell
flutter build apk --dart-define OMDB_KEY="xxxxxxxx" --dart-define TMDB_KEY="xxxxxxxx" --dart-define GOOGLE_KEY="xxxxxxxx" --dart-define GOOGLE_URL="https://customsearch.googleapis.com/customsearch/v1?cx=821cd5ca4ed114a04&safe=off&key="
```

## Tips and Tricks

To rebuild test mocks after major changes run
```flutter pub run build_runner build --delete-conflicting-outputs```

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
adb -H 192.168.86.189 -P 8080 install build/app/outputs/apk/release/app-release.apk
```