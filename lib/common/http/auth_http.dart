import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_app_boilerplate/common/http/base_http.dart';
import 'package:flutter_app_boilerplate/common/http/interceptors/auth_interceptor.dart';

final AuthHttp authHttp = AuthHttp();

class AuthHttp extends BaseHttp {
  @override
  void init() {
    interceptors.addAll([AuthorizationInterceptor()]);
  }
}

Options buildOptions(bool? forceRefresh) {
  return buildCacheOptions(const Duration(days: 7), forceRefresh: forceRefresh);
}
