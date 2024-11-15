part of 'main.dart';

/// Shortcut to [Localizations]...
/// export 'package:lidea/extension.dart';
/// AppLocalizations lang(BuildContext context) => AppLocalizations.of(context)!;
extension AppContextsEntension<T> on BuildContext {
  /// `App.core.preference.lang(context)`
  /// AppLocalizations lang(BuildContext context) => AppLocalizations.of(context)!;
  AppLocalizations get lang => AppLocalizations.of(this)!;
}
