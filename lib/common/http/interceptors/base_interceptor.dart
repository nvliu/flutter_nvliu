import 'package:dio/dio.dart';
import 'package:flutter_app_boilerplate/common/constant/flutter_boilerplate_constants.dart';

class BaseInterceptor extends InterceptorsWrapper {
  final String baseUrl;

  BaseInterceptor(this.baseUrl);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options
      ..baseUrl = baseUrl
      ..connectTimeout = FlutterBoilerplateConstants.timeOut * 1000 //5s
      ..receiveTimeout = FlutterBoilerplateConstants.timeOut * 1000
      ..headers.addAll(FlutterBoilerplateConstants.headers);
    super.onRequest(options, handler);
  }
}
