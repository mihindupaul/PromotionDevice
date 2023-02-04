import QtQuick 1.1

Rectangle {
    id:base_screen
    width: parent.width
    height: parent.height
    color: '#d13530'
    //color: 'white'
    visible: false

    signal close()

    property alias buzz_small:buzz_small.visible

    Image {      
        source: "qrc:/res/EfmLogo.png"
        anchors.top: parent.top
        anchors.left: parent.left
    }

    Image {
        id: buzz_small
        source: "qrc:/res/BuzzLogoSmall.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

