import QtQuick 1.1
import "../"

// waiting page is defined locally
BaseScreen{
    id:root

    visible: false
        Image {
            id:hourglass
            anchors.centerIn: parent
            anchors.top: parent.top
            source: "qrc:/res/lodingScreen.png"
        }
}
