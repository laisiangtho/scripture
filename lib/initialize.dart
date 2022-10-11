import 'package:flutter/foundation.dart';
import 'package:lidea/firebase/core.dart';
// import 'package:lidea/firebase/firestore.dart';

Future<void> initializeApp() async {
  // await Firebase.initializeApp();
  // await Firebase.initializeApp(
  //   // options: DefaultFirebaseOptions.currentPlatform,
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyBHbC6skHRMge6qdQsFC6As_fTXi0SJsbU",
  //     authDomain: "lai-siangtho.firebaseapp.com",
  //     databaseURL: "https://lai-siangtho.firebaseio.com",
  //     projectId: "lai-siangtho",
  //     storageBucket: "lai-siangtho.appspot.com",
  //     messagingSenderId: "963172659306",
  //     appId: "1:963172659306:web:c206d978fdb2d939cc5a13",
  //     measurementId: "G-P493VRQXQJ",
  //   ),
  // );
  if (kIsWeb) {
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      // name: 'Lai Siangtho',
      options: const FirebaseOptions(
        apiKey: "AIzaSyBHbC6skHRMge6qdQsFC6As_fTXi0SJsbU",
        authDomain: "lai-siangtho.firebaseapp.com",
        databaseURL: "https://lai-siangtho.firebaseio.com",
        projectId: "lai-siangtho",
        storageBucket: "lai-siangtho.appspot.com",
        messagingSenderId: "963172659306",
        appId: "1:963172659306:web:c206d978fdb2d939cc5a13",
        measurementId: "G-P493VRQXQJ",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
