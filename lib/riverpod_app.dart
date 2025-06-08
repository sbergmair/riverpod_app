
import 'riverpod_app_platform_interface.dart';

class RiverpodApp {
  Future<String?> getPlatformVersion() {
    return RiverpodAppPlatform.instance.getPlatformVersion();
  }
}
