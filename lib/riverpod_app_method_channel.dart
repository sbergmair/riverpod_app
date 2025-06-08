import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'riverpod_app_platform_interface.dart';

/// An implementation of [RiverpodAppPlatform] that uses method channels.
class MethodChannelRiverpodApp extends RiverpodAppPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('riverpod_app');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
