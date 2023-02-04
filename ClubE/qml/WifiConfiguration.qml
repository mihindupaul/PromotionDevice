import QtQuick 1.1
import "../"

BaseScreen {
    id: wifi_conf
    property string key_values
    property int mode:5

    signal popUpKeypad()
    signal btnClicked(int mode)
    onVisibleChanged: {
        if(visible){
            key_values=""
            popup.disply.kp_txt.text=""
        }
    }

    //signal getText(string s)

    Rectangle{
       id: rec
       color: parent.color
       width: parent.width
       height: parent.height * .2
       anchors.top: parent.top
       anchors.topMargin: 80
       anchors.horizontalCenter: parent.horizontalCenter

       Rectangle{
           id:rec1
           color: parent.color
           width: parent.width * .3
           height: parent.height

           Text {
               id: pw_txt
               text: qsTr("WIFI Password")
               font.bold: true
               color: 'white'
               anchors.centerIn: parent
           }
       }

       Rectangle{
           id: input_rec
           width: parent.width * .68
           height: parent.height
           anchors.left: rec1.right
           color: '#f5ebec'

           TextInput{
               id: wifi_pw
               width: parent.width * .9
               anchors.left: parent.left
               anchors.leftMargin: 10
               anchors.verticalCenter: parent.verticalCenter
               color: 'black'
               text: {
                   if(mode == 5)
                       key_values
                   else
                       ""
               }
           }

           MouseArea{
               anchors.fill: parent
               onClicked: {
                   popup.visible=true
                   popup.disply.kp_txt.text=parent.text
                   mode=5
               }
           }
       }
    }

    Button{
        color: '#47ba31'
        width:150
        height:50
        caption.text: 'CONNECT'
        caption.font.pointSize: 10
        caption.color: 'white'
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottomMargin: 20
        onClicked: {
            if(key_values.length >= 8){
                control_bord.wifiConfig("/home/root/setwifi.sh",root.ssid,key_values)
                close();
            }else{
                showToast("Miniaml Passord Must be 8 characters.")
            }
        }
    }

    Button{
        color: '#47ba31'
        width:150
        height:50
        caption.text: "ADVANCE"
        caption.color: 'white'
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        enabled: false

        onClicked: {
            btnClicked(0)
        }
    }

    Button{
        color: '#ff2600'
        width:150
        height:50
        caption.text: 'CANCEL'
        caption.font.pointSize: 10
        caption.color: 'white'
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 20
        onClicked: {
            close()
        }
    }

    PopUp{
        id: popup
        anchors.centerIn: parent
        visible: false
        onVisibleChanged: {
            if(visible){
                key_pad.text_mode=1
                //console.log(key_pad.text_mode)
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

