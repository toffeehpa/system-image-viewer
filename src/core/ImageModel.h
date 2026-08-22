#pragma once

#include <QAbstractListModel>
#include <QQmlEngine>
#include <QStringList>
#include <QUrl>

class ImageModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(QUrl currentSource READ currentSource NOTIFY currentIndexChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    enum Roles {
        FileUrlRole = Qt::UserRole + 1,
        FileNameRole
    };

    explicit ImageModel(QObject *parent = nullptr);

    QUrl currentSource() const;
    int currentIndex() const;
    int count() const;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void openFile(const QUrl &fileUrl);
    void next();
    void previous();
    void setCurrentIndex(int index);

    signals:
        void currentIndexChanged();
    void countChanged();

private:
    void loadDirectory(const QString &filePath);

    QStringList m_files;
    int m_index = -1;
};