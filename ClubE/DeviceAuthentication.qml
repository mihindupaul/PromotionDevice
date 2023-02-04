import QtQuick 1.1
import "Qml"

BaseScreen{
    signal popUpKeypad()
    signal errorOcured(string t1,string t2)
    property string key_values
    //property string pw

    onVisibleChanged: {
        if(visible){
            popup.visible=false
            key_values=""
            popup.disply.kp_txt.text=""
        }
    }

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
                root.state="config"
            }
        }
    }

    Image {
        id: p_img1
        source: "qrc:/res/BuzzLogoDdeviceAuth.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 35
    }

    Image {
        id: p_img2
        source: "qrc:/res/DownArrow.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 95
    }

    Text {
        id: p_lable
        color: 'white'
        font.bold: true
        text: qsTr("ENTER PASSWORD")
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 155
    }

    Rectangle{
        color: 'white'
        opacity: 0.7
        width: parent.width * .52
        height: parent.height * .18
        anchors.top: p_lable.bottom
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter

        TextInput{
            id: wifi_pw
            width: parent.width * .6
            height: parent.height * .4
            anchors.centerIn: parent
            color: 'black'
            text: key_values

            onTextChanged: {
                //console.log('**********')
                //console.log(popup.key_pad.cur_key_idx)
                if(key_values.length == 6){
                    //console.log(key_values)
                    if(control_bord.getDevicePin() === key_values){
                        root.state="base_url"
                    }
                    else{
                        showToast("Login Failed !! Please Try Again..")
                        //errorOcured("LOGIN ERROR","PLEASE RE-ENTER PASSWORD")
                    }
                }
                else{
                    //code here
                }
            }

        }

        MouseArea{
            anchors.fill: parent
            onClicked: {
                popup.visible=true
                popup.disply.kp_txt.text=""
                key_values=""
            }
        }
    }

    PopUp{
        id: popup
        anchors.centerIn: parent
        visible: false
        onVisibleChanged: {
            if(visible){
                key_pad.text_mode=0
                //disply.kp_txt.text=key_values
            }
        }

        onClosePopup: {
            visible=false
        }

        onKeyChange: {
            key_values=s
        }
    }
}

