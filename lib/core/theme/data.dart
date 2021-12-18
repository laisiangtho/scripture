import 'package:flutter/material.dart';
import 'package:lidea/idea.dart';

class IdeaData {
  static ThemeData light(BuildContext context) {
    return IdeaSchemeData.theme(
      Theme.of(context).textTheme.merge(IdeaSchemeData.textTheme),
      const IdeaSchemeColor(),
    );
  }

  static ThemeData dark(BuildContext context) {
    return IdeaSchemeData.theme(
      Theme.of(context).textTheme.merge(IdeaSchemeData.textTheme),
      IdeaSchemeColor.darkColor(),
    );
  }
}
