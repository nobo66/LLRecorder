#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QQuickItem>
#include <QAudioRecorder>

class AudioRecorder : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(AudioRecorder)

public:
    AudioRecorder(QQuickItem *parent = 0);
    ~AudioRecorder();

public slots:
    void record();
    void stop();

private:
    QAudioRecorder* m_audioRecorder;
};

#endif // AUDIORECORDER_H

