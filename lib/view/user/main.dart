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
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
        sliver: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 250), () => true),
          builder: (_, snap) {
            if (snap.hasData) {
              return themeContainer();
            }
            return const SliverToBoxAdapter();
          },
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 25),
        sliver: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 150), () => true),
          builder: (_, snap) {
            if (snap.hasData) {
              return localeContainer();
            }
            return const SliverToBoxAdapter();
          },
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

  Widget profile() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          const Text('signed in'),
        ],
      ),
    );
  }

  List<Widget> signInList() {
    return [
      signInDecoration(
        icon: LideaIcon.google,
        label: 'Google',
        onPressed: () async {
          await authenticate.signInWithGoogle();
        },
      ),
      signInDecoration(
        icon: LideaIcon.facebook,
        label: 'Facebook',
        onPressed: () async {
          await authenticate.signInWithFacebook();
        },
      ),
      // signInDecoration(
      //   icon: LideaIcon.apple,
      //   label: 'Apple',
      //   onPressed: null,
      // ),
      // signInDecoration(
      //   icon: LideaIcon.microsoft,
      //   label: 'Microsoft',
      //   onPressed: null,
      // ),
      // signInDecoration(
      //   icon: LideaIcon.github,
      //   label: 'GitHub',
      //   onPressed: null,
      // ),
      // const OutlinedButton(
      //   child: WidgetLabel(
      //     icon: LideaIcon.github,
      //     iconSize: 17,
      //     label: 'GitHub',
      //   ),
      //   onPressed: null,
      // ),
    ];
  }

  Widget signInDecoration({IconData? icon, String? label, void Function()? onPressed}) {
    return WidgetButton(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: Theme.of(context).shadowColor,
          width: 1,
        ),
      ),
      child: WidgetLabel(
        icon: icon,
        iconSize: 20,
        label: label,
        labelStyle: Theme.of(context).textTheme.labelLarge,
      ),
      onPressed: onPressed,
    );
  }

  Widget signInContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          WidgetBlockTile(
            title: WidgetLabel(
              // alignment: Alignment.centerLeft,
              label: preference.text.wouldYouLiketoSignIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: signInList(),
            ),
            // child: Wrap(
            //   alignment: WrapAlignment.center,
            //   spacing: 10,
            //   runSpacing: 10,
            //   children: signInList(),
            // ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          //   child: WidgetLabel(
          //     label: preference.text.bySigningIn,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget profileContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          WidgetBlockTile(
            title: WidgetLabel(
              label: authenticate.user!.displayName!,
              labelStyle: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
            child: Column(
              children: [
                WidgetLabel(
                  label: authenticate.user!.email!,
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
        ],
      ),
    );
  }

  Widget themeContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          //   child: WidgetLabel(
          //     alignment: Alignment.centerLeft,
          //     // icon: Icons.lightbulb,
          //     label: preference.text.themeMode,
          //   ),
          // ),
          WidgetBlockTile(
            title: WidgetLabel(
              alignment: Alignment.centerLeft,
              label: preference.text.themeMode,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Selector<Preference, ThemeMode>(
              selector: (_, e) => e.themeMode,
              builder: (BuildContext context, ThemeMode theme, Widget? child) {
                return ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: ThemeMode.values.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    // return ListTile(
                    //   contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                    //   // contentPadding: EdgeInsets.zero,
                    //   minVerticalPadding: 0.0,
                    //   leading: const Icon(Icons.check_rounded),
                    //   title: Text(themeName[index]),
                    //   // style: ListTileStyle.drawer,
                    //   onTap: () {
                    //     preference.updateThemeMode(mode);
                    //   },
                    // );
                  },
                  separatorBuilder: (_, index) {
                    return Divider(
                      // thickness: 0,
                      height: 1,
                      color: Theme.of(context).shadowColor,
                    );
                    // return const SizedBox();
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget localeContainer() {
    return SliverList(
      delegate: SliverChildListDelegate(
        <Widget>[
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          //   child: WidgetLabel(
          //     alignment: Alignment.centerLeft,
          //     label: preference.text.locale,
          //   ),
          // ),
          WidgetBlockTile(
            title: WidgetLabel(
              alignment: Alignment.centerLeft,
              label: preference.text.locale,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            child: Selector<Preference, ThemeMode>(
              selector: (_, e) => e.themeMode,
              builder: (BuildContext context, ThemeMode theme, Widget? child) {
                return ListView.separated(
                  shrinkWrap: true,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: preference.supportedLocales.length,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  separatorBuilder: (_, index) {
                    return Divider(
                      height: 1,
                      color: Theme.of(context).shadowColor,
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
