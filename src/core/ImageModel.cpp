#include "ImageModel.h"

#include <QDir>
#include <QFileInfo>

namespace {
    const QStringList kImageFilters = {
        "*.png", "*.jpg", "*.jpeg", "*.bmp", "*.gif", "*.webp", "*.svg"
    };
}

ImageModel::ImageModel(QObject *parent) : QAbstractListModel(parent) {}

QUrl ImageModel::currentSource() const
{
    if (m_index < 0 || m_index >= m_files.size())
        return {};
    return QUrl::fromLocalFile(m_files.at(m_index));
}

int ImageModel::currentIndex() const
{
    return m_index;
}

int ImageModel::count() const
{
    return m_files.size();
}

int ImageModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_files.size();
}

QVariant ImageModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_files.size())
        return {};

    const QString &path = m_files.at(index.row());
    switch (role) {
    case FileUrlRole:
        return QUrl::fromLocalFile(path);
    case FileNameRole:
        return QFileInfo(path).fileName();
    default:
        return {};
    }
}

QHash<int, QByteArray> ImageModel::roleNames() const
{
    return {
        { FileUrlRole, "fileUrl" },
        { FileNameRole, "fileName" }
    };
}

void ImageModel::openFile(const QUrl &fileUrl)
{
    const QString path = fileUrl.toLocalFile();
    if (path.isEmpty())
        return;

    loadDirectory(path);
}

void ImageModel::loadDirectory(const QString &filePath)
{
    const QFileInfo info(filePath);
    QDir dir = info.dir();

    const QStringList entries = dir.entryList(kImageFilters, QDir::Files | QDir::NoDotAndDotDot, QDir::Name);

    beginResetModel();
    m_files.clear();
    for (const QString &name : entries)
        m_files << dir.absoluteFilePath(name);
    endResetModel();

    m_index = m_files.indexOf(info.absoluteFilePath());
    if (m_index < 0 && !m_files.isEmpty())
        m_index = 0;

    emit countChanged();
    emit currentIndexChanged();
}

void ImageModel::next()
{
    if (m_files.isEmpty())
        return;
    m_index = (m_index + 1) % m_files.size();
    emit currentIndexChanged();
}

void ImageModel::previous()
{
    if (m_files.isEmpty())
        return;
    m_index = (m_index - 1 + m_files.size()) % m_files.size();
    emit currentIndexChanged();
}

void ImageModel::setCurrentIndex(int index)
{
    if (index < 0 || index >= m_files.size() || index == m_index)
        return;
    m_index = index;
    emit currentIndexChanged();
}