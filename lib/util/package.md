
import 'package:package_info/package_info.dart';

/// ```dart
/// await appInfo.then((PackageInfo packageInfo) {
///   this.appName = packageInfo.appName;
///   this.packageName = packageInfo.packageName;
///   this.version = packageInfo.version;
///   this.buildNumber = packageInfo.buildNumber;
/// });
/// ```
class UtilPackage {
  static Future<PackageInfo> get info => PackageInfo.fromPlatform();
}