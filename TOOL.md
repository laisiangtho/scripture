# Tool

Back to [Readme](README.md).

## Flutter

create, analyze, test, and run an app:

```sh
# create
flutter create app_name
cd app_name

# analyze
flutter analyze

# test
flutter test

# run
flutter run lib/main.dart

# package
flutter pub get
flutter pub outdated
flutter pub upgrade

# To view all commands that flutter supports
flutter --help --verbose

# See the current version of the Flutter SDK, framework, engine & tools
flutter --version
```

## flutter: build Android

... minSdkVersion=16

```sh
flutter build appbundle --release
# flutter build appbundle --target-platform android-arm,android-arm64
# flutter build apk --release --target-platform=android-arm
# flutter build appbundle --release --target-platform=android-arm
# flutter run --release --target-platform=android-arm
```

... minSdkVersion=21

```sh
flutter build appbundle --release --target-platform=android-arm64
flutter build apk --release --target-platform=android-arm64
flutter run --target-platform=android-arm64
flutter run --enable-software-rendering --target-platform=android-arm64
flutter build appbundle --release --target-platform=android-arm64
flutter build apk --split-per-abi --release
```

## flutter: build iOS

As of firebase `platform :ios, '10.0'` need to set in *Podfile*.

`cd ios`

If `pod install` gives any error then try this
`pod install --repo-update`

- Runner->Project->Configurations

```sh
Debug
  Runner: Generated
    Runner: Pods-Runner.debug
Release
  Runner: Generated
    Runner: Pods-Runner.Release
Profile
  Runner: Generated
    Runner: Pods-Runner.Profile
```

- Runner->Project->Localizations

Add English, Burmese and Norwegian

```sh
...
```

## Flutter: config

- Powershell: `$env:UserProfile`
- Command Prompt: `%UserProfile%`

```sh
# flutter config --android-studio-dir <android-studio-dir>
# flutter config --android-sdk <android-sdk-path>

# Powershell
flutter config --android-studio-dir="$env:ProgramFiles/Android/Android Studio"
# Command Prompt
flutter config --android-studio-dir="%ProgramFiles%/Android/Android Studio"

flutter config --android-sdk="$env:UserProfile/.dev/sdk"
flutter config --android-sdk="%UserProfile%/.dev/sdk"
flutter config --android-sdk="$ANDROID_SDK"
```

## Path: JAVA_HOME

...Windows: `JAVA_HOME` is not set and no `java` command could be found in your PATH.

```sh
# Powershell
setx JAVA_HOME "$env:ProgramFiles\Android\Android Studio\jre"
# Command Prompt
setx JAVA_HOME "%ProgramFiles%\Android\Android Studio\jre"
```

## Path: keytool

...Windows

keytool and other

- keytool is not recognized
- Keystore file does not exist: `%UserProfile%`/.android/debug.keystore

```sh
# Powershell
setx PATH "$env:Path;$env:ProgramFiles\Android\Android Studio\jre\bin\"
# Command Prompt
setx PATH "%Path%;%ProgramFiles%\Android\Android Studio\jre\bin\"
```

## Path: flutter

...Windows

```sh
# Powershell
setx PATH "$env:Path;$env:UserProfile\.dev\flutter\bin"
# setx PATH "$env:Path;$env:OneDrive\env\bin"
# Command Prompt
setx PATH "%Path%;%UserProfile%\.dev\flutter\bin"
# setx PATH "%Path%;%OneDrive%\env\bin"
```

## Path: command-line

```sh
# setx /M path "%path%;C:\your\path\here\"
# PATH %PATH%;C:\xampp\php
```

## gradlew

```sh
cd android
./gradlew signingReport
./gradlew installDebug
```

## keytool

The certificate uses the SHA1withRSA signature algorithm which is considered a security risk. This algorithm will be disabled in a future update.

## keytool: generate

```sh
keytool -genkey -v -keystore "%UserProfile%/.android/debug.keystore" -alias androiddebugkey -keyalg RSA -sigalg SHA256withRSA -keysize 2048 -validity 10000
```

## keytool: list

```sh
# Powershell
keytool -list -alias androiddebugkey -keystore "$env:UserProfile/.android/debug.keystore"
keytool -list -v -alias lethil -keystore "$env:OneDrive/env/dev/laisiangtho/keystore.jks"
# Command Prompt
keytool -list -alias androiddebugkey -keystore "%UserProfile%/.android/debug.keystore"
keytool -list -v -alias lethil -keystore "%OneDrive%/env/dev/laisiangtho/keystore.jks"
```

## keytool: export

```sh
# Powershell
keytool -exportcert -v -alias androiddebugkey -keystore "$env:UserProfile/.android/debug.keystore"
keytool -exportcert -v -alias lethil -keystore "$env:OneDrive/env/dev/laisiangtho/keystore.jks"
# Command Prompt
keytool -exportcert -v -alias androiddebugkey -keystore "%UserProfile%/.android/debug.keystore"
keytool -exportcert -v -alias lethil -keystore "%OneDrive%/env/dev/laisiangtho/keystore.jks"
```

## git

```sh
git commit -m "Update docs to wiki"
git push origin master

git add .
git commit -a -m "commit" (do not need commit message either)
git push
```

## other

```sh
