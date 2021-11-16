import 'package:flutter_app_boilerplate/common/constant/cart_constants.dart';
import 'package:flutter_app_boilerplate/common/constant/home_constants.dart';
import 'package:flutter_app_boilerplate/common/constant/me_constants.dart';
import 'package:flutter_app_boilerplate/common/constant/search_constants.dart';
import 'package:flutter_app_boilerplate/common/constant/store_constants.dart';
import 'package:flutter_app_boilerplate/common/iconfonts/iconfonts.dart';
import 'package:flutter_app_boilerplate/common/model/tab.dart';

List<Tab> bottomTabs = [
  Tab(iconData: IconFonts.home.codePoint, text: HomeConstants.module),
  Tab(iconData: IconFonts.store.codePoint, text: StoreConstants.module),
  Tab(iconData: IconFonts.search.codePoint, text: SearchConstants.module),
  Tab(iconData: IconFonts.cart.codePoint, text: CartConstants.module),
  Tab(iconData: IconFonts.account.codePoint, text: MeConstants.module),
];
