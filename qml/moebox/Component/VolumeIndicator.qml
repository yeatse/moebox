import QtQuick 1.1

Rectangle {
    id: root;

    property real currentVolume;

    opacity: 0;

    anchors.centerIn: parent;

    implicitWidth: 150;
    implicitHeight: 150;

    color: "#F0000000";

    radius: 5;

    function flash(){ flashEffect.restart(); }
    function volumeUp(){ currentVolume = Math.min(currentVolume+0.05, 1.0); flash(); }
    function volumeDown(){ currentVolume = Math.max(currentVolume-0.05, 0.0); flash(); }

    SequentialAnimation {
        id: flashEffect
        PropertyAnimation {
            target: root
            property: "opacity"
            to: 1
            duration: 500;
        }
        PropertyAnimation {
            target: root
            property: "opacity"
            to: 0;
            duration: 500;
        }
    }

    Row {
        anchors.centerIn: parent;
        Image {
            id: img;
            anchors.verticalCenter: parent.verticalCenter;
            source: "../../gfx/volume.svg";
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter;
            text: Math.round(root.currentVolume*100)+"";
            font {
                family: constant.labelFont.family;
                pixelSize: img.height - 10;
            }
            color: constant.colorLight;
        }
    }
}
