// Route
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// Option
import 'dart:async';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

// import 'package:bible/screen/testing.dart';
import 'package:bible/screen/main.dart';

part 'config.dart';
part 'option.dart';
part 'theme.dart';
part 'route.dart';
part 'splash.dart';

class ApplyModelBinding extends StatefulWidget {
  ApplyModelBinding({
    Key key,
    this.initialModel = const ApplyThemeOption(),
    this.child,
  })  : assert(initialModel != null),
        super(key: key);

  final ApplyThemeOption initialModel;
  final Widget child;

  @override
  _ModelBindingState createState() => _ModelBindingState();
}

class _ModelBindingState extends State<ApplyModelBinding> {
  ApplyThemeOption currentModel;
  Timer _timeDilationTimer;

  @override
  void initState() {
    super.initState();
    currentModel = widget.initialModel;
  }

  @override
  void dispose() {
    _timeDilationTimer?.cancel();
    _timeDilationTimer = null;
    super.dispose();
  }

  void handleTimeDilation(ApplyThemeOption newModel) {
    if (currentModel.timeDilation != newModel.timeDilation) {
      _timeDilationTimer?.cancel();
      _timeDilationTimer = null;
      if (newModel.timeDilation > 1) {
        // We delay the time dilation change long enough that the user can see
        // that UI has started reacting and then we slam on the brakes so that
        // they see that the time is in fact now dilated.
        _timeDilationTimer = Timer(const Duration(milliseconds: 150), () {
          timeDilation = newModel.timeDilation;
        });
      } else {
        timeDilation = newModel.timeDilation;
      }
    }
  }

  void updateModel(ApplyThemeOption newModel) {
    if (newModel != currentModel) {
      handleTimeDilation(newModel);
      setState(() {
        currentModel = newModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _ModelBindingScope(
      modelBindingState: this,
      child: widget.child,
    );
  }
}

class _ModelBindingScope extends InheritedWidget {
  _ModelBindingScope({
    Key key,
    @required this.modelBindingState,
    Widget child,
  })  : assert(modelBindingState != null),
        super(key: key, child: child);

  final _ModelBindingState modelBindingState;

  @override
  bool updateShouldNotify(_ModelBindingScope oldWidget) => true;
}