import QtQuick 1.1

BaseScreen{
    id:root
    //property alias loading_timer:loading_timer
    property int loading_seconds: 1
    property alias loading_dot:loading_repeater.model
    property alias start_timerx:start_timerx

    signal complete(int mode)

    Image {
        id: buzz_large
        source: "qrc:/res/BuzzLogoDdeviceAuth.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 35
    }

    Text {
        id: loading_txt
        color: 'white'
        text: qsTr("LOADING INTERFACE")
        font.bold: true
        anchors.top: buzz_large.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
    }

    Row{
        width:100
        height: 30
        id: loading_grid
        //columns: 4
        //rows: 1
        spacing: 10
        anchors.top: loading_txt.bottom
        //anchors.left: loading_txt.left
        //anchors.leftMargin: 30
        anchors.horizontalCenter: loading_txt.horizontalCenter
        anchors.topMargin: 10

        Repeater{
            id: loading_repeater
            model: loading_seconds
            delegate: Image {
                source: "qrc:/res/LoadingDot.png"
            }
        }


        Timer{

            id:start_timerx
            interval: 2500
            repeat: true
            running:false // loading_seconds < 4

            onTriggered: {
                if(loading_seconds++ == 4){
                    console.debug("complete")
                    stop()
                    complete(0)
                }
            }
        }
    }

    Button{
        color: 'white'
        width: parent.width * .36
        height: parent.height * .16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 25
        anchors.horizontalCenter: parent.horizontalCenter
        caption.text: ""

        Image {
            id: conf_small
            source: "qrc:/res/ConfigWheelSmall.png"
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
        }

        Text {
            text: qsTr("CONFIGURE")
            color: '#d13530'
            font.bold: true
            anchors.left: conf_small.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 5
        }

        onClicked: {
            start_timerx.running = false
            complete(1)
        }
    }
}
