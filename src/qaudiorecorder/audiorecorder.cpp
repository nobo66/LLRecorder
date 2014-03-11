#include "audiorecorder.h"
#include <QDebug>
#include <QAudioDeviceInfo>
#include <QDir>
#include <QFileInfo>

AudioRecorder::AudioRecorder(QQuickItem *parent):
    QQuickItem(parent)
  ,m_source("")
  ,m_codecIndex(0)
{
    m_supportedCodecs.clear();
    this->initializeQAudioRecorder();
}

AudioRecorder::~AudioRecorder()
{
    if(m_audioRecorder)
    {
        delete m_audioRecorder;
        m_audioRecorder = NULL;
    }
}

void AudioRecorder::record(bool overWrite)
{
#if defined Q_OS_WIN
    m_source.remove("file:///");
#else
    m_source.remove("file://");
#endif
    QFileInfo source(m_source);
    QAudioEncoderSettings asettings = m_audioRecorder->audioSettings();
    if(asettings.codec() == "audio/pcm" || asettings.codec() == "audio/PCM")
    {
        source.setFile(m_source + ".wav");
#if (defined Q_OS_LINUX) || (defined Q_OS_WIN)
        //added file extension
        m_source += ".wav";
#endif
    } else {
        //other formats are not tested on Mac and Windows
        QString extension = "." + (asettings.codec()).remove("audio/");
        source.setFile(m_source + extension);
#if (defined Q_OS_LINUX) || (defined Q_OS_WIN)
        m_source += extension;
#endif
    }
#if defined Q_OS_WIN
    // "file:///" seems to be needed on Windows.
    m_source.insert(0,"file:///");
#endif
    qDebug() << "source.absoluteFilePath=" << source.absoluteFilePath();
    qDebug() << "m_source=" << m_source;
    qDebug() << "does file exists? -> " << source.exists();
    if(source.exists() && overWrite==false){
        emit fileExists();
        return;
    }
    m_audioRecorder->setOutputLocation(m_source);
    qDebug() << "outputLocation=" << m_audioRecorder->outputLocation();
    m_audioRecorder->record();
}

void AudioRecorder::stop()
{
    m_audioRecorder->stop();
}

int AudioRecorder::codec(){
    return m_codecIndex;
}

void AudioRecorder::setCodec(int value){
    if(m_codecIndex!=value){
        m_codecIndex = value;
        QAudioEncoderSettings audioSettings;
        qDebug() << "setCodec to " << m_supportedCodecs[m_codecIndex];
        audioSettings.setCodec(m_supportedCodecs[m_codecIndex]);
        audioSettings.setQuality(QMultimedia::HighQuality);
        m_audioRecorder->setEncodingSettings(audioSettings);
        emit codecChanged();
    }
}

void AudioRecorder::initializeQAudioRecorder()
{
    QStringList codecs;
    QAudioEncoderSettings audioSettings;

    m_audioRecorder = new QAudioRecorder(this);

    codecs = m_audioRecorder->supportedAudioCodecs();
    for (int i = 0; i < codecs.size(); ++i){
        m_supportedCodecs.append(codecs.at(i).toLocal8Bit().constData());
        qDebug() << "supported codecs" << i << codecs.at(i).toLocal8Bit().constData() << endl;
    }

    qDebug() << "setCodec to " << codecs.at(0).toLocal8Bit().constData();
    audioSettings.setCodec(codecs.at(0).toLocal8Bit().constData());
    audioSettings.setQuality(QMultimedia::HighQuality);
    m_audioRecorder->setEncodingSettings(audioSettings);
}

