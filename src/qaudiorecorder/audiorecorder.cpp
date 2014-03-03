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
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);

    qDebug() << "[AudioRecorder]created!!";
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
    m_source.remove("file://");
    QFileInfo source(m_source);
    QAudioEncoderSettings asettings = m_audioRecorder->audioSettings();
    if(asettings.codec() == "audio/pcm" || asettings.codec() == "audio/PCM")
    {
        source.setFile(m_source + ".wav");
#if defined Q_OS_LINUX
        //added file extension
        m_source += ".wav";
#elif defined Q_OS_WIN
        //added file extension
        m_source += ".wav";
        //remove first "/"
        m_source.remove(0,1);
        source.setFile(m_source);
#endif
    } else {
        //other formats are not tested on Mac and Windows
        QString extension = "." + (asettings.codec()).remove("audio/");
        source.setFile(m_source + extension);
#if defined Q_OS_LINUX
        m_source += extension;
#elif defined Q_OS_WIN
        m_source += extension;
        m_source.remove(0,1);
        source.setFile(m_source);
#endif
    }
    qDebug() << "source.absoluteFilePath=" << source.absoluteFilePath();
    qDebug() << "m_source=" << m_source;
    qDebug() << "does file exists? -> " << source.exists();
    if(source.exists() && overWrite==false){
        emit fileExists();
        return;
    }
    m_audioRecorder->setOutputLocation(m_source);
    //setOutputLocation doesn't work on Qt5.2.0 for windows
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

    QAudioDeviceInfo outDeviceInfo(QAudioDeviceInfo::defaultOutputDevice());
    codecs = outDeviceInfo.supportedCodecs();
    for (int i = 0; i < codecs.size(); ++i) {
        qDebug() << "out device supported codecs" << i << codecs.at(i).toLocal8Bit().constData() << endl;
    }
    QAudioDeviceInfo inDeviceInfo(QAudioDeviceInfo::defaultInputDevice());

    codecs = inDeviceInfo.supportedCodecs();
    for (int i = 0; i < codecs.size(); ++i) {
         qDebug() << "in device supported codecs" << i << codecs.at(i).toLocal8Bit().constData() << endl;
    }


    qDebug() << "new QAudioRecorder";
    m_audioRecorder = new QAudioRecorder(this);

    codecs = m_audioRecorder->supportedAudioCodecs();
    for (int i = 0; i < codecs.size(); ++i){
        m_supportedCodecs.append(codecs.at(i).toLocal8Bit().constData());
        qDebug() << "supported codecs" << i << codecs.at(i).toLocal8Bit().constData() << endl;
    }

    QAudioEncoderSettings audioSettings;
//    audioSettings.setCodec("audio/pcm");
    qDebug() << "setCodec to " << codecs.at(0).toLocal8Bit().constData();
    audioSettings.setCodec(codecs.at(0).toLocal8Bit().constData());
    audioSettings.setQuality(QMultimedia::HighQuality);

    m_audioRecorder->setEncodingSettings(audioSettings);


    qDebug() << "current path is " << QDir::currentPath();

    QStringList inputs = m_audioRecorder->audioInputs();
    QString selectedInput = m_audioRecorder->defaultAudioInput();


//    foreach (QString input, inputs) {
//        QString description = m_audioRecorder->audioInputDescription(input);
//        // show descriptions to user and allow selection
//        selectedInput = input;
//    }

    m_audioRecorder->setAudioInput(selectedInput);

//    qDebug() << "isMetaDataWritable is" << m_audioRecorder->isMetaDataWritable();
//    m_audioRecorder->setMetaData(QMediaMetaData::Title, QVariant(QLatin1String("Test Title")));
//    m_audioRecorder->setMetaData(QMediaMetaData::AlbumTitle, QVariant(QLatin1String("Album Title")));
//    m_audioRecorder->setMetaData(QMediaMetaData::AlbumArtist, QVariant(QLatin1String("Album Artist")));
//    codecs = m_audioRecorder->supportedAudioCodecs();
//    for (int i = 0; i < codecs.size(); ++i)
//         qDebug() << "supported codecs" << i << codecs.at(i).toLocal8Bit().constData() << endl;
//    codecs = m_audioRecorder->supportedAudioSampleRates();
//    for (int i = 0; i < codecs.size(); ++i)
//         qDebug() << "supported sample rates" << i << codecs.at(i).toLocal8Bit().constData() << endl;
}

