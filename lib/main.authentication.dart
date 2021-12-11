import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view.dart';
import 'package:lidea/authentication.dart';

import 'package:bible/core.dart';
import 'package:bible/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);

  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

  final authentication = Authentication();
  await authentication.ensureInitialized();

  final core = Core(authentication);
  await core.ensureInitialized();

  final settings = SettingsController(SettingsService(core.collection));
  await settings.ensureInitialized();

  runApp(LaiSiangtho(
    core: core,
    settings: settings,
    authentication: authentication,
  ));
}

class LaiSiangtho extends StatelessWidget {
  const LaiSiangtho({
    Key? key,
    required this.core,
    required this.settings,
    required this.authentication,
  }) : super(key: key);

  final Authentication authentication;
  final Core core;
  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ViewScrollNotify>(
          create: (context) => ViewScrollNotify(),
        ),
        ChangeNotifierProvider<Core>(
          create: (context) => core,
        ),
        ChangeNotifierProvider<SettingsController>(
          create: (context) => settings,
        ),
        ChangeNotifierProvider<Authentication>(
          create: (context) => authentication,
        ),
      ],
      child: start(),
    );
  }

  Widget start() {
    return const MaterialApp(
      title: 'Lai Siangtho',
      home: AuthWait(message: 'done'),
    );
  }
}

class AuthWait extends StatefulWidget {
  const AuthWait({Key? key, required this.message}) : super(key: key);
  final String message;

  @override
  State<AuthWait> createState() => _AuthWaitState();
}

class _AuthWaitState extends State<AuthWait> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Authentication>(
        builder: builder,
      ),
    );
  }

  Widget builder(BuildContext context, Authentication auth, Widget? child) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(auth.message),
          Text(auth.user != null ? 'yes' : 'none'),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: const [
          //     Text('Signin'),
          //     Text('Signout'),
          //   ],
          // )
          // ClipOval(
          //   child: Material(
          //     child: Image.network(
          //       auth.user!.photoURL!,
          //       fit: BoxFit.fitHeight,
          //     ),
          //   ),
          // ),
          userProfilePhoto(auth.user),
          (auth.user != null)
              ? OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await auth.signOut();
                  },
                  child: const Text('Sign out'),
                )
              : userSignIn(auth)
        ],
      ),
    );
  }

  Widget userSignIn(Authentication auth) {
    return Column(
      children: [
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            await auth.signInWithGoogle();
          },
          child: const Text('Sign in with Google'),
        ),
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            await auth.signInWithFacebook();
          },
          child: const Text('Sign in with Facebook'),
        ),
        OutlinedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
          onPressed: () async {
            await auth.signOut();
          },
          child: const Text('Sign out'),
        )
      ],
    );
  }

  Widget userProfilePhoto(User? user) {
    if (user != null) {
      if (user.photoURL != null) {
        return ClipOval(
          child: Material(
            child: Image.network(
              user.photoURL!,
              fit: BoxFit.fitHeight,
            ),
          ),
        );
      }
      return ClipOval(
        child: Material(
          child: Text(user.displayName!),
        ),
      );
    }
    return const ClipOval(
      child: Material(
        color: Colors.red,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Icon(
            Icons.person,
            size: 60,
          ),
        ),
      ),
    );
    // return photo(user);
  }

  Widget photo(User? user) {
    return Row(
      children: [
        OutlinedButton(
          style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            fixedSize: MaterialStateProperty.all(const Size.fromHeight(25)),
            shape: MaterialStateProperty.all(const CircleBorder()),
          ),
          onPressed: () async {},
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipOval(
              child: Image.network(
                user!.photoURL!,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // child: Text('sdf'),
        ),
        OutlinedButton(
          style: ButtonStyle(
            // backgroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
            fixedSize: MaterialStateProperty.all(const Size.fromHeight(25)),
            shape: MaterialStateProperty.all(const CircleBorder()),
          ),
          onPressed: () async {},
          child: const Padding(
            padding: EdgeInsets.all(3.0),
            child: ClipOval(
              child: Material(
                color: Colors.grey,
                child: Icon(
                  Icons.person,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
        CupertinoButton(
          color: Colors.grey,
          padding: EdgeInsets.zero,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          minSize: 30,
          child: const ClipOval(
            child: Icon(
              Icons.person,
              size: 25,
            ),
          ),
          onPressed: () async {},
        ),
        CupertinoButton(
          color: Colors.grey,
          minSize: 30,
          padding: EdgeInsets.zero,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          child: ClipOval(
            child: Image.network(
              user.photoURL!,
              fit: BoxFit.fitHeight,
              height: 27,
            ),
          ),
          onPressed: () async {},
        ),
        ClipOval(
          child: Material(
            color: Colors.grey,
            child: Image.network(
              user.photoURL!,
              fit: BoxFit.fitHeight,
              height: 28,
              width: 28,
            ),
          ),
        ),
        const ClipOval(
          child: Material(
            color: Colors.grey,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.person,
                size: 28,
              ),
            ),
          ),
        )
      ],
    );
  }
}
