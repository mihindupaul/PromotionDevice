import QtQuick 1.1

Rectangle {
    property alias kp_txt:kp_txt
    //property int text_mode

    width: 100
    height: 62

    TextInput{
        width: parent.width
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        color: 'black'
        id: kp_txt
    }
}

