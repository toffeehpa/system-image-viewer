import QtQuick
import QtQuick.Window
import SystemImageViewer

Window {
    id: root
    visible: true
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.Window

    width: Screen.width
    height: Screen.height

    function openInitialFile(url) {
        model.openFile(url)
    }

    NormalWindow {
        id: normalWindow
        visible: false
    }

    function switchToNormalWindow() {
        const src = viewer.imageView.sourcePixelSize
        const maxW = Screen.width * 0.9
        const maxH = Screen.height * 0.9

        let w = src.width
        let h = src.height
        if (w > maxW || h > maxH) {
            const k = Math.min(maxW / w, maxH / h)
            w *= k
            h *= k
        }

        normalWindow.width = Math.round(w)
        normalWindow.height = Math.round(h)
        normalWindow.imageModel = model
        normalWindow.visible = true
        Qt.callLater(() => { root.visible = false })
    }

    ImageModel {
        id: model
    }

    Item {
        id: content
        anchors.fill: parent
        // На этом месте отсюда было вынесено пару функций в Viewer.qml, само собой для оптимизации и для упрощения разработкию
        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.6

            MouseArea {
                anchors.fill: parent
                onClicked: root.switchToNormalWindow()
            }
        }

        Viewer {
            id: viewer
            anchors.fill: parent
            imageModel: model
            quitOnEscape: true
        }

        Shortcut {
            sequence: "Ctrl+Alt+Shift+T"
            context: Qt.ApplicationShortcut
            onActivated: viewer.testIndex = 0
        }
    }
}