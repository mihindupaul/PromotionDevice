import QtQuick 1.1

Rectangle {
    id:root
    width: 100
    height: 62
    //color: enabled?"yellow":Qt.darker(root.color, 2.5)
    radius: 2

    scale: ma.pressed? 0.9:1.0

    property alias caption :caption
    //property alias c name: value

    signal clicked()

    Text{
        id:caption
        anchors.verticalCenter: parent.verticalCenter
        text:"Accept"
        //anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MouseArea{
        id:ma
        anchors.fill: parent
        onClicked:{
            control_bord.setIdelBuzzerFreq(3443,100000)
            root.clicked()
        }
    }
}

