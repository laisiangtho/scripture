import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/rendering.dart';

import 'package:lidea/provider.dart';
import 'package:lidea/view/main.dart';
import 'package:lidea/cached_network_image.dart';
import 'package:lidea/icon.dart';
import 'package:lidea/extension.dart';

import '/core/main.dart';
import '/widget/main.dart';
// import '/type/main.dart';

part 'bar.dart';

class Main extends StatefulWidget {
  const Main({Key? key, this.arguments}) : super(key: key);
  final Object? arguments;
  // final GlobalKey<NavigatorState>? navigatorKey;

  static const route = '/user';
  static const icon = Icons.person;
  static const name = 'User';
  static const description = 'user';
  static final uniqueKey = UniqueKey();
  // static final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() => _View();
}

abstract class _State extends State<Main> with SingleTickerProviderStateMixin {
  late final Core core = context.read<Core>();
  // late final AppLocalizations translate = AppLocalizations.of(context)!;
  late final Authentication authenticate = context.read<Authentication>();
  late final scrollController = ScrollController();

  Preference get preference => core.preference;

  // SettingsController get settings => context.read<SettingsController>();
  // AppLocalizations get translate => AppLocalizations.of(context)!;
  // Authentication get authenticate => context.read<Authentication>();

  List<String> get themeName => [
        preference.text.automatic,
        preference.text.light,
        preference.text.dark,
      ];

  late final ViewNavigationArguments arguments = widget.arguments as ViewNavigationArguments;
  late final bool canPop = widget.arguments != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
}

class _View extends _State with _Bar {
  @override
  Widget build(BuildContext context) {
    return ViewPage(
      key: widget.key,
      // controller: scrollController,
      child: Consumer<Authentication>(
        builder: (_, __, ___) => body(),
      ),
    );
  }

  CustomScrollView body() {
    return CustomScrollView(
      controller: scrollController,
      slivers: <Widget>[
        bar(),
        // signInList(),
        // signInWrap(),
        SliverToBoxAdapter(
          child: authenticate.hasUser
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    children: [
                      Text(
                        authenticate.user!.displayName!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        authenticate.user!.email!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.overline,
                      ),
                      // Text(
                      //   authenticate.id,
                      //   textAlign: TextAlign.center,
                      // ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          preference.text.wouldYouLiketoSignIn,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: sigInButtons(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          preference.text.bySigningIn,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
        ),

        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: WidgetLabel(
                          icon: Icons.lightbulb,
                          label: preference.text.themeMode,
                        ),
                      ),
                      const Divider(),
                      // Selector<SettingsController, ThemeMode>(
                      //   selector: (_, e) => e.themeMode,
                      //   builder: (BuildContext context, ThemeMode theme, Widget? child) => Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: ThemeMode.values.map<Widget>((e) {
                      //       bool active = theme == e;
                      //       return CupertinoButton(
                      //         padding: const EdgeInsets.all(0),
                      //         child: WidgetLabel(
                      //           enable: !active,
                      //           label: themeName[e.index],
                      //         ),
                      //         onPressed: active ? null : () => settings.updateThemeMode(e),
                      //       );
                      //     }).toList(),
                      //   ),
                      // )
                      Selector<Preference, ThemeMode>(
                        selector: (_, e) => e.themeMode,
                        builder: (BuildContext context, ThemeMode theme, Widget? child) {
                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ThemeMode.values.length,
                            // itemCount: Localizations.localeOf(context).,
                            padding: EdgeInsets.zero,
                            itemBuilder: (_, index) {
                              ThemeMode mode = ThemeMode.values[index];
                              bool active = theme == mode;
                              return ListTile(
                                selected: active,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                ),
                                leading: Icon(active
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked),
                                title: Text(themeName[index]),
                                onTap: active
                                    ? null
                                    : () {
                                        preference.updateThemeMode(mode);
                                      },
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7),
                        child: WidgetLabel(
                          icon: Icons.translate,
                          label: preference.text.locale,
                        ),
                      ),
                      const Divider(),
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   primary: false,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: AppLocalizations.supportedLocales.length,
                      //   // itemCount: Localizations.localeOf(context).,
                      //   padding: EdgeInsets.zero,
                      //   itemBuilder: (_, index) {
                      //     final lang = AppLocalizations.supportedLocales[index];

                      //     Locale locale = Localizations.localeOf(context);
                      //     final String localeName = Intl.canonicalizedLocale(lang.languageCode);
                      //     final bool isCurrent = locale.languageCode == lang.languageCode;

                      //     return ListTile(
                      //       selected: isCurrent,
                      //       leading: Icon(isCurrent
                      //           ? Icons.radio_button_checked
                      //           : Icons.radio_button_unchecked),
                      //       title: Text(localeName),
                      //       onTap: () => settings.updateLocale(lang),
                      //     );
                      //   },
                      // )
                      ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: preference.supportedLocales.length,
                        // itemCount: Localizations.localeOf(context).,
                        padding: EdgeInsets.zero,
                        itemBuilder: (_, index) {
                          final locale = preference.supportedLocales[index];

                          Locale localeCurrent = Localizations.localeOf(context);
                          // final String localeName = Intl.canonicalizedLocale(lang.languageCode);
                          final String localeName = Locale(locale.languageCode).nativeName;
                          final bool active = localeCurrent.languageCode == locale.languageCode;

                          return ListTile(
                            selected: active,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            leading: Icon(
                              active ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            ),
                            title: Text(localeName),
                            onTap: () {
                              preference.updateLocale(locale);
                            },
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // if (authenticate.hasUser) profile() else signInList(),
        // SliverList(
        //   delegate: SliverChildListDelegate(
        //     <Widget>[const Text('user')],
        //   ),
        // ),
      ],
    );
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

  Widget signInWrap() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: sigInButtons(),
      ),
    );
  }

  Widget signInList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: sigInButtons(),
    );
  }

  List<Widget> sigInButtons() {
    return [
      OutlinedButton(
        onPressed: () async {
          await authenticate.signInWithGoogle();
        },
        child: const WidgetLabel(
          icon: LideaIcon.google,
          iconSize: 17,
          label: 'Google',
        ),
      ),
      OutlinedButton(
        onPressed: () async {
          await authenticate.signInWithFacebook();
        },
        child: const WidgetLabel(
          icon: LideaIcon.facebook,
          iconSize: 17,
          label: 'Facebook',
        ),
      ),
      // OutlinedButton(
      //   onPressed: () => false,
      //   child: const WidgetLabel(
      //     icon: LideaIcon.apple,
      //     iconSize: 17,
      //     label: 'Apple',
      //   ),
      // ),
      // OutlinedButton(
      //   onPressed: () async {},
      //   child: const WidgetLabel(
      //     icon: LideaIcon.microsoft,
      //     iconSize: 17,
      //     label: 'Microsoft',
      //   ),
      // ),
      // OutlinedButton(
      //   onPressed: () async {},
      //   child: const WidgetLabel(
      //     icon: LideaIcon.github,
      //     iconSize: 17,
      //     label: 'gitHub',
      //   ),
      // ),
    ];
  }
}
