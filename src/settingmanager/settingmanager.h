#ifndef SETTINGMANAGER_H
#define SETTINGMANAGER_H

#include <QQuickItem>
#include <QJsonObject>

class SettingManager : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(SettingManager)

public:
    SettingManager(QQuickItem *parent = 0);
    ~SettingManager();

public slots:
    void setValue(QString name, QVariant value);
    QVariant getValue(QString name);
    bool save();

private:
    QJsonObject m_json;
    bool load();
};

#endif // SETTINGMANAGER_H

