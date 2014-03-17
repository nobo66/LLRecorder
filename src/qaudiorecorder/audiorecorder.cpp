/****************************************************************************
** Copyright (c) 2014, LLRecorder Project
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice,
** this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice,
** this list of conditions and the following disclaimer in the documentation and/or
** other materials provided with the distribution.
**
** 3. Neither the name of the copyright holder nor the names of its contributors
** may be used to endorse or promote products derived from this software without
** specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
** DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
** NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
** EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
****************************************************************************/
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

