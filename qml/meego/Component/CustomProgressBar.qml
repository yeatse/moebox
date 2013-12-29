import QtQuick 1.1

Item {
    id: root

    property bool running: true;

    implicitWidth: screen.displayWidth;
    implicitHeight: 6

    Rectangle {
        id: progressRect
        color: "steelblue"
        width: constant.paddingLarge * 3;
        height: 8
    }

    SequentialAnimation {
        id: loadingAnimation
        alwaysRunToEnd: true
        loops: Animation.Infinite
        running: root.running && root.visible && Qt.application.active

        PropertyAction { target: progressRect; property: "visible"; value: true }
        PropertyAction { target: progressRect; property: "x"; value: 0 }
        PropertyAnimation { target: progressRect; property: "x"; to: root.width/2; duration: 800; easing.type: Easing.InOutQuad}
        //PropertyAnimation { target: progressRect; property: "x"; to: (root.width/3)*2; duration: 1000; }
        PropertyAnimation { target: progressRect; property: "x"; to: root.width; duration: 800; easing.type: Easing.InOutQuad}
        PropertyAction { target: progressRect; property: "visible"; value: false }
        //PauseAnimation { duration: 700 }
    }
}
