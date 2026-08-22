#pragma once

#include <QUrl>

namespace FileOps {
    void copyToClipboard(const QUrl &fileUrl);
    void locateOnDisk(const QUrl &fileUrl);
}