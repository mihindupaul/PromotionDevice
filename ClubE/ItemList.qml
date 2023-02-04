import QtQuick 1.1
import 'qrc:/js/Storage.js' as Local_storage

    BaseScreen{
        property  variant data_set: undefined
        property alias list_view_loader:list_loader
        property alias grid_com:grid_com
        property  int cur_page:0
        property  int cur_index:0
        property int page_count:0
        property alias page_num:page_num_txt.text

        signal extendTimer()

            Image {
                scale: ic_ma.pressed? 0.9:1.0
                source: "qrc:/res/CloseBtn.png"
                anchors.right: parent.right
                anchors.rightMargin: 1
                anchors.top: parent.top

                MouseArea{
                    id: ic_ma
                    anchors.fill: parent
                    onClicked: {
                        control_bord.setIdelBuzzerFreq(3443,100000)
                        root.state="main"
                    }
                }
            }

            Loader{
                id:list_loader
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top:header.bottom
                anchors.bottomMargin: 10
            }

        Rectangle{
            id: header
            color: '#d23630'
            //color:"green"
            width: parent.width
            height:parent.height * .08
            y: parent.height * .1

            Rectangle{
                id: page_num
                color: '#d23630'
                width: parent.width * .1
                height:parent.height
                anchors.horizontalCenter: header.horizontalCenter

                Text{
                    id: page_num_txt
                    color: 'white'
                    anchors.horizontalCenter: page_num.horizontalCenter
                    anchors.verticalCenter: page_num.verticalCenter
                }
            }

            Button{
                id: back_rec
                color: '#d23630'
                //color: 'white'
                width: parent.width * .30
                height:parent.height
                anchors.right: page_num.left
                anchors.rightMargin: 40
                caption.text: "BACK"
                caption.color: 'white'

                onClicked: {
                    extendTimer()
                    if((cur_page - 1) >= 0){
                        cur_page -= 1
                        page_num_txt.text=(cur_page + 1) + "/" + page_count
                    }
                }
            }


            Button{
                id: next_btn
                color: '#d23630'
                //color: 'white'
                width: parent.width * .30
                height:parent.height
                anchors.left: page_num.right
                anchors.leftMargin: 40
                caption.text: "NEXT"
                caption.color: 'white'

                onClicked: {
                    extendTimer()
                    if ((cur_page + 1) < page_count){
                        cur_page += 1
                        page_num_txt.text=(cur_page + 1) + "/" + page_count
                    }
                }
            }
        }

        Component{
            id:grid_com
        Grid{
            id: grid_view
            anchors.fill: parent
            columns: 2
            rows:2

            Repeater{
                id:myrepeater
                model:4

                delegate: Rectangle{
                    id: rec1
                    color: '#cdcdcd'
                    width: root.width * .5
                    height:root.height * .41
                    border.width: 3
                    border.color: '#d23630'

                    Rectangle{
                        color: 'transparent'
                        width: parent.width * .3
                        height:parent.height * .65
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 5

                        Image {
                            id: item_img
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            onStatusChanged: {
                                if (item_img.status == 3) {
                                    item_img.source= "qrc:/res/nodataavailable.png"
                                }
                            }
                        }
                    }

                    Rectangle{
                        id: rec1_view
                        color: '#cdcdcd'
                        //color: 'white'
                        width: parent.width * .6
                        height:parent.height * .65
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.right: parent.right
                        anchors.rightMargin: 5
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            id: rec1_txt
                            width: parent.width
                            font.bold: true
                            font.pointSize: 12
                            //elide: Text.ElideRight
                            text:{
                                try{
                                    data_set[(cur_page*4)+index].promo_name
                                }
                                catch(err)
                                {
                                    'data\nnot\navailable'
                                }
                            }
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                            //data_set[(cur_page*4)+index].promo_description
                            onTextChanged: {
                                if(rec1_txt.text=='data\nnot\navailable'){
                                    rec1.visible=false
                                }
                                else{
                                    rec1.visible=true
                                    item_img.source=Local_storage.getImage(data_set[(cur_page*4)+index].promotion_id)
                                }
                            }
                        }

                        Text {
                            width: parent.width
                            color: 'red'
                            font.bold: true
                            font.pointSize: 10
                            anchors.top: rec1_txt.bottom
                            text:{
                                try{
                                    data_set[(cur_page*4)+index].promo_description
                                }
                                catch(err)
                                {
                                    ''
                                }
                            }
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            elide: Text.ElideRight
                        }

                    }

                    Button{
                        id: rec1_view_txt
                        color: '#32b21d'
                        radius:1
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        anchors.rightMargin: 5
                        anchors.bottomMargin: 5
                        anchors.right: parent.right
                        height:parent.height * .22
                        caption.text: qsTr("VIEW")
                        caption.font.bold: true
                        caption.font.pointSize: 13
                        caption.color: '#ffffff'

                        onClicked: {
                            //extendTimer()
                            if(rec1_txt.text !== 'data\nnot\navailable'){
                                cur_index=index
                                idle_seconds=5
                                root.state="item_screen"
                            //data_set[(cur_page*4)+index].promo_description
                            }
                        }
                    }
                }
            }
        }
        }
}
