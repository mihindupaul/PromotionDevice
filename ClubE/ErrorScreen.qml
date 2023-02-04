import QtQuick 1.1

BaseScreen {
    property alias error_text1:error_text1
    property alias error_text2:error_text2

    Image {
        scale: c_btn.pressed? 0.9:1.0

        source: "qrc:/res/CloseBtn.png"
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top

        MouseArea{
            id:c_btn
            anchors.fill: parent
            onClicked: {
                control_bord.setIdelBuzzerFreq(3443,100000)
                root.state="main"
            }
        }
    }

    Rectangle{
        color: '#ffffff'
        width: parent.width * .75
        height: parent.height * .7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Column{
            anchors.centerIn: parent
            width: parent.width

            Text {
                id: error_text1
                anchors.horizontalCenter: parent.horizontalCenter
                color:"#d13530"
                font.pointSize: 15
                text: qsTr("error line 1")
                horizontalAlignment:Text.AlignHCenter
            }

            Text {
                id: error_text2
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 15
                horizontalAlignment:Text.AlignHCenter
                width: parent.width
                color: "#d13530"
                elide: Text.ElideRight
                text: qsTr("error line 2")
            }

        }

//        MouseArea{
//            anchors.fill: parent
//            onClicked: {
//                root.state="pin"
//                console.log('error .....')
//            }
//        }
    }
}

