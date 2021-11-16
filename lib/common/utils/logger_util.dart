import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

void printVerboseLog(Object? object) {
  if(kDebugMode) {
    String line = object.toString();
    logger.v(line);
  }
}

void printDebugLog(Object? object) {
  if(kDebugMode) {
    String line = object.toString();
    logger.d(line);
  }
}

void printInfoLog(Object? object) {
  if(kDebugMode) {
    String line = object.toString();
    logger.i(line);
  }
}

void printWarningLog(Object? object) {
  if(kDebugMode) {
    String line = object.toString();
    logger.w(line);
  }
}

void printErrorLog(Object? object) {
  Sentry.captureException(object);
  if(kDebugMode) {
    String line = object.toString();
    logger.e(line);
  }
}

void printWTFLog(Object? object) {
  if(kDebugMode) {
    String line = object.toString();
    logger.wtf(line);
  }
}
