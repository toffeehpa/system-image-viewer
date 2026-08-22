import QtQuick
import QtQuick.Controls
import SystemImageViewer

Item {
    id: imageView

    property alias source: image.source
    readonly property real minScale: 0.1
    readonly property real maxScale: 8.0
    property real fitScale: 1

    signal locateOnDiskRequested(url fileUrl)

    // память позиции файлов
    property var perImageState: ({})
    property bool currentAdjusted: false
    property string currentKey: ""
    property bool layoutPending: false

    readonly property string fileName: {
        const path = image.source.toString()
        const idx = path.lastIndexOf('/')
        return idx >= 0 ? path.substring(idx + 1) : path
    }
    readonly property size sourcePixelSize: image.sourceSize

    readonly property real centeredX: (imageView.width - image.sourceSize.width) / 2
    readonly property real centeredY: (imageView.height - image.sourceSize.height) / 2

    onWidthChanged: tryApplyLayout()
    onHeightChanged: tryApplyLayout()

    function tryApplyLayout() {
        if (!layoutPending)
            return
        if (image.status !== Image.Ready)
            return
        if (imageView.width <= 0 || imageView.height <= 0)
            return

        const srcW = image.sourceSize.width
        const srcH = image.sourceSize.height
        if (srcW <= 0 || srcH <= 0)
            return

        const fit = Math.min(1, Math.min(imageView.width / srcW, imageView.height / srcH))
        imageView.fitScale = fit

        image.width = srcW
        image.height = srcH

        const key = image.source.toString()
        const saved = imageView.perImageState[key]

        let targetScale, targetX, targetY

        if (saved) {
            targetScale = saved.scale
            targetX = saved.x
            targetY = saved.y
            imageView.currentAdjusted = true
        } else {
            targetScale = fit
            targetX = (imageView.width - srcW) / 2
            targetY = (imageView.height - srcH) / 2
            imageView.currentAdjusted = false
        }

        image.scale = targetScale
        image.x = targetX
        image.y = targetY

        imageView.currentKey = key
        imageView.layoutPending = false

        console.log("[ImageView] key:", key,
            "| sourceSize:", srcW + "x" + srcH,
            "| container:", imageView.width + "x" + imageView.height,
            "| has saved state:", !!saved,
            "| TARGET x/y:", targetX, targetY,
            "| TARGET scale:", targetScale)
    }

    Image {
        id: image
        fillMode: Image.PreserveAspectFit
        smooth: true
        asynchronous: true

        onSourceChanged: {
            if (imageView.currentAdjusted && imageView.currentKey.length > 0) {
                imageView.perImageState[imageView.currentKey] = {
                    scale: scale, x: x, y: y
                }
            }
            zoomHud.hide()
        }

        onStatusChanged: {
            if (status === Image.Ready) {
                imageView.layoutPending = true
                imageView.tryApplyLayout()
            }
        }
        onScaleChanged: zoomHud.pop()

        Behavior on scale {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
        }
        Behavior on x {
            enabled: !dragArea.drag.active
            NumberAnimation { duration: 320; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
        }
        Behavior on y {
            enabled: !dragArea.drag.active
            NumberAnimation { duration: 320; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            hoverEnabled: true
            drag.target: image
            cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
            drag.onActiveChanged: {
                if (drag.active)
                    imageView.currentAdjusted = true
            }
            onWheel: (wheel) => {
                const factor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
                image.scale = Math.max(imageView.minScale,
                    Math.min(imageView.maxScale, image.scale * factor))
                imageView.currentAdjusted = true
            }
            onDoubleClicked: imageView.toggleFitActual()
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: (mouse) => {
            contextMenu.x = mouse.x
            contextMenu.y = mouse.y
            contextMenu.open()
        }
    }

    Menu {
        id: contextMenu

        MenuItem {
            text: "Copy"
            onTriggered: FileActions.copyToClipboard(image.source)
        }
        MenuSeparator {}
        MenuItem {
            text: "Quick edit"
            enabled: false
        }
        MenuItem {
            text: "Locate on disk"
            onTriggered: imageView.locateOnDiskRequested(image.source)
        }
    }

    PinchArea {
        anchors.fill: image
        pinch.target: image
        pinch.minimumScale: imageView.minScale
        pinch.maximumScale: imageView.maxScale
        onPinchStarted: imageView.currentAdjusted = true
    }

    function toggleFitActual() {
        const isActual = Math.abs(image.scale - 1) < 0.01
        if (isActual) {
            image.scale = imageView.fitScale
            image.x = imageView.centeredX
            image.y = imageView.centeredY
            imageView.currentAdjusted = false
            delete imageView.perImageState[imageView.currentKey]
        } else {
            image.scale = 1
            image.x = imageView.centeredX
            image.y = imageView.centeredY
            imageView.currentAdjusted = true
        }
    }

    ZoomHud {
        id: zoomHud
        anchors.centerIn: parent
        text: Math.round(image.scale * 100) + "%"
    }
}