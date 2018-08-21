import QtQuick 2.09
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore


Rectangle {
    id: page
    width: 344
    height: 488

    property real workTime: plasmoid.configuration.workTime
    property real breakTime: plasmoid.configuration.breakTime
    property real timeOffset:plasmoid.configuration.workTime 
    property real timeMax: plasmoid.configuration.workTime

    PlasmaCore.DataSource { id: notificationSource; engine: "notifications"; connectedSources: "org.freedesktop.Notifications" }

    states: [
        State { 
            name: "checkpoint"; 
            PropertyChanges { target: page; timeMax: breakTime; timeOffset: breakTime; } 
            PropertyChanges { target: lineProgressBar; active: false; }
        },
        State { 
            name: "normal";
            PropertyChanges { target: page; timeMax: workTime; timeOffset: workTime; }
            PropertyChanges { target: lineProgressBar; active: true; }
        },
        State {
            name: "finish";
            PropertyChanges { target: button2; state: 'finish'; }
        }
    ]
    state: 'normal'
    onStateChanged: { console.log("page change state: " + page.state); }

    BackgroundCanvas {}

    CheckpointProgressBar {
        id: lineProgressBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top 
        anchors.topMargin: 20
        anchors.leftMargin: 30
        anchors.rightMargin: 30
        active: true
        onComplete: { 
            page.state = 'finish';
            console.log("lineProgressBar complete!"); 
        }
    }


    Timer {
        id: timer
        interval: 50
        running: false 
        repeat: true 
        onTriggered: timeChanged()
    }

    ProgressBarCircle {
        id: circleProgressBar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -40
        arcWidth: 2
        arcColor: "#701919"
        textSize: 60
        currentValue: 0.00
        text: "25:00"
        onComplete: { 
            if ( page.state != 'finish' ) {
                page.state == 'checkpoint' ? page.state = 'normal' : page.state = 'checkpoint';
                button2.state = 'stoped'; 
            }
            timerStop(); 
        }
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
            source: "pauseButton.png"
            mipmap: true 
            Text {
                id: text
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.family: "Helvetica"
                font.pointSize: 20
                color: "white"
                //text: "Start"
            }

        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            onClicked: {
                switch ( button2.state ) {
                    case 'stoped':
                        button2.state = 'running';
                        timerStart();
                        break;
                    case 'running':
                        button2.state = 'stoped';
                        timerStop();
                        break;
                    case 'finish':
                        lineProgressBar.reset();
                        lineProgressBar.debug();
                        page.state = 'normal';
                        button2.state = 'stoped';
                        break;
                }
            }
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
        
        states: [ 
            State { name: "running"; PropertyChanges { target: text; text: "Reset" } },
            State { name: "finish";  PropertyChanges { target: text; text: "Finish" } },
            State { name: "stoped" ; PropertyChanges { target: text; text: "Start" } }
        ]
        state: "stoped"
        onStateChanged: { 
            console.log("Button2 change state: " + state); 
        }
    }
    

    function timerStart() { timer.running = true; }
    function timerStop() { timer.running = false; }
        
    function timeChanged() {
        var date = new Date(timeOffset);
        var minutes = date.getMinutes() < 10 ? "0" + date.getMinutes() : date.getMinutes();
        var seconds = date.getSeconds() < 10 ? "0" + date.getSeconds() : date.getSeconds();
        var clock = minutes + ":" + seconds;
        var percent = 1 - timeOffset/timeMax;

        lineProgressBar.value = percent;
        circleProgressBar.text = clock;
        circleProgressBar.currentValue = percent;

        timeOffset -= 50;
    }

    function createNotification(title, text, icon) {
        var service = notificationSource.serviceForSource("notification");
        var operation = service.operationDescription("createNotification");

        operation.appName = page.appName;
        operation["appIcon"] = plasmoid.icon;
        operation.summary = title;
        operation["body"] = text;
        // TODO: is this useful?
        operation["timeout"] = 100;

        service.startOperationCall(operation);
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
