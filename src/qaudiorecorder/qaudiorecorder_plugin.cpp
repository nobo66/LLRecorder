#include "qaudiorecorder_plugin.h"
#include "audiorecorder.h"

#include <qqml.h>

void QAudioRecorderPlugin::registerTypes(const char *uri)
{
    // @uri com.nobo66.qaudiorecorderplugin
    qmlRegisterType<AudioRecorder>(uri, 1, 0, "AudioRecorder");
}


