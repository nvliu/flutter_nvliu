import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app_boilerplate/common/config/flutter_app_boilerplate_config.dart';
import 'package:flutter_app_boilerplate/common/constant/flutter_boilerplate_constants.dart';
import 'package:flutter_app_boilerplate/common/utils/cache_util.dart';
import 'package:flutter_app_boilerplate/common/utils/string_util.dart';
import 'package:flutter_app_boilerplate/ui/pages/flutter_boilerplate_app.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_boilerplate/common/utils/file_util.dart';
import 'package:flutter_app_boilerplate/common/utils/icloud_util.dart';
import 'package:flutter_app_boilerplate/common/utils/logger_util.dart';
import 'package:flutter_app_boilerplate/ui/blocs/flutter_app_boilerplate_bloc_observer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter_app_boilerplate/ui/blocs/bloc_providers.dart';
import 'package:flutter_app_boilerplate/common/flutter_app_boilerplate_manager.dart';
import 'package:workmanager/workmanager.dart';

/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  printInfoLog('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final workManager = Workmanager();

/// Used for Background Updates using Workmanager Plugin
void callbackDispatcher() {
  workManager.executeTask((taskName, inputData) {
    final now = DateTime.now();
    return Future.wait<bool?>([
      HomeWidget.saveWidgetData(
        'title',
        'Updated from Background',
      ),
      HomeWidget.saveWidgetData(
        'message',
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
      ),
      HomeWidget.updateWidget(
        name: 'FlutterBoilerplateHomeWidgetProvider',
        androidName: 'FlutterBoilerplateHomeWidgetProvider',
        iOSName: 'FlutterBoilerplateHomeWidget',
      ),
    ]).then((value) {
      return !value.contains(false);
    });
  });
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.appTrackingTransparency.request();
  await MobileAds.instance.initialize();
  await workManager.initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  await initHiveForFlutter();
  await Firebase.initializeApp();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  var settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    printWarningLog('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    printWarningLog('User granted provisional permission');
  } else {
    printWarningLog('User declined or has not accepted permission');
  }

  // 从iCloud中下载个人认证信息
  if (Platform.isIOS) {
    await _downFileFromICloud();
  }

  await _loadUserData();

  final packageInfo = await PackageInfo.fromPlatform();
  FlutterBoilerplateManager()
    ..version = packageInfo.version
    ..buildNumber = packageInfo.buildNumber;

  Bloc.observer = FlutterBoilerplateBlocObserver();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = FlutterBoilerplateConfig.sentryDSN
        ..reportSilentFlutterErrors = true;
    },
    appRunner: () => runApp(
      MultiProvider(
        providers: BlocProviders.blocProviders,
        child: FlutterBoilerplateApp(
          flutterLocalNotifications: flutterLocalNotificationsPlugin,
          channel: channel,
          workManager: workManager,
        ),
      ),
    ),
  );
}

Future<void> _loadUserData() async {
  var authorizationEmail = await CacheUtil.getCache(
      FlutterBoilerplateConstants.authorizationEmail,
      checkValidTimes: false);
  var authorizationPassword = await CacheUtil.getCache(
      FlutterBoilerplateConstants.authorizationPassword,
      checkValidTimes: false);
  if (StringUtil.isNotBlank(authorizationEmail) &&
      StringUtil.isNotBlank(authorizationPassword)) {
    // todo: load user data
  }
}

Future<void> _downFileFromICloud() async {
  var file = await FileUtil.localFile;
  await ICloudUtil.downloadFileFormICloud(FileUtil.fileName, file.path);
}
