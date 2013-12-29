import QtQuick 1.1

Rectangle {
    id: root;

    z: -10;
    anchors.fill: parent;
    color: msettings.bgColor;

    // Background image
    Image {
        anchors.fill: parent;
        fillMode: Image.PreserveAspectCrop;
        sourceSize.height: 1000;
        asynchronous: true;
        source: msettings.bgImageUrl;
    }

    // Background mask
    Rectangle {
        anchors.fill: parent;
        color: "black";
        opacity: msettings.bgMaskOpacity;
    }

    function reorder(){
        var i = 0, bg = null;
        while (bg = app.children[i++]){
            if (bg.hasOwnProperty("color")){
                // Place default background to bottom.
                bg.z = -20;
                return;
            }
        }
    }

    Component.onCompleted: reorder();
}
