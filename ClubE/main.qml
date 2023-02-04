import QtQuick 1.1
//Local_storage
import 'qrc:/js/Storage.js' as Local_storage
import 'qrc:/js/APICaller.js' as API_call
import "Qml"

Rectangle {
    id:root
    width: 480
    height: 272
    color: 'white'

    property  string pin_code
    property string event_id
    property string display_val
    property bool isMaster:false
    property int limit:0
    //temparary
    property  string screen_name:"main"
    property  string card_code
    property  string pin_page_type:''
    property int idle_seconds: 5
    property alias timer:api_timer
    property string ssid
    property string base_url

    Component.onCompleted:{
        //if(control_bord.isDevice()){
            //loading_interface.start_timerx.running=false
            //root.state = "main"
        //}
        //else{
            root.state = "loading"
            loading_interface.start_timerx.running=true
        //}
    }

    function showToast(msg){
        xtoast_text.text = msg
        toast.toast_visible = true
        toast_timer.start()
    }

    function cardPunch(card){
        if(API_call.HB_REQ)
            API_call.HB_REQ.abort()

        if(card === "0001170285"){
            isMaster=true
            root.state="config"
        }
        else{
            root.state = "wait"
            card_code=card
            API_call.authenticateUser()
        }
    }

    // detect RFID event..
    Connections {
       target: myObject

       onCaptureCard: {
           if(root.state=="main" && card_id !== "0000000000"){
               control_bord.setBuzzerFreq(3443,200000)
               console.log(card_id)
               cardPunch(card_id)
           }
       }
       onErrorHandling:
       {
            console.log(msg)
       }
    }

    LoadingInterface{
        id:loading_interface
        buzz_small:false

        onComplete: {
            root.state = (mode == 0 ?"main":"config")
        }

        onVisibleChanged: {
            if(visible){
                //root.state = "main"
            }
        }
    }

    WifiStaticSettings{
        id: wifi_static_screen
        onBtnClicked: {
            root.state = (mode == 1 ?"main":"")
        }
    }

    Configuration{

        id: configuration
        onClose: root.state="main"
    }

    DeviceAuthentication{
        id: p_word
        buzz_small:false
        onErrorOcured: {
            manageErrors(t1,t2)
            screen_name="password"
        }
    }

    SyncDB{
        id: b_url
        visible: false
        onIsSyncDBChanged: {
            if(isSyncDB){
                API_call.syncDB()
                isSyncDB=false
            }
        }
    }

    BaseScreen{
        id: main_screen
        anchors.fill: parent
        visible: false
        Image {
            id: s_card_img
            anchors.verticalCenterOffset: 35
            anchors.centerIn: parent
            source: "qrc:/res/SwipCard.png"

            MouseArea{
                id: image_ma

                enabled: control_bord.isDevice()

                anchors.fill: parent

                onClicked: {
                    //0001170285/0002214621
                    //cardPunch('0001170285') // master card
                    //cardPunch('0001266158')
                    //cardPunch('0002216296')
                    cardPunch('0006492685')
                    //showToast("Use me ranjana!!!")
                }
            }
        }

        Image {
            source: "qrc:/res/SwipePointer.png"
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
        }
    }

    PinPage {
        id:pin_page//password_pin
        anchors.fill: parent
        visible: false
        onSubmit: {
            if(display_val == pin_code && pin_page_type == 'enter_pin'){
                root.state = "wait"
                limit=0
                API_call.loadItemList()
            }
            else if(pin_page_type == 'points'){
                if(points !== '0')
                   API_call.cashPoints()
            }
            else if(pin_page_type == 'password_pin'){
                if(control_bord.getDevicePin() == display_val)
                    root.state="base_url"
            }
            else{
                ++limit
                erorr_view.error_text1.text="INVALID PIN!"
                erorr_view.error_text2.text="PLEASE TRY AGAIN"
                idle_seconds=2
                root.state="error"
                if(limit > 3){
                    limit=0
                    screen_name="main"
                }
                else
                    screen_name="pin"
            }
            display_val = ""
        }
        onCancel: {
            if(event_id === "0")
                root.state="outlet"
            else
                root.state="main"
        }

        onError: {
            manageErrors("SORRY","INVALID INPUT")
            screen_name="pin"
        }
    }

    OutletScreen{
        id: outlet_screen
        onGetItems: {
            root.state = "wait"
            limit=0
            API_call.loadItemList()
        }
    }

    // waiting page is defined locally
    BaseScreen{
        id:wait_page
        visible: false
            Image {
                id:hourglass
                anchors.centerIn: parent
                anchors.top: parent.top
                source: "qrc:/res/lodingScreen.png"
            }
    }

    ItemList{
        id: item_list
        visible: false
        onExtendTimer: {
            idle_seconds=30
        }
    }

    SingleItem{
        id:item_view
        visible: false
        onVisibleChanged: {
            if(visible){
                //item_dec2
                item_dec=item_list.data_set[(item_list.cur_page*4)+item_list.cur_index].promo_name
                item_dec2=item_list.data_set[(item_list.cur_page*4)+item_list.cur_index].promo_description
                item_id=item_list.data_set[(item_list.cur_page*4)+item_list.cur_index].cus_promo_redeems_id
            }
        }
        onIsRedeemChanged: {
            if(isRedeem){
                API_call.redeemItem()
                isRedeem=false
            }
        }
    }

    RedeemSuccessScreen{
        id: success_redeemed
        onVisibleChanged: {
            if(visible){
                coupon_txt=item_list.data_set[(item_list.cur_page*4)+item_list.cur_index].promo_name
                coupon_img=Local_storage.getImage(item_list.data_set[(item_list.cur_page*4)+item_list.cur_index].promotion_id)
            }
        }
    }

    BaseScreen{
        id: coupon_instore
    }

    SuccessMsgScreen{
        id: success_screen
    }

    ErrorScreen{
        id: erorr_view
    }

    function manageErrors(t1,t2){

        //console.debug(t1 + t2)

        erorr_view.error_text1.text=t1
        erorr_view.error_text2.text=t2
        root.state='error'
    }

    //common timer
    Timer{
        id: time_manger
        interval: 1000
        repeat: true
        onTriggered: {
            if(idle_seconds - 1 == 0)
            {
                if(state == "loading")
                    loading_interface.loading_timer.running=false
                time_manger.running=false
                pin_page.pin=""
                idle_seconds=5
                root.state=screen_name
                screen_name="main"
            }
            else{
                idle_seconds-= 1
            }
        }
    }

    //API timer
    Timer{
        id: api_timer
        running: false
        interval: 0
        repeat: false
        onTriggered: {
            console.log("timer ***************")
            API_call.COMMON_REQ.abort();
            switch (API_call.FUNC) {
                case "syncdb":
                    API_call.errorDisplay("NETWORK TIME OUT","Can not get data from API");
                    API_call.FUNC="";
                    break;
                case "auth":
                    API_call.localAuth();
                    API_call.FUNC="";
                    break;
                case "redeem":
                    API_call.localRedeemItems();
                    API_call.FUNC="";
                    break;
                case "cash":
                    API_call.loacaCashPoints();
                    API_call.FUNC="";
                    break;
            }
        }
    }

    //heart beat
    Timer{
        //id: api_timer
        running: (root.state === "main" ?true:false)
        interval: 30000
        repeat: true
        onTriggered: {
            API_call.heartBeat()
        }
    }

    Rectangle{
        id:toast

        property bool toast_visible:false

        width:350
        height:100
        color:"green"
        anchors.centerIn: parent
        z:1001
        opacity:0
        radius: 4
        border.width: 2

        Timer{
            id:toast_timer
            interval:1000
            onTriggered: {
                toast.toast_visible = false
            }
        }

        Text {
            id:xtoast_text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pointSize: 15
            text:""
            wrapMode: Text.WordWrap
            color: "yellow"
        }

        transitions: Transition {
            NumberAnimation {
                from: 1
                target: toast
                property: "opacity"
                duration: 1000;
            }
        }

        states:State{
            name:"visible"
            when:toast.toast_visible
            PropertyChanges {
                target:toast
                opacity: 1
            }
        }
    }

    onStateChanged: {
        time_manger.running=false
        //idle_seconds=5
        if(state !== "wait" && state !== "loading" && state !== "main" && state !== "config" && state !== "password" && state !== "base_url"){
            //console.log('running timer .....')
            time_manger.running=true
        }
        else
            time_manger.running=false
    }

    states:[
        State{
            name:"authenticating"
        },
        State{
            name:"pin"
            PropertyChanges {
                target: pin_page
                visible:true
            }
        },
        State{
            name:"wait"
            PropertyChanges {
                target: wait_page
                visible:true
            }
        },
        State{
            name:"list"
            PropertyChanges {
                target: data_list
                visible:true
            }
        },
        State{
            name:"item_list_set"
            PropertyChanges {
                target: item_list
                visible:true
            }
        },
        State{
            name:"item_screen"
            PropertyChanges {
                target: item_view
                visible:true
            }
        },
        State{
            name:"error"
            PropertyChanges {
                target: erorr_view
                visible:true
            }
        },
        State{
            name:"redeemed"
            PropertyChanges {
                target: success_redeemed
                visible:true
            }
        },
        State{
            name:"coupon"
            PropertyChanges {
                target: success_redeemed
                visible:true
            }
        },
        State{
            name:"base_url"
            PropertyChanges {
                target: b_url
                visible:true
            }
        },
        State{
            name:"password"
            PropertyChanges {
                target: p_word
                visible:true
            }
        },
        State{
            name:"loading"
            PropertyChanges {
                target: loading_interface
                visible:true
            }
        },
        State{
            name:"main"
            PropertyChanges {
                target: main_screen
                visible:true
            }
        },
        State{
            name:"config"
            PropertyChanges {
                target: configuration
                visible:true
            }
        },
        State{
            name:"outlet"
            PropertyChanges {
                target: outlet_screen
                visible:true
            }
        },
        State{
            name:"success"
            PropertyChanges {
                target: success_screen
                visible:true
            }
        },
        State{
            name:"key"
            PropertyChanges {
                target: key_board
                visible:true
            }
        },
        State{
            name:"wifi"
            PropertyChanges {
                target: wifi_screen
                visible:true
            }
        },
        State{
            name:"wifi_config"
            PropertyChanges {
                target: wifi_config_screen
                visible:true
            }
        },
        State{
            name:"wifi_static"
            PropertyChanges {
                target: wifi_static_screen
                visible:true
            }
        }
    ]

}
