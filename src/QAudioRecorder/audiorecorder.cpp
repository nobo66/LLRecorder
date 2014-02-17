#include "audiorecorder.h"
#include <QDebug>

AudioRecorder::AudioRecorder(QQuickItem *parent):
    QQuickItem(parent)
{
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);

    qDebug() << "[AudioRecorder]created!!";
}

AudioRecorder::~AudioRecorder()
{
}

void AudioRecorder::record()
{
    qDebug() << "[AudioRecorder]record!!";
//    m_audioRecorder->record();
}

void AudioRecorder::stop()
{
    qDebug() << "[AudioRecorder]stop!!";
//    m_audioRecorder->stop();
}

