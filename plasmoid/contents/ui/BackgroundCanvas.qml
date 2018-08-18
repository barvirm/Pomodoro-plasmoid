import QtQuick 2.09


Canvas {
    id: backgroundCanvas
    anchors.fill: parent
    onPaint: {
        var ctx = getContext('2d')

        var gradient = ctx.createLinearGradient(0, height * 3/4,  width, 0)
        gradient.addColorStop(0.0, "#1D1222")
        gradient.addColorStop(1.0, "#181A2B")
        
        // background
        ctx.fillStyle = "black"
        ctx.fillRect(0, 0, width, height)
        
        // gradient shape
        ctx.fillStyle = gradient
        ctx.beginPath()
        ctx.moveTo(0,0)
        ctx.lineTo(width, 0)
        ctx.lineTo(width, height/4)
        ctx.lineTo(0, height * 3/4)
        ctx.closePath()
        ctx.fill()
    }
}
