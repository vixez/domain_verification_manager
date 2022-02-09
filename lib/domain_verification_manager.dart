import 'dart:async';

import 'package:flutter/services.dart';

class DomainVerificationManager {
  static const MethodChannel _channel =
      MethodChannel('domain_verification_manager');

  /// Domains that have passed Android App Links verification.
  static Future<List<String>?> get domainStageVerified async {
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
    final dynamic result =
        await _channel.invokeMethod('getDomainStateSelected');
    if (result == null) {
      return null;
    }

    return (result as List).map((item) => item as String).toList();
  }

  /// All other domains.
  static Future<List<String>?> get domainStageNone async {
    final dynamic result = await _channel.invokeMethod('getDomainStateNone');
    if (result == null) {
      return null;
    }

    return (result as List).map((item) => item as String).toList();
  }

  /// Request permission from the user by opening the app settings.
  static Future<void> domainRequest() async {
    await _channel.invokeMethod('domainRequest');
  }
}
