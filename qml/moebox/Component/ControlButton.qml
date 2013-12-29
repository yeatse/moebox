import QtQuick 1.1

Item {
    id: root;

    property string iconId: "";
    property bool checked: false;

    signal clicked;

    width: 80;
    height: 80;

    QtObject {
        id: internal;
        function getIconSource(){
            if (iconId != ""){
                var state = root.checked ? 2 : mouseArea.pressed ? 0 : 1;
                return Qt.resolvedUrl("../../gfx/btn_"+iconId+"_"+state+".png");
            } else {
                return "";
            }
        }
    }

    Image {
        anchors.fill: parent;
        source: internal.getIconSource();
    }

    MouseArea {
        id: mouseArea;
        anchors.fill: parent;
        onClicked: root.clicked();
    }
}
