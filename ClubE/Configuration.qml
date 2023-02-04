import QtQuick 1.1
import "Qml"

BaseScreen{
    id:ranjana
    //visible: false
    signal passwordRequired()
    signal moveConfig()

    onVisibleChanged: {
        //console.log(visible)
    }

    Text {
        id: conf_txt
        font.bold: true
        color: 'white'
        text: qsTr("SETTINGS")
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 30
    }

    Button{
        color: 'white'
        width: parent.width * .25
        height: parent.height * .4
        anchors.top: conf_txt.bottom
        anchors.left: parent.left
        anchors.leftMargin: 85
        anchors.topMargin: 20
        caption.text: ""

        Image {
            source: "qrc:/res/WifiBars.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            Text {
                color: "#d13530"
                font.bold: true
                text: qsTr("WI-FI")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                color: "#d13530"
                font.bold: true
                text: qsTr("SETTINGS")
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        onClicked: {
            //console.log('t2')
            ranjana.state="wifi"
        }
    }

    Button{
        id: server_btn
        color: 'white'
        width: parent.width * .25
        height: parent.height * .4
        anchors.top: conf_txt.bottom
        anchors.right: parent.right
        anchors.rightMargin: 85
        anchors.topMargin: 20
        caption.text: ""

        Image {
            source: "qrc:/res/ConfigWheel.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Column{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 10

            Text {
                color: "#d13530"
                font.bold: true
                text: qsTr("SERVER")
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                color: "#d13530"
                font.bold: true
                text: qsTr("CONFIG")
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }

        onClicked: {
            if(!wms.visible){
                if(isMaster){
                    root.state="base_url"
                    isMaster=false
                }
                else
                    root.state="password"
            }
        }
    }

    Button{
        color: 'white'
        width: parent.width * .31
        height: parent.height * .14
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        caption.text: ""

        Text {
            color: '#d13530'
            text: qsTr("CLOSE")
            font.bold: true
            anchors.centerIn: parent
        }

        onClicked: {
            close()
        }
    }

    WifiScreen{
        id:wms
        onClose: ranjana.state = ""
    }

//    DeviceAuthentication{
//        id: config2
//        buzz_small:false
//        onErrorOcured: {
//            manageErrors(t1,t2)
//            screen_name="password"
//        }
//    }

    states: [
        State{
            name:"wifi"
            PropertyChanges {target: wms; visible:true ; state:"refresh"}
        }//,
//        State{
//            name:"configuration"
//            PropertyChanges {target: config2; visible:true}
//        }
    ]
}

