#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSurfaceFormat>
#include <QUrl>
#include <QVariant>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("System Viewer"));
    app.setOrganizationName(QStringLiteral("system-image-viewer"));

    QSurfaceFormat format;
    format.setAlphaBufferSize(8);
    QSurfaceFormat::setDefaultFormat(format);

    QQmlApplicationEngine engine;
    engine.loadFromModule("SystemImageViewer", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    const QStringList args = app.arguments();
    if (args.size() > 1) {
        const QUrl fileUrl = QUrl::fromLocalFile(args.at(1));
        QMetaObject::invokeMethod(engine.rootObjects().first(), "openInitialFile",
                                   Q_ARG(QVariant, QVariant::fromValue(fileUrl)));
    }

    return app.exec();
}