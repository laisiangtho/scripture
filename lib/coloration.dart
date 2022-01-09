import 'package:flutter/material.dart';
import 'package:lidea/unit/coloration.dart';

class Coloration {
  static ThemeData light(BuildContext context) {
    return ColorationData.theme(
      Theme.of(context).textTheme.merge(ColorationData.textTheme),
      const ColorationScheme(),
    );
  }

  static ThemeData dark(BuildContext context) {
    return ColorationData.theme(
      Theme.of(context).textTheme.merge(ColorationData.textTheme),
      ColorationScheme.darkColor(),
    );
  }
}
