#include "include/log_export/log_export_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "log_export_plugin.h"

void LogExportPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  log_export::LogExportPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
