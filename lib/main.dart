
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

import 'package:bible/core.dart';
import 'package:bible/idea/scope.dart';

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
    return ApplyModelBinding(
      initialModel: ApplyThemeOption(
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
          themeMode: ApplyThemeOption.of(context).themeMode,
          theme: ApplyThemeData.lightThemeData.copyWith(
            platform: ApplyThemeOption.of(context).platform,
          ),
          darkTheme: ApplyThemeData.darkThemeData.copyWith(
            platform: ApplyThemeOption.of(context).platform,
          ),
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          // supportedLocales: GalleryLocalizations.supportedLocales,
          locale: ApplyThemeOption.of(context).locale,
          localeResolutionCallback: (locale, supportedLocales) {
            deviceLocale = locale;
            // print(locale);
            return locale;
          },
          initialRoute: initialRoute,
          onGenerateRoute: RouteConfiguration.onGenerateRoute,
          // onUnknownRoute: RouteConfiguration.onUnknownRoute,
        )
      ),
    );
  }
}