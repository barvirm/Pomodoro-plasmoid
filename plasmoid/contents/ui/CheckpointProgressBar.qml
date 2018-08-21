import QtQuick 2.09

Item {
    id: progressbar

    property real minimum: 0
    property real maximum: 1
    property real value: 0.5
    property color color: "#77B753"
    property int numOfCheckpoints: 2
    property int state: 0
    property bool active: true;

    function reset() {
        for (var i = 0; i < lines.object.length; i++) { lines.object[i].value = 0; }
        for (var i = 1; i < checkpoints.object.length; i++) { checkpoints.object[i].active = false; }
        state = 0;
        value = minimum;
    }

    height: 23
    width: parent.width
    
    function debug() {
        console.log("minimum:          " + progressbar.minimum        );
        console.log("maximum:          " + progressbar.maximum        );
        console.log("value:            " + progressbar.value          );
        console.log("numOfCheckpoints: " + progressbar.numOfCheckpoints);
        console.log("state:            " + progressbar.state          );
        console.log("active:           " + progressbar.active         );
    }

    QtObject { id: lines; property variant object: [] }
    QtObject { id: checkpoints; property variant object: [] }

    onValueChanged: {
        if ( !active ) { return; }

        if (lines.object[state] != null) {
            lines.object[state].value = value; 
            checkpoints.object[state+1].active = value == maximum;
        }
    }



    signal complete();

    onWidthChanged: { updateCheckpointsPosition(); }
    Component.onCompleted: { createProgressLines(); createCheckpoints(); }
    
    // END only function
    
    function createProgressLines() {
        var sectors = progressbar.numOfCheckpoints+1;
        var comp = Qt.createComponent("SliderWithoutHandle.qml");
        //comp.onCompleted.connect(report);
        var checkpointWidth = progressbar.height;
        // width - checkpoint -> fit to size 
        // placing form left so -> last == anchors.right
        // end point must be on start next checkpoint -> Checkpoint shorter
        var sliderSize = ( progressbar.width - checkpointWidth) / sectors - checkpointWidth;

        for ( var i = 0; i < sectors; i++) {
            var leftMargin = checkpointWidth + ((progressbar.width - checkpointWidth)/sectors)*i;
            var line = comp.createObject(parent, {
                "anchors.verticalCenter": progressbar.verticalCenter,
                "anchors.left": progressbar.left,
                "anchors.leftMargin": leftMargin,
                "size":sliderSize,
                "value": 0.0,
            });
            lines.object[i] = line;
        }

        if ( line == null ) {
            console.log("Error with creation of object LineSector")
        }

    }

    function stageComplete() {
        state == numOfCheckpoints ? complete() : state++;
    }

    function createCheckpoints() {
        var comp = Qt.createComponent("Checkpoint.qml");
        var numOfCheckpoints = progressbar.numOfCheckpoints+1;
        var w = progressbar.width - progressbar.height;
        for (var i = 0; i < (numOfCheckpoints+1); i++) {
            var leftMargin = w/(numOfCheckpoints) * i;
            var checkpoint = comp.createObject(parent, {
                "dn": "cp_"+i,
                "width": progressbar.height,
                "height": progressbar.height,
                "anchors.left": progressbar.left,
                "anchors.leftMargin": leftMargin,
                "anchors.verticalCenter": progressbar.verticalCenter,
                "activeSource": "oval_top@2x.png",
                "deactiveSource": "oval_top_inactive@2x.png",
                "active": i ? false : true,
            });
            checkpoint.onActiveChanged.connect(stageComplete);
            checkpoints.object[i] = checkpoint;

        }

        if ( checkpoint == null ) {
            console.log("Error with creation of object Circle")
        }
    }


    function updateCheckpointsPosition() {
        var w = progressbar.width - progressbar.height;
        var numOfCheckpoints = progressbar.numOfCheckpoints+1;
        for(var i = 0; i < checkpoints.object.length; i++) {
            var leftMargin = w/(numOfCheckpoints) * (i);
            progressbar.ids[i].anchors.leftMargin = leftMargin;
        }
    }

}
