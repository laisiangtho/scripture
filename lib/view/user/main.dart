import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
// import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/launcher.dart';

import 'package:lidea/view/user/main.dart';
// import 'package:lidea/view/demo/translate.dart';

import '../../app.dart';
import '/widget/button.dart';

part 'state.dart';
part 'header.dart';

class Main extends StatefulWidget {
  const Main({super.key, this.arguments});
  final Object? arguments;

  static String route = '/user';
  static String label = 'User';
  static IconData icon = Icons.person;

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Header {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Views(
        // scrollBottom: ScrollBottomNavigation(
        //   listener: _controller.bottom,
        //   notifier: viewData.bottom,
        // ),
        child: Consumer<Authenticate>(
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext context, Authenticate aut, Widget? child) {
    return CustomScrollView(
      controller: _controller,
      slivers: sliverWidgets(),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliver(
        pinned: true,
        floating: false,
        // reservedPadding: MediaQuery.of(context).padding.top,
        padding: state.fromContext.viewPadding,
        heights: const [kToolbarHeight, 100],
        // overlapsBackgroundColor: state.theme.primaryColor,
        overlapsBorderColor: state.theme.dividerColor,
        builder: _header,
      ),
      // DemoTranslate(
      //   itemCount: preference.text.itemCount,
      //   itemCountNumber: preference.text.itemCountNumber,
      //   formatDate: preference.text.formatDate,
      //   confirmToDelete: preference.text.confirmToDelete,
      //   formatCurrency: preference.text.formatCurrency,
      // ),
      // PullToActivate(
      //   onUpdate: () async {
      //     // await core.poll.updateAll();
      //     // setState(() {});
      //   },
      // ),
      // SliverToBoxAdapter(child: Text(authenticate.message)),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        sliver: FutureBuilder(
          future: Future.microtask(() => true),
          builder: (_, snap) {
            if (snap.hasData) {
              if (App.authenticate.hasUser) {
                return profileContainer();
              }
              return signInContainer();
            }
            return const SliverToBoxAdapter();
          },
        ),
      ),
      UserThemeWidget(
        preference: App.preference,
      ),
      UserLocaleWidget(
        preference: App.preference,
      ),

      UserAccountWidget(
        preference: App.preference,
        authenticate: App.authenticate,
        children: pollList(),
      ),

      SliverPadding(
        // padding: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              Text(
                // App.core.data.env.name.toUpperCase(),
                preference.text.holyBible,
                // style: Theme.of(context).textTheme.titleMedium!.copyWith(
                //       color: Theme.of(context).primaryColorDark,
                //     ),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              // ViewMark(
              //   badge: data.env.name,
              //   label: preference.text.holyBible,
              // ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'v',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: App.core.data.env.version,
                        // text: preference.digit(App.core.data.env.version),
                        // style: TextStyle(color: Theme.of(context).primaryColorDark),
                      ),
                      TextSpan(
                        text: '-',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      TextSpan(
                        text: App.core.data.env.buildNumber,
                        // text: preference.digit(App.core.data.env.buildNumber),
                        // style: TextStyle(color: Theme.of(context).primaryColorDark),
                      ),
                    ],
                  ),
                  // style: TextStyle(color: Theme.of(context).focusColor),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).primaryColorDark,
                      ),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      // text: preference.language('About'),
                      text: preference.text.about,
                      // style: TextStyle(color: Theme.of(context).primaryColorDark),
                      recognizer: TapGestureRecognizer()..onTap = _launchAppCode,
                    ),
                    TextSpan(
                      text: ' & ',
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                    ),
                    TextSpan(
                      // text: preference.language('Privacy'),
                      text: preference.text.privacy,
                      // style: TextStyle(color: Theme.of(context).primaryColorDark),
                      recognizer: TapGestureRecognizer()..onTap = _launchPrivacy,
                    ),
                  ],
                ),
                // style: Theme.of(context).textTheme.labelMedium!.copyWith(
                //       color: Theme.of(context).focusColor,
                //     ),
                style: state.textTheme.titleSmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                // child: Text.rich(
                //   TextSpan(
                //     // text: preference.language('issue-pull-feature'),
                //     children: textDecoration(
                //       text: preference.language('issue-pull-feature'),
                //       decoration: [
                //         TextSpan(
                //           text: 'Github',
                //           style: TextStyle(color: Theme.of(context).colorScheme.error),
                //           recognizer: TapGestureRecognizer()..onTap = _launchAppIssues,
                //         ),
                //       ],
                //     ),
                //   ),
                //   textAlign: TextAlign.center,
                //   // style: Theme.of(context).textTheme.labelMedium!.copyWith(
                //   //       color: Theme.of(context).primaryColorDark,
                //   //     ),
                //   style: state.textTheme.bodySmall,
                // ),
                child: TextDecoration(
                  text: preference.language('issue-pull-feature'),
                  decoration: [
                    TextSpan(
                      text: 'Github',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                      recognizer: TapGestureRecognizer()..onTap = _launchAppIssues,
                      semanticsLabel: 'Github',
                    ),
                  ],
                  textAlign: TextAlign.center,
                  style: state.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),

      // Selector<ViewScrollNotify, double>(
      //   selector: (_, e) => e.bottomPadding,
      //   builder: (context, bottomPadding, child) {
      //     return SliverPadding(
      //       padding: EdgeInsets.only(bottom: bottomPadding),
      //       sliver: child,
      //     );
      //   },
      // ),
    ];
  }

  Widget signInContainer() {
    return ViewSection(
      padding: EdgeInsets.zero,
      headerTitle: ViewSectionTitle(
        title: ViewLabel(
          // alignment: Alignment.centerLeft,
          alignment: Alignment.center,
          label: preference.text.wouldYouLiketoSignIn,
        ),
      ),
      // headerTitle: const ViewLabel(
      //   // icon: LideaIcon.switchArrow,
      //   label: "center",
      //   labelPadding: EdgeInsets.zero,
      //   padding: EdgeInsets.zero,
      //   margin: EdgeInsets.zero,
      //   alignment: Alignment.center,
      //   // textAlign: TextAlign.center,
      // ),
      // headerTitle: const Text(
      //   "center",
      //   textAlign: TextAlign.center,
      // ),
      // headerLeading: const Icon(Icons.light_mode_rounded),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
        child: ListBody(
          children: [
            SignInButton(
              icon: LideaIcon.google,
              label: 'Sign in with Google',
              onPressed: () {
                App.authenticate.signInWithGoogle().whenComplete(whenCompleteSignIn);
              },
            ),

            if (App.authenticate.showApple)
              SignInButton(
                icon: LideaIcon.apple,
                label: 'Sign in with Apple',
                onPressed: () {
                  App.authenticate.signInWithApple().whenComplete(whenCompleteSignIn);
                },
              ),
            if (App.authenticate.showFacebook)
              SignInButton(
                icon: LideaIcon.facebook,
                label: 'Continue with Facebook',
                onPressed: () {
                  App.authenticate.signInWithFacebook().whenComplete(whenCompleteSignIn);
                },
              ),

            // SignInButton(
            //   icon: LideaIcon.microsoft,
            //   label: 'Sign in with Microsoft',
            //   onPressed: null,
            // ),
            // SignInButton(
            //   icon: LideaIcon.microsoft,
            //   label: 'to Poll',
            //   onPressed: () {
            //     route.pushNamed('/home/user/poll');
            //   },
            // ),
            // SignInButton(
            //   icon: LideaIcon.github,
            //   label: 'Sign in with GitHub',
            //   onPressed: null,
            // ),
          ],
        ),
      ),

      // footerTitle: WidgetBlockTile(
      //   title: WidgetLabel(
      //     // alignment: Alignment.centerLeft,
      //     label: preference.text.bySigningIn,
      //   ),
      // ),
    );
  }

  Widget profileContainer() {
    return ViewSection(
      headerTitle: ViewLabel(
        // label: authenticate.user!.displayName,
        label: App.authenticate.userDisplayname,
        labelStyle: Theme.of(context).textTheme.titleLarge,
        // alignment: Alignment.center,
      ),
      // footerTitle: ViewLabel(
      //   // alignment: Alignment.centerLeft,
      //   label: preference.text.bySigningIn,
      //   labelStyle: Theme.of(context).textTheme.labelSmall,
      // ),
      child: ViewLabel(
        // label: App.authenticate.user!.email!,
        label: App.authenticate.userEmail,
        // label: 'khensolomon@gmail.com',
        labelStyle: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }

  List<ViewButton> pollList() {
    // return [];
    return List.generate(
      poll.userPollBoard.length,
      (index) {
        final element = poll.userPollBoard.elementAt(index);
        return ViewButton(
          child: ViewLabel(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            alignment: Alignment.centerLeft,
            icon: Icons.how_to_vote_outlined,
            label: element.info.title,
            labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            labelStyle: Theme.of(context).textTheme.bodyLarge,
            softWrap: true,
            maxLines: 3,
          ),
          onPressed: () {
            poll.tokenId = element.gist.token.id;
            // core.navigate(to: '/launch/poll');
            route.pushNamed('/home/user/poll');
          },
        );
      },
    );
  }
}
