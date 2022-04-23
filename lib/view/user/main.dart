import 'package:flutter/material.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/cached_network_image.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/extension.dart';

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

      themeContainer(),
      localeContainer(),
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

  Widget profile() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          const Text('signed in'),
        ],
      ),
    );
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
              label: 'Google',
              onPressed: authenticate.signInWithGoogle,
            ),
            SignInButton(
              icon: LideaIcon.facebook,
              label: 'Facebook',
              onPressed: authenticate.signInWithFacebook,
            ),
            if (authenticate.isAvailableApple)
              SignInButton(
                icon: LideaIcon.apple,
                label: 'Apple',
                onPressed: authenticate.signInWithApple,
              )

            // SignInButton(
            //   icon: LideaIcon.microsoft,
            //   label: 'Microsoft',
            //   onPressed: null,
            // ),
            // SignInButton(
            //   icon: LideaIcon.github,
            //   label: 'GitHub',
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
      // footerTitle: WidgetBlockTile(
      //   title: WidgetLabel(
      //     // alignment: Alignment.centerLeft,
      //     label: preference.text.bySigningIn,
      //   ),
      // ),
    );
  }

  Widget themeContainer() {
    return WidgetBlockSection(
      duration: const Duration(milliseconds: 150),
      placeHolder: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.light_mode_rounded),
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.themeMode,
        ),
      ),
      child: Card(
        child: Selector<Preference, ThemeMode>(
          selector: (_, e) => e.themeMode,
          builder: (BuildContext context, ThemeMode theme, Widget? child) {
            return WidgetListBuilder(
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: ThemeMode.values.length,
              itemBuilder: (_, index) {
                ThemeMode mode = ThemeMode.values[index];
                bool active = theme == mode;
                return WidgetButton(
                  child: WidgetLabel(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    alignment: Alignment.centerLeft,
                    icon: Icons.check_rounded,
                    iconColor: active ? null : Theme.of(context).focusColor,
                    label: themeName[index],
                    labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    softWrap: true,
                    maxLines: 3,
                  ),
                  onPressed: () {
                    if (!active) {
                      preference.updateThemeMode(mode);
                    }
                  },
                );
              },
              itemSeparator: (_, index) {
                return const WidgetListDivider();
              },
            );
          },
        ),
      ),
    );
  }

  Widget localeContainer() {
    return WidgetBlockSection(
      duration: const Duration(milliseconds: 250),
      placeHolder: const SliverToBoxAdapter(),
      headerLeading: const Icon(Icons.translate_rounded),
      headerTitle: WidgetBlockTile(
        title: WidgetLabel(
          alignment: Alignment.centerLeft,
          label: preference.text.locale,
        ),
      ),
      child: Card(
        child: Selector<Preference, ThemeMode>(
          selector: (_, e) => e.themeMode,
          builder: (BuildContext context, ThemeMode theme, Widget? child) {
            return WidgetListBuilder(
              primary: false,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: preference.supportedLocales.length,
              itemBuilder: (_, index) {
                final locale = preference.supportedLocales[index];

                Locale localeCurrent = Localizations.localeOf(context);
                // final String localeName = Intl.canonicalizedLocale(lang.languageCode);
                final String localeName = Locale(locale.languageCode).nativeName;
                final bool active = localeCurrent.languageCode == locale.languageCode;

                return WidgetButton(
                  child: WidgetLabel(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                    alignment: Alignment.centerLeft,
                    icon: Icons.check_rounded,
                    iconColor: active ? null : Theme.of(context).focusColor,
                    label: localeName,
                    labelPadding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    labelStyle: Theme.of(context).textTheme.bodyLarge,
                    softWrap: true,
                    maxLines: 3,
                  ),
                  onPressed: () {
                    preference.updateLocale(locale);
                  },
                );
              },
              itemSeparator: (_, index) {
                return const WidgetListDivider();
              },
            );
          },
        ),
      ),
    );
  }
}
