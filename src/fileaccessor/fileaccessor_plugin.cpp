#include "fileaccessor_plugin.h"
#include "fileaccessor.h"

#include <qqml.h>

void FileaccessorPlugin::registerTypes(const char *uri)
{
    // @uri com.nobo66.filesystem
    qmlRegisterType<FileAccessor>(uri, 1, 0, "FileAccessor");
}


