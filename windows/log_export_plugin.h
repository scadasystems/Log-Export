#ifndef FLUTTER_PLUGIN_LOG_EXPORT_PLUGIN_H_
#define FLUTTER_PLUGIN_LOG_EXPORT_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace log_export {

class LogExportPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  LogExportPlugin();

  virtual ~LogExportPlugin();

  // Disallow copy and assign.
  LogExportPlugin(const LogExportPlugin&) = delete;
  LogExportPlugin& operator=(const LogExportPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace log_export

#endif  // FLUTTER_PLUGIN_LOG_EXPORT_PLUGIN_H_
