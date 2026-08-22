import QtQuick
import QtQuick.Window
import SystemImageViewer

Window {
    id: normalWindow

    property ImageModel imageModel: null

    title: viewer.imageView.fileName.length > 0 ? viewer.imageView.fileName : "System Viewer"
    color: "#1e1e1e"

    Viewer {
        id: viewer
        anchors.fill: parent
        imageModel: normalWindow.imageModel
    }

    onClosing: Qt.quit()
}