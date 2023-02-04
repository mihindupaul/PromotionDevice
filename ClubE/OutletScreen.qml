import QtQuick 1.1

BaseScreen{
    // please use boolean
    property bool pinRequired:false

    signal getItems()

    function setPinPage(t1,t2,t3){
        pin_page.pin_page_txt=t1;
        //pin_page.pin_submit_txt=t2;
        //pin_page.pin_cancel_txt=t3;
    }

    Image {
        source: "qrc:/res/CloseBtn.png"
        anchors.right: parent.right
        anchors.rightMargin: 1
        anchors.top: parent.top

        MouseArea{
            anchors.fill: parent
            onClicked: {
                root.state="main"
            }
        }
    }

    Rectangle{
        color: '#ffffff'
        width: parent.width * .8
        height: parent.height * .7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Button{
            color: '#0245df'
            width: parent.width * .4
            height: parent.height * .7
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            caption.color: 'white'
            caption.text: qsTr("REDEEM\nCOUPON")
            caption.font.bold: true
            caption.font.pointSize: 18

            onClicked: {
                if(pinRequired){
                    pin_page_type='enter_pin';
                    setPinPage("ENTER YOUR 4 DIGIT PIN","SUBMIT","CANCEL");
                    idle_seconds=5
                    root.state="pin";
                }else{
                    getItems()
                }
            }
        }

        Button{
            color: '#ef3325'
            width: parent.width * .4
            height: parent.height * .7
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 20
            caption.text: ""
            Column{
                anchors.centerIn: parent

                Text {
                    color: "white"
                    font.bold: true
                    text: qsTr("INSTORE")
                    font.pointSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    color: "white"
                    font.bold: true
                    text: qsTr("PURCHASES")
                    font.pointSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                }

            }

            onClicked: {
                pin_page_type='points';
                setPinPage("ENTER AMOUNT","CONFIRM","CANCEL");
                idle_seconds=5
                root.state="pin";
            }
        }
    }
}
