import 'package:dio/dio.dart';
import 'package:flutter_app_boilerplate/common/http/other_http.dart';
import 'package:flutter_app_boilerplate/common/utils/logger_util.dart';

class LoginDao {
  /// https://docs.github.com/cn/developers/apps/authorizing-oauth-apps
  static Future<dynamic> login(
      String? code) async {

    try {
      var response = await loginHttp.post(
        'your url',
      );
      return response.data;
    } on DioError catch (e) {
      printErrorLog(e);
    }

    return null;
  }
}
