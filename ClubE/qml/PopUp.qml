import QtQuick 1.1

Rectangle {
    signal keyChange(string s)
    property alias disply:disply
    property alias key_pad:key_pad
    property string old_val

    color: 'black'
    width: 300
    height: 260
    radius: 8

    signal closePopup()

    KeyPadDisplay{
        id: disply
        width: 224
        height: 40
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 5
        kp_txt.font.pointSize: 18
        kp_txt.font.bold: true
        kp_txt.color: 'black'
        color: 'white'
    }

    Image {
        source: "qrc:/res/Check.png"
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        width: parent.width * .15
        height:40

        MouseArea{
            anchors.fill: parent
            onClicked: {
                closePopup()
            }
        }
    }

    KeyPad{
        id: key_pad
        //width: parent.width
        height: parent.height * .85
        scale:.9
        anchors.top: disply.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter:parent.horizontalCenter

        onKeyConfirmed:{
            //var txt=old_val+s
            disply.kp_txt.text=s
            display_val=s
            //console.log(display_val)
            keyChange(s)
        }
    }

}
