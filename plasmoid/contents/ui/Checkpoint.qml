import QtQuick 2.09

Image {
    property bool active: false
    property string activeSource: ""
    property string deactiveSource: ""
    property string dn: " ";
    width: parent.height; height: parent.height 
    fillMode: Image.PreserveAspectFit
    mipmap: true

    Component.onCompleted: { activeUpdate(); }
    onActiveChanged: { activeUpdate(); console.log(dn + ": " + active);}

    function activeUpdate() {
        source = active ? activeSource : deactiveSource;
    }



}   
