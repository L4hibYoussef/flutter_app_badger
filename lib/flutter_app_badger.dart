import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterAppBadger {
  static const MethodChannel _channel =
      MethodChannel('g123k/flutter_app_badger');

  static Future<void> updateBadgeCount(int count) async {
    final mock = _mockUpdateBadgeCount;
    if (mock != null) {
      await mock(count);
      return;
    }

    // Clamp negative inputs
    final safe = count < 0 ? 0 : count;

    try {
      await _channel.invokeMethod<void>('updateBadgeCount', {"count": safe});
    } on MissingPluginException {
      // No-op on unsupported platforms / when plugin not registered
    } on PlatformException {
      // Optionally log or report if you want
    }
  }

  static Future<void> removeBadge() async {
    final mock = _mockRemoveBadge;
    if (mock != null) {
      await mock();
      return;
    }

    try {
      await _channel.invokeMethod<void>('removeBadge');
    } on MissingPluginException {
      // No-op
    } on PlatformException {
      // Optionally log
    }
  }

  static Future<bool> isAppBadgeSupported() async {
    final mock = _mockIsAppBadgeSupported;
    if (mock != null) return mock();

    try {
      final bool? supported =
          await _channel.invokeMethod<bool>('isAppBadgeSupported');
      return supported ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> Function(int count)? _mockUpdateBadgeCount;
  static Future<void> Function()? _mockRemoveBadge;
  static Future<bool> Function()? _mockIsAppBadgeSupported;

  @visibleForTesting
  static void setMocks({
    Future<void> Function(int count)? updateBadgeCount,
    Future<void> Function()? removeBadge,
    Future<bool> Function()? isAppBadgeSupported,
  }) {
    _mockUpdateBadgeCount = updateBadgeCount;
    _mockRemoveBadge = removeBadge;
    _mockIsAppBadgeSupported = isAppBadgeSupported;
  }

  @visibleForTesting
  static void clearMocks() {
    _mockUpdateBadgeCount = null;
    _mockRemoveBadge = null;
    _mockIsAppBadgeSupported = null;
  }
}
