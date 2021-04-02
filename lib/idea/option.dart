part of 'root.dart';

enum CustomTextDirection {
  localeBased,
  ltr,
  rtl,
}

// See http://en.wikipedia.org/wiki/Right-to-left
const List<String> rtlLanguages = <String>[
  'ar', // Arabic
  'fa', // Farsi
  'he', // Hebrew
  'ps', // Pashto
  'ur', // Urdu
];

// Fake locale to represent the system Locale option.
const systemLocaleOption = Locale('system');

Locale _deviceLocale;
Locale get deviceLocale => _deviceLocale;
set deviceLocale(Locale locale) => _deviceLocale ??= locale;

class IdeaTheme{
  IdeaTheme({
    this.themeMode,
    double textScaleFactor,
    this.customTextDirection,
    Locale locale,
    this.timeDilation,
    this.platform,
    this.isTesting,
  })  : _textScaleFactor = textScaleFactor,
        _locale = locale;

  ThemeMode themeMode;
  final double _textScaleFactor;
  final CustomTextDirection customTextDirection;
  final Locale _locale;
  final double timeDilation;
  final TargetPlatform platform;
  final bool isTesting; // True for integration tests.

  // We use a sentinel value to indicate the system text scale option. By
  // default, return the actual text scale factor, otherwise return the
  // sentinel value.
  double textScaleFactor(BuildContext context, {bool useSentinel = false}) {
    if (_textScaleFactor == systemTextScaleFactorOption) {
      return useSentinel
          ? systemTextScaleFactorOption
          : MediaQuery.of(context).textScaleFactor;
    } else {
      return _textScaleFactor;
    }
  }

  Locale get locale => _locale ?? deviceLocale;

  /// Returns a text direction based on the [CustomTextDirection] setting.
  /// If it is based on locale and the locale cannot be determined, returns
  /// null.
  TextDirection resolvedTextDirection() {
    switch (customTextDirection) {
      case CustomTextDirection.localeBased:
        final language = locale?.languageCode?.toLowerCase();
        if (language == null) return null;
        return rtlLanguages.contains(language)
            ? TextDirection.rtl
            : TextDirection.ltr;
      case CustomTextDirection.rtl:
        return TextDirection.rtl;
      default:
        return TextDirection.ltr;
    }
  }

  /// Returns a [SystemUiOverlayStyle] based on the [ThemeMode] setting.
  /// In other words, if the theme is dark, returns light; if the theme is
  /// light, returns dark.
  SystemUiOverlayStyle resolvedSystemUiOverlayStyle() {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance.window.platformBrightness;
    }

    final overlayStyle = brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark;

    return overlayStyle;
  }

  IdeaTheme copyWith({
    ThemeMode themeMode,
    double textScaleFactor,
    CustomTextDirection customTextDirection,
    Locale locale,
    double timeDilation,
    TargetPlatform platform,
    bool isTesting,
  }) {
    return IdeaTheme(
      themeMode: themeMode ?? this.themeMode,
      textScaleFactor: textScaleFactor ?? _textScaleFactor,
      customTextDirection: customTextDirection ?? this.customTextDirection,
      locale: locale ?? this.locale,
      timeDilation: timeDilation ?? this.timeDilation,
      platform: platform ?? this.platform,
      isTesting: isTesting ?? this.isTesting,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is IdeaTheme &&
      themeMode == other.themeMode &&
      _textScaleFactor == other._textScaleFactor &&
      customTextDirection == other.customTextDirection &&
      locale == other.locale &&
      timeDilation == other.timeDilation &&
      platform == other.platform &&
      isTesting == other.isTesting;

  @override
  int get hashCode => hashValues(
    themeMode,
    _textScaleFactor,
    customTextDirection,
    locale,
    timeDilation,
    platform,
    isTesting,
  );

  static IdeaTheme of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
    return scope.modelBindingState.currentModel;
  }

  static void update(BuildContext context, IdeaTheme newModel) {
    final scope = context.dependOnInheritedWidgetOfExactType<_ModelBindingScope>();
    scope.modelBindingState.updateModel(newModel);
  }

}

// Applies text IdeaTheme to a widget
class ApplyTextOptions extends StatelessWidget {
  const ApplyTextOptions({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final options = IdeaTheme.of(context);
    final textDirection = options.resolvedTextDirection();
    final textScaleFactor = options.textScaleFactor(context);

    Widget widget = MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: child,
    );

    return textDirection == null? widget : Directionality(textDirection: textDirection, child: widget);
  }
}
