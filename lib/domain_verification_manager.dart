import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DomainVerificationManager {
  static late final bool _isAndroid =
      defaultTargetPlatform == TargetPlatform.android;
  static late final bool _isSupported = _isAndroid && !kIsWeb;

  static const String kUnsupportedPlatformError =
      'This platform is not supported';

  static const MethodChannel _channel =
      MethodChannel('domain_verification_manager');

  /// Check if the current platform and its version are supported.
  static Future<bool> get isSupported async {
    if (!_isSupported) {
      return false;
    }

    final dynamic result = await _channel.invokeMethod('getIsSupported');
    if (result == null) {
      return false;
    }

    return result;
  }

  /// Domains that have passed Android App Links verification.
  static Future<List<String>?> get domainStageVerified async {
    if (!_isSupported) {
      throw UnsupportedError(kUnsupportedPlatformError);
    }

    final dynamic result =
        await _channel.invokeMethod('getDomainStateVerified');
    if (result == null) {
      return null;
    }

    return (result as List).map((item) => item as String).toList();
  }

  /// Domains that haven't passed Android App Links verification but that the user
  /// has associated with an app.
  static Future<List<String>?> get domainStageSelected async {
    if (!_isSupported) {
      throw UnsupportedError(kUnsupportedPlatformError);
    }

    final dynamic result =
        await _channel.invokeMethod('getDomainStateSelected');
    if (result == null) {
      return null;
    }

    return (result as List).map((item) => item as String).toList();
  }

  /// All other domains.
  static Future<List<String>?> get domainStageNone async {
    if (!_isSupported) {
      throw UnsupportedError(kUnsupportedPlatformError);
    }

    final dynamic result = await _channel.invokeMethod('getDomainStateNone');
    if (result == null) {
      return null;
    }

    return (result as List).map((item) => item as String).toList();
  }

  /// Request permission from the user by opening the app settings.
  static Future<void> domainRequest() async {
    if (!_isSupported) {
      throw UnsupportedError(kUnsupportedPlatformError);
    }

    await _channel.invokeMethod('domainRequest');
  }
}
