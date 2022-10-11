import 'package:flutter/foundation.dart';
import 'package:lidea/firebase/core.dart';
// import 'package:lidea/firebase/firestore.dart';

Future<void> initializeApp() async {
  if (kIsWeb) {
  } else {
    await Firebase.initializeApp();
  }
  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
