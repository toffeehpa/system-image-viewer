#pragma once

#include <QObject>
#include <QQmlEngine>
#include <QUrl>

class FileActions : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

public:
    explicit FileActions(QObject *parent = nullptr) : QObject(parent) {}

public slots:
    void copyToClipboard(const QUrl &fileUrl);
    void locateOnDisk(const QUrl &fileUrl);
};