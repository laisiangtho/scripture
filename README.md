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
- Pathian Lehkhabu Thianghlim (Mizo)
- Lai Siangtho (Sizang)
- Lai Siangtho (Tedim)
- Baibal Thianghlim (Falam)
- Baibal Thiang (Hakha)
- Khazopa Chabu Pathaipa (Mara)
- Jinghpaw Common Language Bible
- သမ္မာကျမ်း (ခေတ်သုံ)
- Matu Bible

Feature:
- Bookmark
- Search
- Open Source
- Offline
- Customizable
- No authentication require
- No Ads
- Free

As it is active in develpment, please feel free to rate/write yours review, so that we can bring a better Bible app.

## Android

flutter build appbundle --target-platform android-arm,android-arm64

minSdkVersion=16

- [ ] `flutter build apk --release --target-platform=android-arm`
- [x] `flutter build appbundle --release --target-platform=android-arm`
- [ ] `flutter run --release --target-platform=android-arm`

minSdkVersion=21

- [ ] `flutter build apk --release --target-platform=android-arm64`
- [x] `flutter build appbundle --release --target-platform=android-arm64`
- [ ] `flutter run --target-platform=android-arm64`
- [ ] `flutter run --enable-software-rendering --target-platform=android-arm64`
- [ ] `flutter build appbundle --release --target-platform=android-arm64`

## Directory

- build/app/outputs/apk/release/app-release.apk
- android\gradle.properties
- android\app\build.gradle

flutter build apk --split-per-abi --release

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
