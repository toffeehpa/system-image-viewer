#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QStringList>
#include <QUrl>

class ImageModel : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QUrl currentSource READ currentSource NOTIFY currentSourceChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    explicit ImageModel(QObject *parent = nullptr);

    QUrl currentSource() const;
    int currentIndex() const;
    int count() const;

public slots:
    void openFile(const QUrl &fileUrl);
    void next();
    void previous();

    signals:
        void currentSourceChanged();
    void currentIndexChanged();
    void countChanged();

private:
    void loadDirectory(const QString &filePath);

    QStringList m_files;
    int m_index = -1;
};