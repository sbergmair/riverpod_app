//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <riverpod_app/riverpod_app_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) riverpod_app_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "RiverpodAppPlugin");
  riverpod_app_plugin_register_with_registrar(riverpod_app_registrar);
}
