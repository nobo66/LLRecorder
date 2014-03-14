TEMPLATE = lib
TARGET = settingmanager
QT += qml quick
CONFIG += qt plugin

TARGET = $$qtLibraryTarget($$TARGET)
uri = com.nobo66.settingmanager
userapp = LLRecorder
macx {
    DESTDIR = ../$${userapp}/$${userapp}.app/Contents/MacOS/$$replace(uri, \\., /)
} else:unix {
    DESTDIR = ../$${userapp}/$$replace(uri, \\., /)
} else:win32 {
    CONFIG(debug,debug|release) {
      DESTDIR = ../$${userapp}/debug/$$replace(uri, \\., /)
    } else {
      DESTDIR = ../$${userapp}/release/$$replace(uri, \\., /)
    }
}

# Input
SOURCES += \
    settingmanager_plugin.cpp \
    settingmanager.cpp

HEADERS += \
    settingmanager_plugin.h \
    settingmanager.h

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

