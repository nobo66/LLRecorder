#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QQuickItem>
#include <QAudioRecorder>

class AudioRecorder : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(AudioRecorder)
    Q_PROPERTY(QString source MEMBER m_source NOTIFY sourceChanged)

public:
    AudioRecorder(QQuickItem *parent = 0);
    ~AudioRecorder();

public slots:
    void record(bool overWrite=false);
    void stop();

signals:
    void sourceChanged();
    void fileExists();

private:
    QAudioRecorder* m_audioRecorder;
    QString         m_source;

    void initializeQAudioRecorder();
};

#endif // AUDIORECORDER_H

