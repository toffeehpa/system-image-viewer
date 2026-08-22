#include "FileOps.h"

#include <QClipboard>
#include <QDesktopServices>
#include <QFileInfo>
#include <QGuiApplication>
#include <QImage>
#include <QProcess>

namespace FileOps {

    void copyToClipboard(const QUrl &fileUrl)
    {
        const QString path = fileUrl.toLocalFile();
        if (path.isEmpty())
            return;

        const QImage img(path);
        if (img.isNull())
            return;

        QGuiApplication::clipboard()->setImage(img);
    }

    void locateOnDisk(const QUrl &fileUrl)
    {
        const QString path = fileUrl.toLocalFile();
        if (path.isEmpty())
            return;

        if (QProcess::startDetached(QStringLiteral("dolphin"),
                { QStringLiteral("--select"), path }))
            return;

        const QFileInfo info(path);
        QDesktopServices::openUrl(QUrl::fromLocalFile(info.absolutePath()));
    }

}