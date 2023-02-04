import QtQuick 1.1

BaseScreen {
    property alias coupon_img:coupon_img.source
    property alias coupon_txt:coupon_txt.text

    Rectangle{
        color: '#ffffff'
        width: parent.width * .75
        height: parent.height * .7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle{
            id: rec_img_redeemed
            color: '#848382'
            width: parent.width * .25
            height: parent.height * .4
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 10

            Image {
                id: coupon_img
                anchors.fill: parent
//                onStatusChanged: {
//                    if (coupon_img.status == 3) {
//                        source= "qrc:/res/nodataavailable.png"
//                    }
//                }

            }
        }

        Rectangle{
            color: '#ffffff'
            height: parent.height * .4
            anchors.top: parent.top
            anchors.left: rec_img_redeemed.right
            anchors.right: parent.right
            anchors.topMargin: 20
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            Text {
                id:coupon_txt
            }
        }

        Text {
            text: qsTr("SUCCESSFULLY REDEEMED")
            font.bold: true
            font.pointSize: 15
            color: '#05bb1f'
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
        }
    }
}

