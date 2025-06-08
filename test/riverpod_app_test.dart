import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_app/riverpod_app.dart';
import 'package:riverpod_app/riverpod_app_platform_interface.dart';
import 'package:riverpod_app/riverpod_app_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockRiverpodAppPlatform
    with MockPlatformInterfaceMixin
    implements RiverpodAppPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final RiverpodAppPlatform initialPlatform = RiverpodAppPlatform.instance;

  test('$MethodChannelRiverpodApp is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelRiverpodApp>());
  });

  test('getPlatformVersion', () async {
    RiverpodApp riverpodAppPlugin = RiverpodApp();
    MockRiverpodAppPlatform fakePlatform = MockRiverpodAppPlatform();
    RiverpodAppPlatform.instance = fakePlatform;

    expect(await riverpodAppPlugin.getPlatformVersion(), '42');
  });
}
