import QtQuick 1.1
import "../"

BaseScreen {
        signal btnClicked(int mode)

        ListModel{
            id: text_name
            ListElement {name:"IP ADDRESS";}
            ListElement {name:"GATEWAY";}
            ListElement {name:"PREFIX LENGTH";}
            ListElement {name:"DNS";}
        }

        Rectangle{
            color: parent.color
            anchors.top: parent.top
            anchors.topMargin: 40
            width: parent.width * .9
            height: parent.height * .8
            anchors.horizontalCenter: parent.horizontalCenter

            Grid{
                rows:4
                anchors.fill: parent
                spacing: 10

                Repeater{
                    id: rep
                    model: text_name
                    delegate: Rectangle{
                        //id: rec_r
                        color: '#d13530'
                        width: parent.width
                        height: parent.height * .15

                        Rectangle{
                            id:rec1_r
                            color: parent.color
                            width: parent.width * .29
                            height: parent.height

                            Text {
                                id: pw_txt_r
                                text: name
                                font.bold: true
                                color: 'white'
                                anchors.left: parent.left
                            }
                        }

                        Rectangle{
                            id: input_rec_r
                            width: parent.width * .71
                            height: parent.height
                            anchors.left: rec1_r.right
                            color: '#f5ebec'

                            opacity: 0.5

                            TextInput{
                                width: parent.width * .9
                                anchors.left: parent.left
                                anchors.leftMargin: 10
                                anchors.verticalCenter: parent.verticalCenter
                                color: 'black'

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
//                                        popup.visible=true
//                                        popup.disply.kp_txt.text=parent.text
//                                        //key_values=parent.text
//                                        console.log(index)
//                                        mode=index
                                    }
                                }
                            }
                        }
                     }
                }
            }
        }

        //end
        Button{
            color: '#47ba31'
            width:150
            height:50
            caption.text: "CONNECT"
            caption.color: 'white'
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: 10
            anchors.bottomMargin: 10

            onClicked: {

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
            anchors.bottomMargin: 10

            onClicked: {
                btnClicked(1)
            }
        }
}

