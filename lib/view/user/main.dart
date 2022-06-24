import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/launcher.dart';

import '/core/main.dart';
import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';
part 'state.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;

  static const route = '/user';
  static const icon = Icons.person;
  static const name = 'User';
  static const description = 'user';
  static final uniqueKey = UniqueKey();

  @override
  State<StatefulWidget> createState() => _View();
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewPage(
        controller: scrollController,
        child: Consumer<Authentication>(
          builder: middleware,
        ),
      ),
    );
  }

  Widget middleware(BuildContext context, Authentication aut, Widget? child) {
    return CustomScrollView(
      controller: scrollController,
      slivers: sliverWidgets(),
    );
  }

  List<Widget> sliverWidgets() {
    return [
      ViewHeaderSliverSnap(
        pinned: true,
        floating: false,
        padding: MediaQuery.of(context).viewPadding,
        heights: const [kToolbarHeight, 100],
        overlapsBackgroundColor: Theme.of(context).primaryColor,
        overlapsBorderColor: Theme.of(context).shadowColor,
        builder: bar,
      ),
      PullToActivate(
        onUpdate: () async {
          await core.poll.updateAll();
          setState(() {});
        },
      ),
      // SliverToBoxAdapter(child: Text(authenticate.message)),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        sliver: FutureBuilder(
          future: Future.microtask(() => true),
          builder: (_, snap) {
            if (snap.hasData) {
              if (authenticate.hasUser) {
                return profileContainer();
              }
              return signInContainer();
            }
            return const SliverToBoxAdapter();
          },
        ),
      ),
      WidgetUserTheme(
        preference: preference,
      ),
      WidgetUserLocale(
        preference: preference,
      ),

      WidgetUserAccount(
        preference: preference,
        authenticate: authenticate,
        children: pollList(),
      ),

      SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverToBoxAdapter(
          child: Column(
            children: [
              Text(
                collection.env.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).primaryColorDark,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text.rich(
                  TextSpan(
                    text: 'v',
                    children: [
                      TextSpan(
                        text: collection.env.version,
                        style: TextStyle(color: Theme.of(context).disabledColor),
                      ),
                    ],
                  ),
                  // style: TextStyle(color: Theme.of(context).focusColor),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).focusColor,
                      ),
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: preference.language('About'),
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                      recognizer: TapGestureRecognizer()..onTap = _launchAppCode,
                    ),
                    const TextSpan(text: ' & '),
                    TextSpan(
                      text: preference.language('Privacy'),
                      style: TextStyle(color: Theme.of(context).primaryColorDark),
                      recognizer: TapGestureRecognizer()..onTap = _launchPrivacy,
                    ),
                  ],
                ),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).focusColor,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: Text.rich(
                  TextSpan(
                    children: [
                      // const TextSpan(text: 'issues that need to be '),
                      const TextSpan(text: 'About issue and pull request that need '),
                      const TextSpan(text: 'attention'),
                      const TextSpan(text: ' / '),
                      const TextSpan(text: 'feature that you would like to use can be provided '),
                      TextSpan(
                        text: 'here',
                        style: TextStyle(color: Theme.of(context).primaryColorDark),
                        recognizer: TapGestureRecognizer()..onTap = _launchAppIssues,
                      ),
                      const TextSpan(text: '...'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: Theme.of(context).focusColor,
                      ),
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
    return WidgetBlockSection(
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          // alignment: Alignment.centerLeft,
          label: preference.text.wouldYouLiketoSignIn,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
        child: ListBody(
          children: [
            SignInButton(
              icon: LideaIcon.google,
              label: 'Sign in with Google',
              onPressed: () {
                authenticate.signInWithGoogle().whenComplete(whenCompleteSignIn);
              },
            ),
            if (authenticate.showApple)
              SignInButton(
                icon: LideaIcon.apple,
                label: 'Sign in with Apple',
                onPressed: () {
                  authenticate.signInWithApple().whenComplete(whenCompleteSignIn);
                },
              ),
            if (authenticate.showFacebook)
              SignInButton(
                // icon: LideaIcon.facebook,
                // label: 'Login with Facebook',
                label: 'Continue with Facebook',
                onPressed: () {
                  authenticate.signInWithFacebook().whenComplete(whenCompleteSignIn);
                },
              ),

            // SignInButton(
            //   icon: LideaIcon.microsoft,
            //   label: 'Sign in with Microsoft',
            //   onPressed: null,
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
    return WidgetBlockSection(
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          // label: authenticate.user!.displayName,
          label: authenticate.userDisplayname,
          labelStyle: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      // footerTitle: WidgetBlockTile(
      //   title: WidgetLabel(
      //     // alignment: Alignment.centerLeft,
      //     label: preference.text.bySigningIn,
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
        child: ListBody(
          children: [
            WidgetLabel(
              // label: authenticate.user!.email!,
              label: authenticate.userEmail,
              // label: 'khensolomon@gmail.com',
              labelStyle: Theme.of(context).textTheme.labelSmall,
            ),

            // Text(
            //   authenticate.id,
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }

  List<WidgetButton> pollList() {
    return List.generate(
      poll.userPollBoard.length,
      (index) {
        final element = poll.userPollBoard.elementAt(index);
        return WidgetButton(
          child: WidgetLabel(
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
            core.navigate(to: '/launch/poll');
          },
        );
      },
    );
  }
}
