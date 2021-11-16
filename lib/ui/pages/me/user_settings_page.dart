import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/flutter_boilerplate_localizations.dart';
import 'package:flutter_app_boilerplate/common/utils/dark_mode_util.dart';
import 'package:flutter_app_boilerplate/common/utils/navigator_util.dart';
import 'package:flutter_app_boilerplate/ui/blocs/me/dark_mode/dark_mode_bloc.dart';
import 'package:flutter_app_boilerplate/ui/pages/me/about/settings_about_page.dart';
import 'package:flutter_app_boilerplate/ui/pages/me/settings_feedback_page.dart';
import 'package:flutter_app_boilerplate/ui/pages/me/settings/settings_more_page.dart';
import 'package:flutter_app_boilerplate/ui/widgets/profile_item.dart';

const List<Icon> _icons = [
  Icon(
    Icons.settings,
    size: 16,
    color: Colors.redAccent,
  ),
  Icon(
    Icons.info,
    size: 16,
    color: Colors.deepOrangeAccent,
  ),
  Icon(
    Icons.feedback,
    size: 16,
    color: Colors.blueAccent,
  )
];

List<Widget> _children = [
  const SettingsMorePage(),
  const SettingsAboutPage(),
  const SettingsFeedbackPage()
];

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: _list(context),
    );
  }

  List<Widget> _list(context) {
    var widgets = <Widget>[];
    var _titles = <String>[
      FlutterBoilerplateLocalizations.of(context)!.settings,
      FlutterBoilerplateLocalizations.of(context)!.about,
      FlutterBoilerplateLocalizations.of(context)!.feedback,
    ];

    _icons.asMap().forEach((index, icon) {
      widgets.add(Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: (_icons.length - 1) == index
                  ? BorderSide.none
                  : const BorderSide(color: Colors.black12, width: 0.2)),
        ),
        child: GestureDetector(
          onTap: () {
            NavigatorUtil.push(context, _children[index]);
          },
          behavior: HitTestBehavior.opaque,
          child: ProfileItem(
            content: Text(
              _titles[index],
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Container(
              padding: const EdgeInsets.only(right: 8),
              child: icon,
            ),
            action: BlocBuilder<DarkModeBloc, DarkModeState>(
              builder: (context, state) => Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: DarkModeUtil.isDarkMode(context, state.themeMode)
                    ? Colors.white24
                    : Colors.black26,
              ),
            ),
          ),
        ),
      ));
    });

    return widgets;
  }
}
