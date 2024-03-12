import 'package:flutter/foundation.dart';
import 'package:lidea/firebase/core.dart';

const apiKey = "AIzaSyA0nhHqUvMrwxvII7GdczzSZAZOVjYhN6o";
const authDomain = "lai-siangtho.firebaseapp.com";
const projectId = "lai-siangtho";
const storageBucket = "lai-siangtho.appspot.com";
const messagingSenderId = "963172659306";
const appId = "1:963172659306:android:58a78cf32d98e487";
const databaseURL = 'https://lai-siangtho.firebaseio.com';
const measurementId = "G-P493VRQXQJ";
const androidClientId = "com.laisiangtho.bible";
const iosBundleId = 'zotune.willsol.zo.laisiangtho';
const iosClientId = '';
const macOSAndroidClientId = '';
const iOSAndroidClientId = '';

// if (kIsWeb) {
// } else {
//   await Firebase.initializeApp();
// }
// await Firebase.initializeApp();
// FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
// if (kIsWeb) {
//   // await Firebase.initializeApp(
//   //   // options: DefaultFirebaseOptions.currentPlatform,
//   //   // name: 'Lai Siangtho',
//   //   options: const FirebaseOptions(
//   //     apiKey: "AIzaSyBHbC6skHRMge6qdQsFC6As_fTXi0SJsbU",
//   //     authDomain: "lai-siangtho.firebaseapp.com",
//   //     databaseURL: "https://lai-siangtho.firebaseio.com",
//   //     projectId: "lai-siangtho",
//   //     storageBucket: "lai-siangtho.appspot.com",
//   //     messagingSenderId: "963172659306",
//   //     appId: "1:963172659306:web:c206d978fdb2d939cc5a13",
//   //     measurementId: "G-P493VRQXQJ",
//   //   ),
//   // );
// } else {
//   await Firebase.initializeApp();
// }
// await Firebase.initializeApp(
//   // options: DefaultFirebaseOptions.currentPlatform,
//   name: 'Lai Siangtho',
//   options: const FirebaseOptions(
//     apiKey: "AIzaSyA0nhHqUvMrwxvII7GdczzSZAZOVjYhN6o",
//     authDomain: "lai-siangtho.firebaseapp.com",
//     databaseURL: "https://lai-siangtho.firebaseio.com",
//     projectId: "lai-siangtho",
//     storageBucket: "lai-siangtho.appspot.com",
//     messagingSenderId: "963172659306",
//     appId: "1:963172659306:web:c206d978fdb2d939cc5a13",
//     measurementId: "G-P493VRQXQJ",
//   ),
// );

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: apiKey,
      authDomain: authDomain,
      projectId: projectId,
      storageBucket: storageBucket,
      messagingSenderId: messagingSenderId,
      appId: '1:963172659306:web:c206d978fdb2d939cc5a13');

  static const FirebaseOptions android = FirebaseOptions(
      apiKey: apiKey,
      appId: '1:963172659306:android:58a78cf32d98e487',
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      databaseURL: databaseURL,
      storageBucket: storageBucket,
      androidClientId: androidClientId);

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: apiKey,
    appId: '1:963172659306:ios:96572827fd2d897acc5a13',
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    databaseURL: databaseURL,
    storageBucket: storageBucket,
    androidClientId: iOSAndroidClientId,
    iosClientId: iosClientId,
    iosBundleId: iosBundleId,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: apiKey,
    appId: '1:963172659306:ios:96572827fd2d897acc5a13',
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    databaseURL: databaseURL,
    storageBucket: storageBucket,
    androidClientId: macOSAndroidClientId,
    iosClientId: iosClientId,
    iosBundleId: iosBundleId,
  );
}
