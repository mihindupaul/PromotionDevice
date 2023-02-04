import QtQuick 1.1

Item {
    id: common_pad
    //anchors.left: parent.left
    width: 80*3
    height: 52*4
    clip:true

    property int cur_key:0
    property int cur_key_idx: 0
    property string key
    property string num
    property bool isShift:false
    property int stringLimit:0

    property int text_mode:0

    property alias common_pad:common_pad

    signal keyConfirmed(string s)
    //color:"red"
    onVisibleChanged: {
        if(visible){
            isShift=false
            stringLimit=0
            if(text_mode == 0)
                key=''
            else{
                key=disply.kp_txt.text
                //console.log(key)
            }
        }

    }

    ListModel{
        id:km
        ListElement { number:"1" ; letters:"abc" ; uperletter:"ABC"; showletter:"abc" ; showuperletter:"ABC"}
        ListElement { number:"2" ; letters:"def" ; uperletter:"DEF"; showletter:"def" ; showuperletter:"DEF"}
        ListElement { number:"3" ; letters:"ghi" ; uperletter:"GHI"; showletter:"ghi" ; showuperletter:"GHI"}
        ListElement { number:"4" ; letters:"jkl" ; uperletter:"JKL"; showletter:"jkl" ; showuperletter:"JKL"}
        ListElement { number:"5" ; letters:"mno" ; uperletter:"MNO"; showletter:"mno" ; showuperletter:"MNO"}
        ListElement { number:"6" ; letters:"pqrs" ; uperletter:"PQRS"; showletter:"pqrs" ; showuperletter:"PQRS"}
        ListElement { number:"7" ; letters:"tuv" ; uperletter:"TUV"; showletter:"tuv" ; showuperletter:"TUV"}
        ListElement { number:"8" ; letters:"wxyz" ; uperletter:"WXYZ"; showletter:"wxyz" ; showuperletter:"WXYZ"}
        ListElement { number:"9" ; letters:"@#$%&*()\-" ; uperletter:"@#$%&*()\-"; showletter:"@ .." ; showuperletter:"@ .."}
        ListElement { number:"." ; letters:"!;:?/-+=_" ; uperletter:"!;:?/-+=_"; showletter:"! .." ; showuperletter:"! .."}
        ListElement { number:"0" ; letters:"^[]{}<>',|" ; uperletter:"^[]{}<>',|"; showletter:"^ .." ; showuperletter:"^ .."}
        ListElement { number:"#" ;letters:""}
    }

    Timer{
        id:delay
        interval: 1000
        repeat: false
        running: false

        onTriggered: {
            // confirm current letter...
            cur_key_idx=0;
            delay.running=false
        }
    }

    Grid{
        id:keys
        columns: 3
        rows:4
        anchors.fill: parent
        spacing:2
        //width: parent.width * .52
        //height: parent.height * .77
        //anchors.bottom: parent.bottom
        //anchors.bottomMargin: 15
        //anchors.left:  parent.left
        //anchors.leftMargin: 10

        Repeater{
            id: pin_repeater
            model:km

            delegate: Rectangle{
                scale: pin_ma.pressed? 0.9:1.0
                id: pin_num
                width:80
                height:52
                color:'#ffffff'
                border.color: '#c7c9ce'

                Image {
                    id: pin_img
                    visible: false
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text{
                    id: pin_txt
                    anchors.centerIn: parent
                    text:number
                    verticalAlignment: Text.AlignHCenter
                    horizontalAlignment: Text.AlignVCenter
                    color: "black"
                    font.pointSize: 18
                    smooth: true

                    onTextChanged: {
                        if (pin_txt.text == '.')
                            pin_num.color='#c7cace'
                        if (pin_txt.text == '#'){
                            pin_txt.text=''
                            pin_num.color='#c7cace'
                            pin_img.visible=true
                            pin_img.source="qrc:/res/ClearTxt.png"
                        }
                    }
                }

                Text{
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: pin_num.bottom
                    font.bold: true
                    font.pointSize: 14
                    text: (text_mode == 0 ?"":(isShift?showuperletter:showletter))
                }

                MouseArea{
                    id: pin_ma
                    anchors.fill: parent

                    onClicked: {
                        control_bord.setIdelBuzzerFreq(3443,100000)
                        root.idle_seconds=5
                        var letter
                        var pin
                        letter=letters

                        //change letter uppercase and lowercase
                        if(isShift)
                            letter=uperletter

                        //handle one click and set number first
                        if(num !== number && number !== '#'){
                            if(text_mode == 1){
                                pin=letter[0]
                                cur_key_idx=1
                            }
                            else
                                pin=number
                            delay.running=false
                        }

                        //handle multiple clicks
                        else if(delay.running && number !== '#' && text_mode !== 0){
                            key = key.slice(0, (key.length - 1))
                            if(text_mode == 0)
                                pin=number
                            if(letter[cur_key_idx]){
                                pin=letter[cur_key_idx]
                                cur_key_idx++
                            }
                            else{
                                if(text_mode == 1)
                                    pin=number
                                cur_key_idx=0
                            }
                            //cur_key_idx++
                            delay.running=false
                        }
                        //set string first
                        else if(number !== '#')
                        {
                            if(text_mode == 0)
                                pin=number
                            else
                                pin=setCahracterFirst(pin,letter)
                        }
                        //delete characters from string : else part will add new character to String
                        if(number == '#')
                            key = key.slice(0, (key.length - 1))
                        else
                            key+=pin
                        num=number

                        manageStringLimits()
                        delay.running=true
                    }

                    onPressAndHold: {
                        if(isShift && number == '0')
                            isShift=false
                        else if(!isShift && number == '0')
                            isShift=true
                        root.idle_seconds=5
                    }

                    function setCahracterFirst(pin,letter){
                        if(letter[cur_key_idx]){
                            pin=letter[cur_key_idx]
                            cur_key_idx++
                        }
                        else{
                            pin=number
                            cur_key_idx=0
                        }
                        return pin
                    }

                    function manageStringLimits(){
                        if(stringLimit == 0){
                            console.log('1')
                            keyConfirmed(key);
                        }
                        else if(key.length < stringLimit){
                            console.log(key)
                            keyConfirmed(key);
                        }
                        else{
                            console.log('3')
                            key = key.slice(0, (key.length - 1))
                            keyConfirmed(key);
                        }
                    }
                }

            }
        }
    }
}

