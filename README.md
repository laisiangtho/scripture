# Bible@Lai Siangtho


## Android

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