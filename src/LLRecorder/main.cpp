#include "qtquick2controlsapplicationviewer.h"
//#include <QtGui/QGuiApplication>
#include <QQmlContext>
#include <QFile>

int main(int argc, char *argv[])
{
    Application app(argc, argv);

    QtQuick2ControlsApplicationViewer viewer;

    QFile file;

    //https://bugreports.qt-project.org/browse/QTCREATORBUG-11048
    //http://qt-project.org/forums/viewthread/37597/
    viewer.rootContext()->setContextProperty("fileAccessor", &file);

    viewer.setMainQmlFile(QStringLiteral("qml/LLRecorder/main.qml"));
    viewer.show();

    return app.exec();
}
