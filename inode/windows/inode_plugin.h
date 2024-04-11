#ifndef FLUTTER_PLUGIN_INODE_PLUGIN_H_
#define FLUTTER_PLUGIN_INODE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace inode {

class InodePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  InodePlugin();

  virtual ~InodePlugin();

  // Disallow copy and assign.
  InodePlugin(const InodePlugin&) = delete;
  InodePlugin& operator=(const InodePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace inode

#endif  // FLUTTER_PLUGIN_INODE_PLUGIN_H_
