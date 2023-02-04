import QtQuick 1.1
//import 'qrc:/js/APICaller.js' as API_call
import "Qml"

BaseScreen{
    property alias base_url_txt:base_url_txt.text
    property bool isSyncDB:false

    signal popUpKeypad()
    signal errorOcured(string t1,string t2)
    property string key_values

    onVisibleChanged: {
        if(visible){
            key_values=''
            popup.visible=false
            //control_bord.
        }
    }

    Rectangle{
        id: url_input
        color: '#fdf5f4'
        width: parent.width * .73
        height: parent.height * .27
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 80

        TextInput{
            id: base_url_txt
            width: parent.width * .7
            anchors.fill: parent
            color: 'black'
            text:control_bord.getConfigValue("base_url","")
        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                popup.visible=true
                popup.disply.kp_txt.text=""
                //mode=5
            }
        }
    }

    Text {
        color: 'white'
        text: qsTr("BASE URL:")
        font.bold: true
        anchors.bottom: url_input.top
        anchors.left: url_input.left
        anchors.bottomMargin: 10
    }

    Text {
        //id: device_txt
        color: 'white'
        text: qsTr("DEVICE ID:")
        font.bold: true
        anchors.top: url_input.bottom
        anchors.left: url_input.left
        anchors.topMargin: 10
    }

    Text {
        id: d_id_txt
        color: 'white'
        text: control_bord.getDeviceID()
        font.bold: true
        anchors.top: url_input.bottom
        anchors.left: url_input.left
        anchors.topMargin: 10
        anchors.leftMargin: 100
    }

    Text {
        id: v_id
        color: 'white'
        text: "0.6"
        font.bold: true
        anchors.top: url_input.bottom
        anchors.right: url_input.right
        anchors.topMargin: 10
    }

    Text {
        id: v_id_txt
        color: 'white'
        text: "Version:"
        font.bold: true
        anchors.top: url_input.bottom
        anchors.right: v_id.left
        anchors.topMargin: 10
        anchors.rightMargin: 10
    }

    Button{
        color: '#4ac424'
        width: parent.width * .30
        height: parent.height * .15
        anchors.top: url_input.bottom
        anchors.left: parent.left
        anchors.topMargin: 40
        anchors.leftMargin: 5
        caption.text: ""

        Text {
            color: 'white'
            text: qsTr("SYNC NOW")
            font.bold: true
            anchors.centerIn: parent
        }

        onClicked: {
            control_bord.setConfigValue("base_url",base_url_txt.text)
            isSyncDB=true
        }
    }

    Button{
        color: '#4ac424'
        width: parent.width * .35
        height: parent.height * .15
        anchors.top: url_input.bottom
        anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        caption.text: ""

        Text {
            color: 'white'
            text: qsTr("SOFTWARE UPDATE")
            font.bold: true
            anchors.centerIn: parent
        }

        onClicked: {
            var val=control_bord.autoSysytemUpdate('/home/root/auto_download.sh',v_id.text)
            if(val === 0)
                showToast('Application up to date')
            else if(val === 1)
                showToast('Update downloading failed')
            else
                showToast('Rebooting...')
        }

    }

    Button{
        color: '#fb0d05'
        width: parent.width * .30
        height: parent.height * .15
        anchors.top: url_input.bottom
        anchors.right: parent.right
        anchors.topMargin: 40
        anchors.rightMargin: 5
        caption.text: ""

        Text {
            color: 'white'
            text: qsTr("BACK")
            font.bold: true
            anchors.centerIn: parent
        }

        onClicked: {
            root.state="config"
        }
    }

    PopUp{
        id: popup
        anchors.centerIn: parent
        visible: false
        onVisibleChanged: {
            if(visible){
                key_pad.text_mode=1
                //KeyPadDisplay.kp_txt.text=""
            }
        }

        onClosePopup: {
            visible=false
        }

        onKeyChange: {
            key_values=s
            base_url_txt.text=s
        }
    }
}

