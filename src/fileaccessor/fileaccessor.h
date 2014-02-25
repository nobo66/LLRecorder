#ifndef FILEACCESSOR_H
#define FILEACCESSOR_H

#include <QQuickItem>

class FileAccessor : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(FileAccessor)

public:
    FileAccessor(QQuickItem *parent = 0);
    ~FileAccessor();

public slots:
    bool remove(QString fileName);
};

#endif // FILEACCESSOR_H

