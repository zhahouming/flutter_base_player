//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <inode/inode_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) inode_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "InodePlugin");
  inode_plugin_register_with_registrar(inode_registrar);
}
