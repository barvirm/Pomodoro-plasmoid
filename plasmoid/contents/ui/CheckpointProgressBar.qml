import QtQuick 2.09

Item {
    id: progressbar

    property int minimum: 0
    property int maximum: 100
    property int value: 50
    property color color: "#77B753"
    property int numOfCheckpoints: 2

    width: parent.width; height: 23
    //clip: true


    Rectangle { 
        width: (progressbar.width * (value - minimum)) / (maximum - minimum)
        height: 4
        radius: 23
        anchors.verticalCenter: parent.verticalCenter
        color: "red"
    }

    Circle {
        id: circleFirst
        diameter: parent.height
        anchors.left: parent.left
        anchors.leftMargin: -diameter/2 
    }
    Circle {
        id: circleLast
        diameter: parent.height
        anchors.right: parent.right
        anchors.rightMargin: -diameter/2 
    }

    Component.onCompleted: {
        var comp = Qt.createComponent("Circle.qml");
        // Start from "checkpoint" and end in "checkpoint => magic 2"
        var checkpoints = progressbar.numOfCheckpoints;
        var offset = progressbar.width / (checkpoints+1);
        for (var it = 1; it < (checkpoints+1) ; it++) {
            var ids = "circle" + it;
            var circle = comp.createObject(parent, {
                "id": ids,
                "diameter": height,
                "anchors.left": anchors.left,
                "anchors.leftMargin": 5 + offset*it,
            });
        }

        if ( circle == null ) {
            console.log("Error with creation of object Circle")
        }
    }

    onValueChanged: {

    }



    /*
    Rectangle { 
        anchors.left: parent.left
        width: 23
        height: 23
        radius: 23
        color: "blue"
    }

    Rectangle { 
        anchors.right: parent.right
        width: 23
        height: 23
        radius: 23
        color: "blue"
    }
    */
}
