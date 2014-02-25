#ifndef FILEACCESSOR_PLUGIN_H
#define FILEACCESSOR_PLUGIN_H

#include <QQmlExtensionPlugin>

class FileaccessorPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // FILEACCESSOR_PLUGIN_H

