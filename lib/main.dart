
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:bible/core.dart';
import 'package:bible/idea/root.dart';

import 'package:bible/screen/main.dart';

void main() => runApp(LaiSiangtho());

class LaiSiangtho extends StatelessWidget {
  const LaiSiangtho({
    Key key,
    this.initialRoute,
    this.isTesting: false,
  }) : super(key: key);

  final String initialRoute;
  final bool isTesting;

  @override
  Widget build(BuildContext context) {
    return IdeaModel(
      initialModel: IdeaTheme(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
        isTesting: isTesting,
      ),
      child: Builder(
        builder: (context) => MaterialApp(
          title: Core.instance.appName,
          debugShowCheckedModeBanner: false,
          themeMode: IdeaTheme.of(context).themeMode,
          theme: IdeaData.lightThemeData.copyWith(
            platform: IdeaTheme.of(context).platform,
          ),
          darkTheme: IdeaData.darkThemeData.copyWith(
            platform: IdeaTheme.of(context).platform,
          ),
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          // supportedLocales: GalleryLocalizations.supportedLocales,
          locale: IdeaTheme.of(context).locale,
          localeResolutionCallback: (locale, supportedLocales) {
            deviceLocale = locale;
            // print(locale);
            return locale;
          },
          initialRoute: initialRoute,
          onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
            builder: (context) => MainView(key: key), settings: settings
          )
          // onGenerateRoute: RouteConfiguration.onGenerateRoute,
          // onUnknownRoute: RouteConfiguration.onUnknownRoute,
        )
      ),
    );
  }
}