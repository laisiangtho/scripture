# Bible@Lai Siangtho

![alt text][logo]

Lai Siangtho is 'the Holy Bible' app, and the continuous version of what we have released in 2008 that was saying "somehow we wanna serve resource which may seem any sense with you". There has been a huge improvement, and one of the biggest was developed using Flutter, which mean running on Multi-platform.

...at [Google play][playStore],
[Join][playStore Join],
or [readme][Home]!

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
- သမ္မာကျမ်း (ခေတ်သုံ)
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

Take a look: https://en.wikipedia.org/wiki/Zo_people

## Android

### minSdkVersion=16

- [x] `flutter build appbundle --release`
- [ ] `flutter build appbundle --target-platform android-arm,android-arm64`
- [ ] `flutter build apk --release --target-platform=android-arm`
- [ ] `flutter build appbundle --release --target-platform=android-arm`
- [ ] `flutter run --release --target-platform=android-arm`

### minSdkVersion=21

- [ ] `flutter build appbundle --release --target-platform=android-arm64`
- [ ] `flutter build apk --release --target-platform=android-arm64`
- [ ] `flutter run --target-platform=android-arm64`
- [ ] `flutter run --enable-software-rendering --target-platform=android-arm64`
- [ ] `flutter build appbundle --release --target-platform=android-arm64`
- [ ] `flutter build apk --split-per-abi --release`

### analytics (debug on windows)

```Shell
cd C:\dev\android-sdk\platform-tools
adb shell setprop debug.firebase.analytics.app "com.laisiangtho.bible"
```

## Directory

- (production) android/key.properties
- (development) android/local.properties
- build/app/outputs/apk/release/app-release.apk
- android\gradle.properties
- android\app\build.gradle

## Android->release

  versionCode android-arm
  versionCode++ android-arm64

```Shell
git commit -m "Update docs to wiki"
git push origin master

git add .
git commit -a -m "commit" (do not need commit message either)
git push
```

[playStore]: https://play.google.com/store/apps/details?id=com.laisiangtho.bible
[playStore Join]: https://play.google.com/apps/testing/com.laisiangtho.bible/join
[Home]: https://github.com/laisiangtho/development

[logo]: https://raw.githubusercontent.com/laisiangtho/development/master/bible.png "Lai Siangtho"

## How would I clone correctly

All you need is basically a Github command line, flutter, and modify a few settings, such as version, packageName for Android or Bundle Identifier for iOS. Since `com.laisiangtho.bible` has already taken you would need you own. It does not need to be a domain path but just uniqueid, so you should not take "~~com.google~~" or anything that you don't own!

### for Android

...you will need your own configuration in the following files

- `android/local.properties`

  ```Shell
  sdk.dir=pathOf-android-sdk
  flutter.sdk=pathOf-flutter-sdk
  ```

- `android/key.properties`

  ```Shell
  storePassword = STORE-FIILE-PASSWORD
  keyPassword = KEY-FIILE-PASSWORD
  keyAlias = KEY-ALIAS-NAME
  storeFile = PATH-OF-JKS
  ```

- `android/app/google-services.json`

  This is a JSON formated file, you can get it from `Google console -> IAM & ADMIN -> Service Accounts`

### for iOS

- ?
