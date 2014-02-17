#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QQuickItem>

class AudioRecorder : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(AudioRecorder)

public:
    AudioRecorder(QQuickItem *parent = 0);
    ~AudioRecorder();
};

#endif // AUDIORECORDER_H

