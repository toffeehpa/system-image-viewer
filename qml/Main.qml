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

    ImageModel {
        id: model
    }

    Item {
        id: content
        anchors.fill: parent
        focus: true

        readonly property var testImages: [
            "qrc:/qt/qml/SystemImageViewer/qml/assets/test-image.png",
            "qrc:/qt/qml/SystemImageViewer/qml/assets/mafuyu.webp"
        ]
        property int testIndex: 0
        // todo: подогнать под реальную высоту filmstrip, когда он появится
        property real filmstripReserve: 120

        readonly property bool useModel: model.count > 0
        readonly property url activeSource: useModel
            ? model.currentSource
            : testImages[testIndex]

        Keys.onEscapePressed: Qt.quit()
        Keys.onLeftPressed: {
            if (useModel) model.previous()
            else testIndex = (testIndex - 1 + testImages.length) % testImages.length
        }
        Keys.onRightPressed: {
            if (useModel) model.next()
            else testIndex = (testIndex + 1) % testImages.length
        }
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_1) {
                picture.toggleFitActual()
                event.accepted = true
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "black"
            opacity: 0.6
        }

        ImageView {
            id: picture
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: content.filmstripReserve
            source: content.activeSource
        }

        Shortcut {
            sequence: "Ctrl+Alt+Shift+T"
            context: Qt.ApplicationShortcut
            onActivated: content.testIndex = 0
        }
    }
}