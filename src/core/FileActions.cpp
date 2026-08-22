#include "FileActions.h"

#include <QClipboard>
#include <QDesktopServices>
#include <QFileInfo>
#include <QGuiApplication>
#include <QImage>
#include <QProcess>

void FileActions::copyToClipboard(const QUrl &fileUrl)
{
    const QString path = fileUrl.toLocalFile();
    if (path.isEmpty())
        return;

    const QImage img(path);
    if (img.isNull())
        return;

    QGuiApplication::clipboard()->setImage(img);
}

void FileActions::locateOnDisk(const QUrl &fileUrl)
{
    const QString path = fileUrl.toLocalFile();
    if (path.isEmpty())
        return;

    // Dolphin
    if (QProcess::startDetached(QStringLiteral("dolphin"),
            { QStringLiteral("--select"), path }))
        return;

    // фолбэк
    const QFileInfo info(path);
    QDesktopServices::openUrl(QUrl::fromLocalFile(info.absolutePath()));
}