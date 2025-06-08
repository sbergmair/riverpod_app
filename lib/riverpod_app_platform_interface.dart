import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'riverpod_app_method_channel.dart';

abstract class RiverpodAppPlatform extends PlatformInterface {
  /// Constructs a RiverpodAppPlatform.
  RiverpodAppPlatform() : super(token: _token);

  static final Object _token = Object();

  static RiverpodAppPlatform _instance = MethodChannelRiverpodApp();

  /// The default instance of [RiverpodAppPlatform] to use.
  ///
  /// Defaults to [MethodChannelRiverpodApp].
  static RiverpodAppPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RiverpodAppPlatform] when
  /// they register themselves.
  static set instance(RiverpodAppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
