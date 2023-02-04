import QtQuick 1.1
import "Qml"

BaseScreen{
    id:wifi_page

    //property string ssid_name
    property int count:0
    property  variant data_set: undefined

    signal config()
    signal btClicked()
    signal errorOccured(string t1,string t2)

    function refresh()
    {
        var tmp;
        console.debug("starting refreshing...")
        count = 0

        try{
            if(control_bord.isDevice())
                tmp = (JSON.parse(control_bord.launch("/home/ranjana/test.sh"))).names
            else
                tmp = (JSON.parse(control_bord.launch("/home/root/test.sh"))).names

            if(tmp == '')
                 manageErrors('SORRY','Networks not found!!')

            else{
                console.debug("refersh complete")
                wifi_page.data_set = tmp
                wifi_page.state = ""
            }
        }
        catch(err){
            manageErrors('SORRY',err)
        }
    }

    Timer{
        id:ft
        running: false
        repeat: false
        triggeredOnStart: false
        interval: 100
        onTriggered: refresh();
    }

    Rectangle{
        color: parent.color
        width: parent.width * .6
        height: parent.height * .1
        anchors.top: parent.top
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Text{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            color: 'white'
            text: {
                try{
                    (count+1) + '/' + data_set.length
                }
                catch(err){
                    '0/0'
                }
            }
        }
    }

    Rectangle{
        id: rec
        color: parent.color
        anchors.top: parent.top
        anchors.topMargin: 70
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.centerIn: parent
        width: parent.width
        height: parent.height * .3
        clip: true

        Rectangle{
            id: m_rec
            color: 'white'
            width: parent.width * .6
            height: parent.height * .8
            anchors.centerIn: parent
            scale: ssid_ma.pressed? 0.9:1.0

            Text {
                id: ssid
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                color: 'black'
                anchors.centerIn: parent
                text: {
                    try{
                        data_set[count]
                    }
                    catch(err){
                        ''
                    }
                }

                elide: Text.ElideMiddle
                font.pointSize: 20
            }

            MouseArea{

                id: ssid_ma
                anchors.fill: parent

                onClicked: {
                    if(data_set[count]){
                        control_bord.setIdelBuzzerFreq(3443,100000)
                        root.ssid = data_set[count]
                        wifi_page.state = "connect"
                    }
                    else
                        showToast("SSID CAN NOT BE EMPTY ...")
                }
            }
        }

        Rectangle{
            scale: p_ma.pressed? 0.9:1.0
            color: parent.color
            width:80
            height: parent.height * .8
            anchors.right: m_rec.left
            anchors.rightMargin: 10
            anchors.verticalCenter: m_rec.verticalCenter
            opacity: 0.5
            Image {
                anchors.fill: parent
                source: "qrc:/res/PrevBtn.png"
            }

            MouseArea{
                id: p_ma
                anchors.fill: parent
                onClicked: {
                    control_bord.setIdelBuzzerFreq(3443,100000)
                    if(--count < 0)
                        count = data_set.length -1
                }
            }

        }

        Rectangle{
            scale: n_ma.pressed? 0.9:1.0
            color: parent.color
            width:80
            height: parent.height * .8
            anchors.left: m_rec.right
            anchors.leftMargin: 10
            anchors.verticalCenter: m_rec.verticalCenter
            opacity: 0.5

            Image {
                anchors.fill: parent
                source: "qrc:/res/NextBtn.png"
            }

            MouseArea{
                id: n_ma
                anchors.fill: parent
                onClicked: {
                    control_bord.setIdelBuzzerFreq(3443,100000)
                    if(++count > (data_set.length-1))
                        count=0;
                }
            }


         }
    }

    Text{
        text: '(Click to Connect)'
        font.bold: true
        anchors.top: rec.bottom
        color: 'white'
        anchors.horizontalCenter: rec.horizontalCenter
    }

    Button{
        color: '#47ba31'
        width:150
        height:50
        caption.text: "REFRESH"
        caption.color: 'white'
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 10
        anchors.bottomMargin: 20
        onClicked: {
            wifi_page.state = "refresh"
        }
    }

    Button{
        color: '#ff2600'
        width:150
        height:50
        caption.text: "CANCEL"
        caption.color: 'white'
        anchors.right: parent.right
        anchors.bottom: parent.bottom
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
    }

    WaitScreen{
        id:waiting
        visible: ft.running
    }

    WifiConfiguration{
        id:wifi_config_screen
        onClose: wifi_page.state = ""
    }

    states:[
        State{
            name:"refresh"
            PropertyChanges {
                target: ft
                running:true
            }
        },
        State{
            name:"connect"
            PropertyChanges {target:wifi_config_screen;visible:true}
        }
    ]
}
