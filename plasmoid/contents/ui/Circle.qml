import QtQuick 2.0

Item {
    id: circle
    property int diameter: parent.height
    property color color: "blue"
    width: diameter; height: diameter 

/*
    Image { 
        
        source: "oval_top.png"

    }
    */
    Rectangle {
        anchors.fill: parent 
        width:  circle.diameter 
        height: circle.diameter 
        radius: circle.diameter 
        color:  circle.color
    }
}
