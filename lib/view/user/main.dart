import 'package:flutter/material.dart';

import 'package:lidea/launcher.dart';

import 'package:lidea/view/user/main.dart';

import '/app.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _View();
}

class _View extends UserProfiles<Main> {
  @override
  late final Core app = App.core;

  @override
  void launchAppCode() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture');
  }

  @override
  void launchPrivacy() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/blob/master/PRIVACY.md');
  }

  @override
  void launchAppIssues() {
    Launcher.universalLink('https://github.com/laisiangtho/scripture/issues/new');
  }

  @override
  List<Widget> userDesk() {
    return [
      // const UserDeskData(),
    ];
  }

  // late final poll = app.poll;
  // @override
  // List<ViewButtons> userDesk() {
  //   return List.generate(
  //     poll.userPollBoard.length,
  //     (index) {
  //       final element = poll.userPollBoard.elementAt(index);
  //       return ViewButtons(
  //         child: ViewLabels(
  //           padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
  //           alignment: Alignment.centerLeft,
  //           icon: Icons.how_to_vote_outlined,
  //           label: element.info.title,
  //           labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
  //           labelStyle: context.style.bodyLarge,
  //           softWrap: true,
  //           maxLines: 3,
  //         ),
  //         onPressed: () {
  //           poll.tokenId = element.gist.token.id;

  //           app.route.page.push('/user/poll');
  //         },
  //       );
  //     },
  //   );
  // }
}
