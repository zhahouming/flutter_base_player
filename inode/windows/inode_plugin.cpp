#include "inode_plugin.h"
// This must be included before many other Windows headers.
#include <windows.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace inode
{
  std::wstring ConvertStringToWString(const std::string &utf8_string)
  {
    std::wstring wide_string;
    int wchar_count = MultiByteToWideChar(CP_UTF8, 0, utf8_string.data(), -1, NULL, 0);
    if (wchar_count > 0)
    {
      wide_string.resize(wchar_count - 1);
      MultiByteToWideChar(CP_UTF8, 0, utf8_string.data(), -1, &wide_string[0], wchar_count);
    }
    return wide_string;
  }
  // static
  void InodePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "inode",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<InodePlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result)
        {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  InodePlugin::InodePlugin() {}

  InodePlugin::~InodePlugin() {}

  void InodePlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    if (method_call.method_name().compare("getInode") == 0)
    {

      const std::string *path = std::get_if<std::string>(method_call.arguments());

      if (!path)
      {
        result->Error("argument_error", "Argument must be a string");
        return;
      }

      const std::wstring path2 = ConvertStringToWString(*path);

      HANDLE file = CreateFileW(path2.c_str(), 0, FILE_SHARE_READ | FILE_SHARE_WRITE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

      if (file == INVALID_HANDLE_VALUE)
      {
        CloseHandle(file);
        result->Error("file_error", "Failed to open file");
        return;
      }

      BY_HANDLE_FILE_INFORMATION file_info;

      if (GetFileInformationByHandle(file, &file_info))
      {
        LARGE_INTEGER file_index;
        file_index.HighPart = file_info.nFileIndexHigh;
        file_index.LowPart = file_info.nFileIndexLow;
        result->Success(flutter::EncodableValue(static_cast<int64_t>(file_index.QuadPart)));
        CloseHandle(file);
      }
      else
      {
        CloseHandle(file);
        result->Error("info_error", "Failed to get file information");
      }
    }
    else
    {
      result->NotImplemented();
    }
  }

} // namespace inode
