import QtQuick

Rectangle {
    id: root

    property alias text: label.text

    radius: 8
    color: "#000000"
    opacity: 0
    visible: opacity > 0
    width: label.implicitWidth + 24
    height: label.implicitHeight + 12

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }

    Text {
        id: label
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: 22
    }

    Timer {
        id: hideTimer
        interval: 700
        onTriggered: root.opacity = 0
    }

    function pop() {
        root.opacity = 0.9
        hideTimer.restart()
    }

    function hide() {
        root.opacity = 0
    }
}