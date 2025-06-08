#include "include/riverpod_app/riverpod_app_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "riverpod_app_plugin.h"

void RiverpodAppPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  riverpod_app::RiverpodAppPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
