import QtQuick
import SystemImageViewer

Item {
    id: viewerRoot

    property ImageModel imageModel: null
    property bool quitOnEscape: false

    readonly property var testImages: [
        "qrc:/qt/qml/SystemImageViewer/qml/assets/test-image.png",
        "qrc:/qt/qml/SystemImageViewer/qml/assets/mafuyu.webp"
    ]
    property int testIndex: 0

    readonly property bool useModel: imageModel && imageModel.count > 0
    readonly property url activeSource: useModel
        ? imageModel.currentSource
        : testImages[testIndex]

    property alias imageView: picture
    readonly property alias reservedBottomHeight: filmstrip.implicitHeight

    focus: true

    property real cursorY: 0
    readonly property real filmstripZoneStart: height * 0.7
    readonly property real filmstripOpacity: cursorY <= filmstripZoneStart
        ? 0
        : Math.min(1, (cursorY - filmstripZoneStart) / (height - filmstripZoneStart))

    HoverHandler {
        onPointChanged: viewerRoot.cursorY = point.position.y
    }

    Keys.onEscapePressed: if (quitOnEscape) Qt.quit()
    Keys.onLeftPressed: {
        if (useModel) imageModel.previous()
        else testIndex = (testIndex - 1 + testImages.length) % testImages.length
    }
    Keys.onRightPressed: {
        if (useModel) imageModel.next()
        else testIndex = (testIndex + 1) % testImages.length
    }
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_1) {
            picture.toggleFitActual()
            event.accepted = true
        } else if (event.key === Qt.Key_R && (event.modifiers & Qt.ShiftModifier)) {
            picture.rotateBy(-90)
            event.accepted = true
        } else if (event.key === Qt.Key_R) {
            picture.rotateBy(90)
            event.accepted = true
        } else if (event.key === Qt.Key_H) {
            picture.flipHorizontal()
            event.accepted = true
        } else if (event.key === Qt.Key_V) {
            picture.flipVertical()
            event.accepted = true
        }
    }

    ImageView {
        id: picture
        anchors.fill: parent
        source: viewerRoot.activeSource
        useNativeContextMenu: viewerRoot.useNativeContextMenu
    }

    Text {
        id: fileInfoLabel
        anchors.bottom: filmstrip.top
        anchors.bottomMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"
        font.pixelSize: 14
        style: Text.Outline
        styleColor: "black"
        opacity: viewerRoot.filmstripOpacity
        visible: opacity > 0.01 && picture.sourcePixelSize.width > 0
        text: picture.fileName + " (" + picture.sourcePixelSize.width + "x" + picture.sourcePixelSize.height + ")"
    }

    Filmstrip {
        id: filmstrip
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: implicitHeight
        imageModel: viewerRoot.imageModel
        filmstripOpacity: viewerRoot.filmstripOpacity
    }
}