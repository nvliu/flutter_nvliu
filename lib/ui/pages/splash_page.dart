import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_boilerplate/common/config/flutter_app_boilerplate_config.dart';
import 'package:flutter_app_boilerplate/common/constant/flutter_boilerplate_constants.dart';
import 'package:flutter_app_boilerplate/ui/pages/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_app_boilerplate/common/utils/logger_util.dart';
import 'package:flutter_app_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_gen/gen_l10n/flutter_boilerplate_localizations.dart';
import 'package:flutter_app_boilerplate/ui/pages/notifications/message.dart';
import 'package:flutter_app_boilerplate/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:flutter_app_boilerplate/ui/blocs/me/theme/theme_bloc.dart';
import 'package:flutter_app_boilerplate/ui/widgets/loader.dart';
import 'package:flutter_app_boilerplate/ui/widgets/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

BannerAd bannerAd = BannerAd(
  adUnitId: kDebugMode
      ? BannerAd.testAdUnitId
      : Platform.isAndroid
          ? FlutterBoilerplateConfig.bannerAppUnitIdAndroid
          : FlutterBoilerplateConfig.bannerAppUnitIdIOS,
  size: AdSize.banner,
  request: const AdRequest(),
  listener: const BannerAdListener(),
);

class SplashPage extends StatefulWidget {
  final FlutterLocalNotificationsPlugin flutterLocalNotifications;
  final AndroidNotificationChannel channel;

  const SplashPage({
    Key? key,
    required this.flutterLocalNotifications,
    required this.channel,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DarkModeBloc, DarkModeState>(
      builder: (context, state) => BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) => _default(themeState),
      ),
    );
  }

  Widget _default(ThemeState themeState) {
    var _theme = Theme.of(context);
    var loadBannerAdFuture = _loadBannerAdFuture();
    return FutureBuilder(
      future: loadBannerAdFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return SplashScreen.timer(
            seconds: 5,
            title: Text(
              FlutterBoilerplateLocalizations.of(context)!.welcome,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            navigateAfterSeconds: _widget,
            image: Image.network('https://cdn.gitterapp.com/logo/flutter_boilerplate.png'),
            styleTextUnderTheLoader: const TextStyle(),
            backgroundColor: _theme.colorScheme.background,
            photoSize: 100.0,
            onClick: () => printInfoLog(FlutterBoilerplateConstants.appName),
            useLoader: true,
            customLoader: const Loader(
              size: 40,
            ),
            loadingText:
                Text(FlutterBoilerplateLocalizations.of(context)!.loading),
            loadingTextPadding: const EdgeInsets.only(bottom: 80),
            loaderColor: Color(themeState.color!),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              SplashScreen.timer(
                seconds: 5,
                title: Text(
                  FlutterBoilerplateLocalizations.of(context)!.welcome,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                navigateAfterSeconds: _widget,
                image:
                    Image.network('https://cdn.gitterapp.com/logo/flutter_boilerplate.png'),
                styleTextUnderTheLoader: const TextStyle(),
                backgroundColor: _theme.colorScheme.background,
                photoSize: 100.0,
                onClick: () =>
                    printInfoLog(FlutterBoilerplateConstants.appName),
                useLoader: true,
                customLoader: const Loader(
                  size: 40,
                ),
                loadingText:
                    Text(FlutterBoilerplateLocalizations.of(context)!.loading),
                loadingTextPadding: const EdgeInsets.only(bottom: 80),
                loaderColor: Color(themeState.color!),
              ),
              Positioned(
                bottom: (Platform.isIOS &&
                        MediaQuery.of(context).padding.bottom > 0)
                    ? 34
                    : 10,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: bannerAd),
                ),
              )
            ],
          );
        } else {
          return SplashScreen.navigate(
            shouldNavigate: false,
            title: Text(
              FlutterBoilerplateLocalizations.of(context)!.welcome,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            image: Image.network('https://cdn.gitterapp.com/logo/gitter.png'),
            styleTextUnderTheLoader: const TextStyle(),
            backgroundColor: _theme.colorScheme.background,
            photoSize: 100.0,
            onClick: () => printInfoLog(FlutterBoilerplateConstants.appName),
            useLoader: true,
            customLoader: const Loader(
              size: 40,
            ),
            loadingText:
                Text(FlutterBoilerplateLocalizations.of(context)!.loading),
            loadingTextPadding: const EdgeInsets.only(bottom: 80),
            loaderColor: Color(themeState.color!),
          );
        }
      },
    );
  }

  Widget get _widget {
    // todo
    return const LoginPage();
    // return FlutterBoilerplateManager().user == null
    //     ? const LoginPage()
    //     : const TabNavigator();
  }

  Future<void> _loadBannerAdFuture() async {
    try {
      await bannerAd.load();
    } on Exception catch (e) {
      printErrorLog(e);
    }
  }

  void _initFirebaseMessaging() {
    FirebaseMessaging.instance.getInitialMessage().then((message) => {
          if (message != null)
            {
              /// todo
            }
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var notification = message.notification;
      var android = message.notification?.android;
      if (notification != null && android != null) {
        widget.flutterLocalNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              widget.channel.id,
              widget.channel.name,
              channelDescription: widget.channel.description,
              icon: 'ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      printInfoLog('A new onMessageOpenedApp event was published!');
      try {
        await FlutterDynamicIcon.setApplicationIconBadgeNumber(0);
      } catch (_) {}
      NavigatorUtil.push(context, const MessageView(),
          settings: RouteSettings(arguments: MessageArguments(message, true)));
    });
  }
}
