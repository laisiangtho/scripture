import 'package:flutter/material.dart';
import 'package:lidea/unit/coloration.dart';

class Coloration {
  static ThemeData light(BuildContext context) {
    return ColorationData.theme(
      text: Theme.of(context).textTheme.merge(
            ColorationData.textTheme(),
          ),
      color: const ColorationScheme(
        highlight: Colors.blue,
      ),
    );
  }

  static ThemeData dark(BuildContext context) {
    return ColorationData.theme(
      text: Theme.of(context).textTheme.merge(
            ColorationData.textTheme(),
          ),
      color: ColorationScheme.darkColor(),
    );
  }
}
