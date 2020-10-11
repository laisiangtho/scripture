
import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

// import 'package:bible/screen/main.dart';
// import 'package:bible/screen/color.dart';
// import 'package:bible/screen/speak.dart';
import 'package:bible/core.dart';

import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
// import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
// import 'package:flutter_localized_locales/flutter_localized_locales.dart';
// import 'package:gallery/routes.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gallery/constants.dart';
// import 'package:gallery/data/gallery_options.dart';
// import 'package:gallery/pages/backdrop.dart';
// import 'package:gallery/pages/splash.dart';
// import 'package:gallery/themes/gallery_theme_data.dart';

import 'package:bible/idea/constants.dart';
import 'package:bible/idea/option.dart';
import 'package:bible/idea/theme.dart';
import 'package:bible/idea/route.dart';

void main() => runApp(LaiSiangtho());

class LaiSiangtho extends StatelessWidget {
  const LaiSiangtho({
    Key key,
    this.initialRoute,
    this.isTesting: false,
  }) : super(key: key);

  final bool isTesting;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: ApplyOptions(
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
          themeMode: ApplyOptions.of(context).themeMode,
          theme: ApplyThemeData.lightThemeData.copyWith(
            platform: ApplyOptions.of(context).platform,
          ),
          darkTheme: ApplyThemeData.darkThemeData.copyWith(
            platform: ApplyOptions.of(context).platform,
          ),
          // localizationsDelegates: const [
          //   ...GalleryLocalizations.localizationsDelegates,
          //   LocaleNamesLocalizationsDelegate()
          // ],
          // supportedLocales: GalleryLocalizations.supportedLocales,
          locale: ApplyOptions.of(context).locale,
          localeResolutionCallback: (locale, supportedLocales) {
            deviceLocale = locale;
            print(locale);
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