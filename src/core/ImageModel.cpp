#include "ImageModel.h"

#include <QDir>
#include <QFileInfo>

namespace {
    // todo: расширить/вынести в конфиг, когда появится плагинный backend форматов
    const QStringList kImageFilters = {
        "*.png", "*.jpg", "*.jpeg", "*.bmp", "*.gif", "*.webp", "*.svg"
    };
}

ImageModel::ImageModel(QObject *parent) : QObject(parent) {}

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

    m_files.clear();
    for (const QString &name : entries)
        m_files << dir.absoluteFilePath(name);

    m_index = m_files.indexOf(info.absoluteFilePath());
    if (m_index < 0 && !m_files.isEmpty())
        m_index = 0;

    emit countChanged();
    emit currentIndexChanged();
    emit currentSourceChanged();
}

void ImageModel::next()
{
    if (m_files.isEmpty())
        return;
    m_index = (m_index + 1) % m_files.size();
    emit currentIndexChanged();
    emit currentSourceChanged();
}

void ImageModel::previous()
{
    if (m_files.isEmpty())
        return;
    m_index = (m_index - 1 + m_files.size()) % m_files.size();
    emit currentIndexChanged();
    emit currentSourceChanged();
}