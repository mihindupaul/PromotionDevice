import QtQuick 1.1
import "Qml"

BaseScreen {
    id: pin_rect

    property string pin:""
    property string points:""
    //property bool isSubmit:false
    property alias  idle: idle_number.text
    property alias pin_page_txt:pin_page_txt.text
    //tem var
    property string msg:""

    signal submit()
    signal cancel()
    signal error()

    onVisibleChanged: {
        if(visible){
            keys.cur_key_idx=0
            keys.key=''
            keys.key=''
            display_val=''
            pin=''

            submit_btn.enabled=true

            if(pin_page_type=='enter_pin')
                keys.stringLimit=5
            if(pin_page_type=='points')
                keys.stringLimit=9
        }
    }

    KeyPad{
        id:keys
        anchors.top:parent.top
        anchors.left: parent.left
        anchors.topMargin: 50
        anchors.leftMargin: 10

        onKeyConfirmed:{
            var key=s
            var tmp=''
            if(pin_page_type=='enter_pin' && key.length < 5){
                pin=key
                display_val=key
            }
            else if(pin_page_type=='points' && key.length < 9){
                if(key.length < 6 && (key.split(".").length - 1) == 1){
                    key=key.slice(0, (key.length - 1))
                    key=pad(key, 5)
                    keys.key=key
                }

                else if(key.length == 6){
                    tmp=key[key.length-1]
                    key=key.slice(0, (key.length - 1))
                    if(key[key.length-1] !== '.')
                        key=key+'.'
                    else
                        key=key+'.'+tmp
                    keys.key=key
                }

                else if(key[key.length-1] === '.' && key.length > 6){
                    key=key.slice(0, (key.length - 1))
                    keys.key=key
                }
                pin=key
                display_val=key
            }
        }

        function pad(n, width, z) {
          z = z || '0';
          n = n + '';
          return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
        }
    }

    Rectangle{
        color: parent.color
        width: parent.width * .45
        height: parent.height * .77
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15

        Rectangle{
            id: c1
            color: parent.color
            width: parent.width
            height: parent.height * .1
            anchors.top: parent.top

            Text {
                id: pin_page_txt
                color: '#ffffff'
                font.pointSize: 13
                font.bold: true
                anchors.top: parent.top
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                text: "ENTER YOUR 4 DIGIT PIN"
            }
        }

        Rectangle{
            color: parent.color
            width: parent.width
            height: parent.height * .3
            anchors.top: c1.bottom

            Rectangle{
                color: '#f5ebec'
                opacity: 0.7
                width: parent.width * .95
                height: parent.height * .8
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Row{
                    spacing: 10
                    anchors.centerIn: parent

                    Repeater{
                        model: {
                            if(pin_page_type=='enter_pin')
                                4
                            else
                                8
                        }

                        delegate: TextInput {
                            color: 'black'
                            font.bold: true
                            font.pointSize: 20
                            text: {
                                '*'
                                setInputs()
                            }

                            function setInputs(){
                                if(pin_page_type=='enter_pin'){
                                    if(!pin[index])
                                        return '.'
                                    else
                                       return pin[index]
                                }
                                else{
                                    if(!pin[index]){
                                        if (index == 5)
                                            return '.'
                                        return '-'
                                    }
                                    else
                                       return pin[index]
                                }
                            }

                        }
                    }
                }
            }
        }

        Rectangle{
            color: parent.color
            width: parent.width
            height: parent.height * .6
            anchors.bottom: parent.bottom

            Button{
                id: pin_cancel
                color: '#ff2600'
                width: parent.width * .8
                height: parent.height * .4
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                caption.color: 'white'
                caption.text: 'CANCEL'

                onClicked: {
                    cancel()
                }
            }

            Button{
                id: submit_btn
                color: '#47ba31'
                width: parent.width * .8
                height: parent.height * .4
                anchors.bottom: pin_cancel.top
                anchors.bottomMargin: 10
                anchors.horizontalCenter: parent.horizontalCenter
                caption.color: 'white'
                caption.text: 'SUBMIT'

                onClicked: {
                    root.idle_seconds=2
                    enabled=false
                    points='0'
                    var isCash=true;
                    if(pin_page_type == 'points'){
                        if(parseFloat(display_val).toFixed(2) !== 'NaN' && parseFloat(display_val).toFixed(2) > 0){
                            points=parseFloat(display_val).toFixed(2)
                        }
                        else{
                            isCash=false
                        }
                    }

                    if(isCash)
                        submit()
                    else
                        error()
                }
            }
        }

        Text {
            id: idle_number
            visible: false
            x: 20
            y: 80
            font.pointSize: 50
            anchors.right: parent.right
            horizontalAlignment:Text.AlignHCenter
            color: "white"
            text: qsTr("10")
        }
    }
}

