#ifndef FLUTTER_PLUGIN_RIVERPOD_APP_PLUGIN_H_
#define FLUTTER_PLUGIN_RIVERPOD_APP_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace riverpod_app {

class RiverpodAppPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  RiverpodAppPlugin();

  virtual ~RiverpodAppPlugin();

  // Disallow copy and assign.
  RiverpodAppPlugin(const RiverpodAppPlugin&) = delete;
  RiverpodAppPlugin& operator=(const RiverpodAppPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace riverpod_app

#endif  // FLUTTER_PLUGIN_RIVERPOD_APP_PLUGIN_H_
