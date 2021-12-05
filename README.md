# Bible@Lai Siangtho

![alt text][logo]

Lai Siangtho is 'the Holy Bible' app, and the continuous version of what we have released in 2008 that was saying "somehow we wanna serve resource which may seem any sense with you". There has been a huge improvement, and one of the biggest was developed using Flutter, which mean running on Multi-platform.

...at [App Store][appstore],
[Google play][playStore],
or [clone](#how-would-i-clone-correctly)!

Lai Siangtho has currently:

- New International Version
- သမ္မာကျမ်း (ယုဒသန်)
- Det Danske Bibel
- Norsk Bibel
- Luther(German)
- La Bible Ostervald (French)
- Pathian Laisiangthou (Paite)
- Pathian Lehkhabu Thianghlim (Mizo:1917/1995)
- Lai Siangtho (Sizang)
- Lai Siangtho (Tedim)
- Baibal Thianghlim (Falam)
- Baibal Thiang (Hakha)
- Khazopa Chabu Pathaipa (Mara)
- Jinghpaw Common Language Bible
- သမ္မာကျမ်း (ခေတ်သုံး)
- Matu Bible
- Pathen Thutheng BU (Thadou)
- Lai Siengthou (Zou)
- King James Version
- World English Bible
- Bible in Basic English
- ကမ္ဘာသစ်ဘာသာပြန်ကျမ်း (နေ့စဉ်သုံး)

Feature:

- Parallel
- Bookmark
- Search
- Open Source
- Offline
- Customizable
- No authentication require
- No Ads
- Free

As it is active in develpment, please feel free to rate/write yours review, so that we can bring a better Bible app.

In case of wondering what "**Lai Siangtho**" is or means, I would like to give you a hint. Of course it means "_the Holy Bible_" in _zolai_. But what is zolai then? Well its a name of written language using by some folks from Myanmar and India, called themselve as zomi, and their spoken language is zopau/zokam. You may know them as _Chin, Tedim, Falam, Hakha, Paite, Mizo, Kuki_ and many more. Each one of them has their own dialect and tradition like swedish and norwegian, with no country but border seperation. Many of its people speak and understand other dialect. This is where Lai Siangtho app is needed. I have no economic profit on making this app. If you like this particular application and its experience you are much welcome to support in anyway you would like.

Lai Siangtho is not just providing builded/packaged app. But opensource that you would have you own making of the holy Bible.

Take a look: [https://en.wikipedia.org/wiki/Zo_people]

![alt text][license]
![alt text][flutterversion]

## How would I clone correctly

All you need is basically a Github command line, flutter, and modify a few settings, such as version, packageName for Android or Bundle Identifier for iOS. Since `com.laisiangtho.bible` has already taken you would need you own. It does not need to be a domain path but just uniqueid, so you should not take "~~com.google~~" or anything that you don't own!

There isn't an easy way to separate ui and logic in flutter, any related dart scripts that plays primary logic in this application are moved to [lidea repo][lidea] as a seperated package. But they will work the same as bundle scripts.

In `pubspec.yaml` remove local package `lidea` and uncomment git

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  ...
  # Local lidea package, development only
  # lidea:
  #   path: ../lidea
  # uncomments lines below
  lidea:
    git:
      url: git://github.com/laisiangtho/lidea.git
      ref: main
  ...
```

...you will need your own configuration in the following files, for more info please run `flutter doctor` or see [flutter config cli](tool#Flutter-config).

- `android/local.properties`

```sh
sdk.dir       = <android-sdk-path>
flutter.sdk   = <flutter-sdk-path>
```

- `android/key.properties`

```sh
storePassword = <store-file-password>
keyPassword   = <key-file-password>
keyAlias      = <key-alias-name>
storeFile     = <path-of-jks>
```

- `android/app/google-services.json`

This is a JSON formated file, you can get it from `Google console -> IAM & ADMIN -> Service Accounts`

- Re-Useable
  - [`idea`](#idea)
    - Top layer responsible for theme color and font-size
  - [`scroll`](#scroll)
    - Primary view scroll gesture for bar, body bottom
  - [`util`](#util)
    - reading and writing file

## Android

- [build](tool#flutter-build-android)

```sh
flutter build appbundle --release
```

- analytics (debug on windows)

```sh
# Powershell
cd $env:UserProfile/.dev/sdk/platform-tools
# Command Prompt
cd %UserProfile%/.dev/sdk/platform-tools

adb shell setprop debug.firebase.analytics.app "com.laisiangtho.bible"
```

## iOS

- [build](tool#flutter-build-ios)

```sh
flutter clean && flutter pub get
rm ios/Podfile && install pod
cd .. && flutter build ios
```

## CLI

- [Flutter](tool#flutter)
  - [config](tool#flutter-config)
  - [build](tool#flutter-config)
    - [Android](tool#flutter-build-android)
    - [iOS](tool#flutter-build-ios)
- Path
  - [JAVA_HOME](tool#path-javahome)
  - [keytool](tool#path-keytool)
  - [flutter](tool#path-flutter)
- [gradlew](tool#gradlew)
  
```sh
cd android
./gradlew signingReport
./gradlew installDebug
```

See [Path configuration](tool#path-keytool) and [keytool](tool#keytool) cli.

- [keytool](tool#keytool)
  - [Generate](tool#keytool-generate)
  - [List](tool#keytool-list)
  - [Export](tool#keytool-export)
- [git](tool#git)

[playStore]: https://play.google.com/store/apps/details?id=com.laisiangtho.bible
[playStore Join]: https://play.google.com/apps/testing/com.laisiangtho.bible/join
[appstore]: https://apps.apple.com/au/app/lai-siangtho/id600127635
[Home]: https://github.com/laisiangtho/development
[lidea]: https://github.com/laisiangtho/lidea
[tool]: ./TOOL.md

[logo]: https://raw.githubusercontent.com/laisiangtho/development/master/bible.png "Lai Siangtho"
[license]: https://img.shields.io/badge/License-MIT-yellow.svg "License"
[flutterversion]: https://img.shields.io/badge/flutter-%3E%3D%202.12.0%20%3C3.0.0-green.svg "Flutter version"
