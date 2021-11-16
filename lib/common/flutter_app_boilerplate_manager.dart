
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/widgets.dart';

class FlutterBoilerplateManager {
  String? version;
  String? buildNumber;
  BuildContext? context;
  FirebaseAnalytics? analytics;
  FirebaseAnalyticsObserver? observer;

  // 单例公开访问点
  factory FlutterBoilerplateManager() => _gitterManager()!;

  // 静态私有成员，没有初始化
  static FlutterBoilerplateManager? _instance;

  // 私有构造函数
  FlutterBoilerplateManager._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static FlutterBoilerplateManager? _gitterManager() {
    _instance ??= FlutterBoilerplateManager._();
    return _instance;
  }

}
