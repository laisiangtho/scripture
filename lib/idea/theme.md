part of 'root.dart';

class IdeaData {
  static const _lightFillColor = Colors.black;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = _lightFillColor.withOpacity(0.12);
  static final Color _darkFocusColor = _darkFillColor.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      // primarySwatch: Colors.red,
      colorScheme: colorScheme,
      textTheme: _textTheme,
      // primaryColor: colorScheme.primary,
      // // accentColor: colorScheme.secondary,
      // // canvasColor: colorScheme.background,
      // canvasColor: Colors.transparent,
      // scaffoldBackgroundColor: colorScheme.secondaryVariant,
      // backgroundColor: colorScheme.background,
      // highlightColor: Colors.transparent,
      // focusColor: focusColor,

      // appBarTheme: AppBarTheme(
      //   textTheme: _textTheme.apply(bodyColor: colorScheme.onPrimary),
      //   color: colorScheme.background,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: colorScheme.primary),
      //   brightness: colorScheme.brightness,
      // ),
      // iconTheme: IconThemeData(color: colorScheme.onPrimary),

      // snackBarTheme: SnackBarThemeData(
      //   behavior: SnackBarBehavior.floating,
      //   backgroundColor: Color.alphaBlend(
      //     _lightFillColor.withOpacity(0.80),
      //     _darkFillColor,
      //   ),
      //   contentTextStyle: _textTheme.subtitle1.apply(color: _darkFillColor),
      // ),
      // fontFamily: "Lato, Paduak, sans-serif",
      // fontFamily: "Lato, Mm3Web",
      // fontFamily: "Mm3Web, Lato",
      fontFamily: "Lato,Mm3Web",
      // fontFamily: "Mm3Web",
      // fontFamily: "Paduak",

      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        // clipBehavior: Clip.antiAlias,
        // modalBackgroundColor: colorScheme.background,
        modalElevation: 20.0,
        backgroundColor: colorScheme.primary,
        elevation: 10.0,
        // clipBehavior: Clip.antiAlias
        // backgroundColor: Colors.red
      ),
      // tooltipTheme: TooltipThemeData()
      cupertinoOverrideTheme: CupertinoThemeData(
        // textTheme: CupertinoTextThemeData(),
        // primaryColor: Colors.black54
        primaryColor: colorScheme.primaryVariant
      ),

      primaryColor: colorScheme.primary,
      // accentColor: colorScheme.secondary,
      // canvasColor: colorScheme.background,
      canvasColor: Colors.transparent,
      scaffoldBackgroundColor: colorScheme.secondary,
      backgroundColor: colorScheme.background,

      // highlightColor: Colors.transparent,
      // focusColor: focusColor,
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(

    primary: Colors.white, //main -> 0xFFFFFFFF
    primaryVariant: Colors.black54, //icon -> 0x8A000000
    // secondary: Color(0xFFF5F5F5), //scaffold -> 0xFFF5F5F5
    secondary: Colors.white, //scaffold -> 0xFFF5F5F5
    // secondaryVariant: Color(0xFFFFFFFF),
    secondaryVariant: Colors.indigo,
    background: Color(0xFFD6D6D6),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF322942),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    // primary: Color(0xFF292829),
    primary: Color(0xFF3D3C3D),
    primaryVariant: Colors.white,
    secondary: Color(0xFF5E5D5E),
    // secondary: Colors.black,
    secondaryVariant: Color(0xFF451B6F),
    background: Color(0xFF5E5D5E),
    surface: Color(0xFF1F1929),
    onBackground: Color(0x0DFFFFFF), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark
  );

  static final _fontWeightThin = FontWeight.w300;
  static final _fontWeighRegular = FontWeight.w400;
  static final _fontWeighMedium = FontWeight.w500;
  static final _fontWeighSemiBold = FontWeight.w600;
  static final _fontWeighBold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
    headline4: TextStyle(fontWeight: _fontWeighBold, fontSize: 20.0),
    caption: TextStyle(fontWeight: _fontWeighSemiBold, fontSize: 16.0),
    subtitle1: TextStyle(fontWeight: _fontWeighMedium, fontSize: 16.0),
    overline: TextStyle(fontWeight: _fontWeighMedium, fontSize: 12.0),
    bodyText1: TextStyle(fontWeight: _fontWeighRegular, fontSize: 14.0),
    subtitle2: TextStyle(fontWeight: _fontWeighMedium, fontSize: 14.0),
    bodyText2: TextStyle(fontWeight: _fontWeighRegular, fontSize: 16.0),
    headline6: TextStyle(fontWeight: _fontWeighBold, fontSize: 16.0),
    headline5: TextStyle(fontWeight: _fontWeighMedium, fontSize: 16.0),
    button: TextStyle(fontWeight: _fontWeightThin,fontSize: 14.0,height: 1.5)
  );
}