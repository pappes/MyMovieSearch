# my_movie_search

An application for searching movies.

## Getting Started

For linux builds the libc6-dev c library is used for the linux_webview dart library
you may need to install it with:
sudo apt-get install libc6-dev

Before compiling it is recommended to generate your own API keys.
For all supported options for API keys see [Settings] in lib/utlities/settings.dart
From the command line at build time:
```shell
flutter build apk --flavor=prod --dart-define OMDB_KEY="xxxxxxxx" --dart-define TMDB_KEY="xxxxxxxx" \
        --dart-define MEILISEARCH_KEY="xxxxxxxx"  --dart-define GOOGLE_KEY="xxxxxxxx" \
        --dart-define GOOGLE_URL="xxxxxxxx" --dart-define SECRETS_LOCATION="xxxxxxxx" \
        --dart-define OFFLINE="!true" 
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