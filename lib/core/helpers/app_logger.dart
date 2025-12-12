import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger();

  AppLogger._();

  static void debug(dynamic message) {
    if (kDebugMode) {
      _logger.d(message, stackTrace: StackTrace.empty);
    }
  }

  static void info(dynamic message) {
    if (kDebugMode) {
      _logger.i(message, stackTrace: StackTrace.empty);
    }
  }

  static void warning(dynamic message) {
    if (kDebugMode) {
      _logger.w(message, stackTrace: StackTrace.empty);
    }
  }

  static void error(dynamic message, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.e(message, stackTrace: stackTrace ?? StackTrace.empty);
    }
  }

  static void verbose(dynamic message) {
    if (kDebugMode) {
      _logger.t(message, stackTrace: StackTrace.current);
    }
  }

  static void wtf(dynamic message) {
    if (kDebugMode) {
      _logger.f(message, stackTrace: StackTrace.empty);
    }
  }
}
