import 'dart:io';

class FlutterBoilerplateConfig {
  static const bannerAppUnitIdAndroid =
      'ca-app-pub-3943836014370168/5052272351';

  static const bannerAppUnitIdIOS = 'ca-app-pub-3943836014370168/3160961400';

  static final apiKey = Platform.isAndroid
      ? "AIzaSyBAsdeEOZ3M7NosZwyddfOhNxt52TQfXVE"
      : "AIzaSyAUh4UvP7rgoaAHm_jK20R_NpSvxDHXdgA";

  static final appId = Platform.isAndroid
      ? "1:505805882405:android:dd96d014114f0211a5abcc"
      : "1:505805882405:ios:b4af75d49876cefca5abcc";

  static const iCloudContainerId =
      'iCloud.com.upcwangying.apps.flutter.boilerplate';

  static const String sentryDSN = '';
}
