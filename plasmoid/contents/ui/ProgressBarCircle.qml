import QtQuick 2.09

Canvas {
    id: canvas
    width: 240
    height: 240
    antialiasing: true
    smooth: true

    
    property color arcColor: "lightblue"
    property int arcWidth: 2

    property real centerWidth: width / 2
    property real centerHeight: height / 2
    property real radius: (Math.min(canvas.width, canvas.height) / 2) - arcWidth 

    property real minimumValue: 0
    property real maximumValue: 1
    property real currentValue: 0.99
    property color textColor: "white"
    property int textSize: 14

    signal complete()

    // this is the angle that splits the circle in two arcs
    // first arc is drawn from 0 radians to angle radians
    // second arc is angle radians to 2*PI radians
    property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

    // we want both circle to start / end at 12 o'clock
    // without this offset we would start / end at 9 o'clock
    property real angleOffset: -Math.PI / 2

    property string text: "Text"

    onArcColorChanged: requestPaint()
    onMinimumValueChanged: requestPaint()
    onMaximumValueChanged: requestPaint()
    onCurrentValueChanged: { if ( currentValue == maximumValue ) complete(); requestPaint();}

    onPaint: {
        var ctx = getContext("2d");
        ctx.clearRect(0, 0, canvas.width, canvas.height);

        ctx.beginPath();
        ctx.lineWidth = canvas.arcWidth;
        ctx.strokeStyle = canvas.arcColor;
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                canvas.angleOffset,
                canvas.angleOffset + canvas.angle);
        ctx.stroke();
    }

    Text {
        anchors.centerIn: parent
        text: canvas.text
        font.pointSize: canvas.textSize
        color: canvas.textColor
    }

}

