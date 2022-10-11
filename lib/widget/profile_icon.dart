import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/user/main.dart';

import '../app.dart';

class UserProfileIcon extends UserIconWidget {
  const UserProfileIcon({Key? key}) : super(key: key);

  @override
  bool get userSignedIn => App.authenticate.hasUser;
  @override
  String? get userPhotoURL => App.authenticate.userPhotoURL;

  @override
  Widget build(BuildContext context) {
    App.route.show('a');
    return ViewButton(
      message: App.preference.text.option(true),

      onPressed: () => App.route.pushNamed('home/user'),
      child: Selector<Authenticate, bool>(
        selector: (_, e) => e.hasUser,
        builder: (BuildContext _, bool hasUser, Widget? child) {
          return super.build(context);
          // return const Icon(
          //   Icons.face_retouching_natural_rounded,
          // );
        },
      ),
      // child: AnimatedBuilder(
      //   animation: App.authenticate,
      //   builder: (BuildContext _, Widget? child) {
      //     return super.build(context);
      //     // return const Icon(
      //     //   Icons.face_retouching_natural_rounded,
      //     // );
      //   },
      // ),
    );
    // WidgetButton(
    //   message: preference.text.option(true),
    //   onPressed: () => core.navigate(to: '/user'),
    //   child: WidgetMark(
    //     child: Selector<Authentication, bool>(
    //       selector: (_, e) => e.hasUser,
    //       builder: (BuildContext _, bool hasUser, Widget? child) {
    //         return UserIcon(authenticate: authenticate);
    //       },
    //     ),
    //   ),
    // )
  }
}
