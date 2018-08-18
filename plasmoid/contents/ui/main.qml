import QtQuick 2.09
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore


Rectangle {
    id: page
    width: 350
    height: 480
    property real tmpvalue: 50

    BackgroundCanvas {}

    CheckpointProgressBar {
        value: parent.tmpvalue
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin:  20
        anchors.rightMargin: 20
    }

    Slider {
        height: 300
        orientation: Qt.Vertical
        value: 0.5
        onValueChanged: {
            parent.tmpvalue = value * 100;
            console.log(value*100);
        }
    }


    ProgressBarCircle {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -40
        arcWidth: 2
        arcColor: "#701919"
        textSize: 60
        text: "12:00"
    }



    Item {
        id:button2
        anchors.bottom: page.bottom 
        anchors.bottomMargin: page.height/8
        anchors.horizontalCenter: page.horizontalCenter
        width: 165; height: 45

        Image {
            id: buttonImage
            anchors.fill: parent
            source: "button2.png"
            mipmap: true 

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter

                font.family: "Helvetica"
                font.pointSize: 20
                color: "white"

                text: "Pause"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: console.log("Hell wo")
        }

        DropShadow {
            anchors.fill: parent
            horizontalOffset: -5
            verticalOffset: 5
            radius: 20.0
            samples: 32
            color: "#80970E0E"
            source: buttonImage
        }
    }



     Grid {
        id: colorPicker
        x: 4; anchors.bottom: page.bottom
        anchors.bottomMargin: 4
        rows: 2
        columns: 3
        spacing: 3


        Cell { cellColor: "red"     ; onClicked: console.log("debug: " + page.width + " " + page.height) } 

        Cell { cellColor: "white"   ; onClicked: console.log("debug: " + page.width + " " + page.height) } 
        Cell { cellColor: "black"   ; onClicked: console.log("debug: " + page.width + " ") } 
    }

}