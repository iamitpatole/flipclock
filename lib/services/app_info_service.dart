import 'package:package_info_plus/package_info_plus.dart';

class AppInfoService {
  const AppInfoService();

  /// Returns the formatted version string (e.g., '1.0.0').
  Future<String> getAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version.trim();

      if (version.isNotEmpty) {
        return version;
      }
      return '1.0.0';
    } catch (_) {
      return '1.0.0';
    }
  }

  /// Returns the raw [PackageInfo] from platform.
  Future<PackageInfo> getPackageInfo() => PackageInfo.fromPlatform();
}
