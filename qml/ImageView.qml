import QtQuick

Item {
    id: imageView

    property alias source: image.source
    readonly property real minScale: 0.1
    readonly property real maxScale: 8.0
    property real fitScale: 1

    function toggleFitActual() {
        const actualScale = imageView.fitScale > 0
            ? Math.min(imageView.maxScale, Math.max(imageView.minScale, 1 / imageView.fitScale))
            : 1
        const isFit = Math.abs(image.scale - 1) < 0.01
        image.scale = isFit ? actualScale : 1
        image.x = 0
        image.y = 0
    }

    Image {
        id: image
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true
        onSourceChanged: {
            scale = 1
            x = 0
            y = 0
            zoomHud.hide()
        }
        onStatusChanged: {
            if (status === Image.Ready)
                imageView.fitScale = Math.min(width / sourceSize.width, height / sourceSize.height)
        }
        onScaleChanged: zoomHud.pop()

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
    }

    PinchArea {
        anchors.fill: parent
        pinch.target: image
        pinch.minimumScale: imageView.minScale
        pinch.maximumScale: imageView.maxScale
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        drag.target: image
        cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        onWheel: (wheel) => {
            const factor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
            image.scale = Math.max(imageView.minScale,
                Math.min(imageView.maxScale, image.scale * factor))
        }
        onDoubleClicked: imageView.toggleFitActual()
    }

    ZoomHud {
        id: zoomHud
        anchors.centerIn: parent
        text: Math.round(imageView.fitScale * image.scale * 100) + "%"
    }
}