#include "settingmanager_plugin.h"
#include "settingmanager.h"

#include <qqml.h>

void SettingmanagerPlugin::registerTypes(const char *uri)
{
    // @uri com.nobo66.settingmanager
    qmlRegisterType<SettingManager>(uri, 1, 0, "SettingManager");
}


