import QtQuick 1.1
//import 'qrc:/js/APICaller.js' as API_call

BaseScreen{
    property alias item_dec:item_vew_txt.text
    property alias item_dec2:item_view_txt.text
    property string item_id
    property bool isRedeem:false

    onVisibleChanged: {
        if(visible)
            redeem_btn.enabled=true
    }

    Rectangle{
        color: '#ffffff'
        width: parent.width * .75
        height: parent.height * .7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: item_vew_txt
            font.pointSize: 13
            font.bold: true
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 5
            anchors.leftMargin: 10
            width: parent.width * .9
            elide: Text.ElideRight
        }

        Text {
            id: item_view_txt
            font.bold: true
            width: parent.width * .9
            height: 100
            anchors.top: item_vew_txt.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pointSize: 11
            wrapMode: Text.WordWrap
            maximumLineCount: 4
            elide: Text.ElideRight
            color: 'red'
        }

        Button{
            id: redeem_btn
            color: '#46ba31'
            width: parent.width * .22
            height: parent.height * .3
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 10
            anchors.leftMargin: 10
            caption.text: qsTr("REDEEM")
            caption.font.bold: true
            caption.font.pointSize: 13
            caption.color: '#ffffff'

            onClicked: {
                root.idle_seconds=2
                enabled=false
                isRedeem=true
            }
        }

        Button{
            color: '#ff2600'
            width: parent.width * .22
            height: parent.height * .3
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 10
            anchors.rightMargin: 10
            caption.text: qsTr("CANCEL")
            caption.font.bold: true
            caption.font.pointSize: 13
            caption.color: '#ffffff'

            onClicked: {
                root.idle_seconds=30
                root.state="item_list_set"
            }
        }
    }
}

