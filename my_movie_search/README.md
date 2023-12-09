# my_movie_search

An applicaion for searching movies.

## Getting Started

Before compiling, rename the file assets/secrets.json.template to assets/secrets.json 
and if required, enter your own API keys.

To rebuild test mocks after major changes run
```flutter pub run build_runner build --delete-conflicting-outputs```

ADB tip: to install on a device that is not directly connected to the dev machine, use wireless debugging or a remote adb server

wireless debugging:
```
adb pair 192.168.86.21:12345 <enter pairing code>
adb connect 192.168.86.21:54321
adb devices
flutter install
```

remote server that has already run the command ```adb -a -P 8080 nodaemon server```
```
adb -H 192.168.86.189 -P 8080 devices
adb -H 192.168.86.189 -P 8080 install build/app/outputs/apk/release/app-release.apk
```