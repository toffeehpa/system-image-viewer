import QtQuick

Item {
    id: filmstrip

    property var imageModel
    property real filmstripOpacity: 0

    property int thumbnailSize: 40
    readonly property int verticalPadding: 4

    implicitHeight: thumbnailSize + verticalPadding * 2

    opacity: filmstripOpacity
    visible: opacity > 0.01

    Behavior on opacity {
        NumberAnimation { duration: 120; easing.type: Easing.OutCubic }
    }

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.5
    }

    ListView {
        id: strip
        anchors.fill: parent
        anchors.margins: filmstrip.verticalPadding
        orientation: ListView.Horizontal
        spacing: 3
        clip: true
        interactive: false
        highlightFollowsCurrentItem: false
        model: filmstrip.imageModel
        currentIndex: filmstrip.imageModel ? filmstrip.imageModel.currentIndex : -1

        Behavior on contentX {
            NumberAnimation { duration: 320; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
        }

        function centerOnCurrent() {
            if (currentIndex < 0 || count === 0)
                return
            const cellSize = filmstrip.thumbnailSize + spacing
            contentX = currentIndex * cellSize + filmstrip.thumbnailSize / 2 - width / 2
        }

        onCurrentIndexChanged: centerOnCurrent()
        onWidthChanged: centerOnCurrent()
        Component.onCompleted: centerOnCurrent()

        delegate: Rectangle {
            id: thumbDelegate
            width: filmstrip.thumbnailSize
            height: filmstrip.thumbnailSize
            color: "transparent"
            radius: 3
            border.width: index === strip.currentIndex ? 1 : 0
            border.color: "white"

            Image {
                anchors.fill: parent
                anchors.margins: 1
                source: model.fileUrl
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                smooth: true
                sourceSize.width: thumbDelegate.width
                sourceSize.height: thumbDelegate.height
            }

            MouseArea {
                anchors.fill: parent
                onClicked: filmstrip.imageModel.setCurrentIndex(index)
            }
        }
    }
}