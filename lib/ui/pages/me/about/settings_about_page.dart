import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/flutter_boilerplate_localizations.dart';
import 'package:flutter_app_boilerplate/common/flutter_app_boilerplate_manager.dart';
import 'package:flutter_app_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_app_boilerplate/common/utils/widget_util.dart';
import 'package:flutter_app_boilerplate/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:flutter_app_boilerplate/ui/pages/me/about/about_more_bottom_page.dart';
import 'package:flutter_app_boilerplate/ui/pages/me/about/about_more_center_page.dart';
import 'package:flutter_app_boilerplate/ui/pages/me/about/about_more_top_page.dart';
import 'package:flutter_app_boilerplate/ui/widgets/loader.dart';

class SettingsAboutPage extends StatelessWidget {
  const SettingsAboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const  EdgeInsetsGeometry _padding = EdgeInsets.only(left: 14, right: 8);
    const  EdgeInsetsGeometry _marginFirst = EdgeInsets.only(top: 20);
    const  EdgeInsetsGeometry _margin = EdgeInsets.only(top: 8);

    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => NavigatorUtil.pop(context),
          child: const Icon(
            Icons.arrow_back,
            size: 24,
          ),
        ),
        title: Text(
          FlutterBoilerplateLocalizations.of(context)!.about,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            BlocBuilder<DarkModeBloc, DarkModeState>(
              builder: (context, state) => Container(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: CachedNetworkImage(
                  width: 80,
                  height: 80,
                  imageUrl: 'https://cdn.gitterapp.com/logo/flutter_boilerplate.png',
                  placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(4),
                    child: Loader(
                      size: 80,
                    ),
                  ),
                  errorWidget: (context, url, error) => WidgetUtil.errorWidget(
                    context,
                    state.themeMode,
                    size: 80,
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                const Text(
                  'Flutter Boilerplate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '${FlutterBoilerplateManager().version}+${FlutterBoilerplateManager().buildNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: _padding,
              margin: _marginFirst,
              child: const AboutMoreTopPage(),
            ),
            Container(
              padding: _padding,
              margin: _margin,
              child: const AboutMoreCenterPage(),
            ),
            Container(
              padding: _padding,
              margin: _margin,
              child: const AboutMoreBottomPage(),
            ),
          ],
        ),
      ),
    );
  }
}
