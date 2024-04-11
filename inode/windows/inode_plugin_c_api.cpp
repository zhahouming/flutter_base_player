#include "include/inode/inode_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "inode_plugin.h"

void InodePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  inode::InodePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
