#ifndef SETTINGMANAGER_H
#define SETTINGMANAGER_H

#include <QQuickItem>

class SettingManager : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(SettingManager)

public:
    SettingManager(QQuickItem *parent = 0);
    ~SettingManager();
};

#endif // SETTINGMANAGER_H

