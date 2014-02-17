#ifndef QAUDIORECORDER_PLUGIN_H
#define QAUDIORECORDER_PLUGIN_H

#include <QQmlExtensionPlugin>

class QAudioRecorderPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
    void registerTypes(const char *uri);
};

#endif // QAUDIORECORDER_PLUGIN_H

