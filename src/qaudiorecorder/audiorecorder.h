#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QQuickItem>
#include <QAudioRecorder>

class AudioRecorder : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(AudioRecorder)
    Q_PROPERTY(QString source MEMBER m_source NOTIFY sourceChanged)
    Q_PROPERTY(QStringList supportedCodecs MEMBER m_supportedCodecs NOTIFY supportedCodecsChanged)
    Q_PROPERTY(int codec READ codec WRITE setCodec NOTIFY codecChanged)

public:
    AudioRecorder(QQuickItem *parent = 0);
    ~AudioRecorder();

public slots:
    void record(bool overWrite=false);
    void stop();
    int codec();
    void setCodec(int value);

signals:
    void sourceChanged();
    void supportedCodecsChanged();
    void codecChanged();
    void fileExists();

private:
    QAudioRecorder* m_audioRecorder;
    QString         m_source;
    QStringList     m_supportedCodecs;
    int             m_codecIndex;

    void initializeQAudioRecorder();
};

#endif // AUDIORECORDER_H

