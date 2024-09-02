//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <ambient_light/ambient_light_plugin.h>
#include <audioplayers_linux/audioplayers_linux_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) ambient_light_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AmbientLightPlugin");
  ambient_light_plugin_register_with_registrar(ambient_light_registrar);
  g_autoptr(FlPluginRegistrar) audioplayers_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AudioplayersLinuxPlugin");
  audioplayers_linux_plugin_register_with_registrar(audioplayers_linux_registrar);
}
