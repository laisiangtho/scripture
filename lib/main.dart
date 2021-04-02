
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:scriptive/idea/root.dart';
import 'package:scriptive/view/laisiangtho.dart';
// import 'package:scriptive/view/myordbok.dart';

void main() => runApp(Scriptive());

class Scriptive extends StatelessWidget {
  Scriptive({Key key, this.initialRoute}) : super(key: key);

  final String initialRoute;

  @override
  Widget build(BuildContext context){
    return IdeaModel(
      initialModel: IdeaTheme(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        platform: defaultTargetPlatform,
        isTesting: true,
      ),
      child: _root()
    );
  }

  Widget _root(){
    return Builder(
      builder: (context) => MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        darkTheme: IdeaData.darkThemeData.copyWith(
          platform: IdeaTheme.of(context).platform,
        ),
        theme: IdeaData.lightThemeData.copyWith(
          platform: IdeaTheme.of(context).platform,
        ),
        themeMode: IdeaTheme.of(context).themeMode,
        // localizationsDelegates: const [
        //   ...GalleryLocalizations.localizationsDelegates,
        //   LocaleNamesLocalizationsDelegate()
        // ],
        // supportedLocales: GalleryLocalizations.supportedLocales,
        locale: IdeaTheme.of(context).locale,
        localeResolutionCallback: (locale, supportedLocales) => locale,
        initialRoute: initialRoute,
        // onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
        //   builder: (context) => MainView(key: key), settings: settings
        // )
        onGenerateRoute: (RouteSettings settings) => MaterialPageRoute<void>(
          builder: (context) => ApplyTextOptions(
            child: MainView(key: key),
          ), settings: settings
        )
        // onGenerateRoute: RouteConfiguration.onGenerateRoute,
        // onUnknownRoute: RouteConfiguration.onUnknownRoute,
      )
    );
  }
}
