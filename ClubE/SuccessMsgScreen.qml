import QtQuick 1.1

BaseScreen{
    property alias amount_txt:amount_txt.text

    Rectangle{
        color: '#ffffff'
        width: parent.width * .75
        height: parent.height * .7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter

        Column{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 20
            anchors.leftMargin: 20

            Text {
                color: "#d3c8c8"
                font.bold: true
                text: qsTr("INSTORE PURCHASE")
                font.pointSize: 15
            }

            Text {
                id: amount_txt
                color: "#d3c8c8"
                font.bold: true
                text: qsTr("RS. 1,2000.00")
                font.pointSize: 15
            }

        }

        Text {
            color: '#05bb1f'
            text: qsTr("SUCCESSFULLY COMPLETED")
            font.pointSize: 18
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 25
        }
    }
}

