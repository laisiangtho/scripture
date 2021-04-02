import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Option
import 'package:flutter/services.dart' show SystemChrome, SystemUiOverlayStyle;
import 'package:flutter/services.dart';

part 'config.dart';
part 'option.dart';
part 'theme.dart';
// part 'themeLight.dart';
// part 'themeDark.dart';
// part 'route.dart';
// part 'splash.dart';

class IdeaModel extends StatefulWidget {
  IdeaModel({
    Key key,
    // this.initialModel = const IdeaTheme(),
    this.initialModel,
    this.child,
  }) : assert(initialModel != null), super(key: key);

  final IdeaTheme initialModel;
  final Widget child;

  @override
  _ModelBindingState createState() => _ModelBindingState();
}

class _ModelBindingState extends State<IdeaModel> {
  IdeaTheme currentModel;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateModel(IdeaTheme newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }

  bool get isLight {
    Brightness brightness;
    switch (currentModel.themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance.window.platformBrightness;
    }

    return brightness == Brightness.light;
    // Brightness brightness = SchedulerBinding.instance.window.platformBrightness;
    // return brightness == Brightness.light;
  }

  Brightness get brightness => this.isLight? Brightness.dark:Brightness.light;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: brightness,
        statusBarBrightness: brightness,
        // statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: brightness,
      )
    );
    return _ModelBindingScope(
      modelBindingState: this,
      child: widget.child
    );
  }
}

class _ModelBindingScope extends InheritedWidget {
  _ModelBindingScope({
    Key key,
    @required this.modelBindingState,
    Widget child,
  }) : assert(modelBindingState != null), super(key: key, child: child);

  final _ModelBindingState modelBindingState;

  @override
  // bool updateShouldNotify(_ModelBindingScope old) =>  old.modelBindingState != modelBindingState;
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}
