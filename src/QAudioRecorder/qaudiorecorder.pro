TEMPLATE = lib
TARGET = QAudioRecorder
QT += qml quick multimedia

CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = com.nobo66.qaudiorecorderplugin
userapp = LLRecorder
macx {
    DESTDIR = $${userapp}.app/Contents/MacOS/$$replace(uri, \\., /)
}

# Input
SOURCES += \
    qaudiorecorder_plugin.cpp \
    audiorecorder.cpp

HEADERS += \
    qaudiorecorder_plugin.h \
    audiorecorder.h

OTHER_FILES = qmldir

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/$$DESTDIR/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir
unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}

