import QtQuick 2.09

Rectangle { 
    property real value: 0
    property real maximum: 1.0
    property real minimum: 0.0
    property real size: 20.0
    width: ( size * (value - minimum) ) / (maximum - minimum)
    height: 4
    color: "red"

}
