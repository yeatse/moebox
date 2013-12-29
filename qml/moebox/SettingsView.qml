import QtQuick 1.1
import com.nokia.symbian 1.1
import Qt.labs.components 1.1
import "Component"
import "../js/main.js" as Script

Item {
    id: root;

    implicitWidth: page.width;
    implicitHeight: page.height;

    Flickable {
        id: view;
        anchors.fill: parent;
        contentWidth: parent.width;
        contentHeight: contentCol.height;
        Column {
            id: contentCol;
            anchors { left: parent.left; right: parent.right; }
            spacing: constant.paddingMedium;
            SectionHeader {
                title: qsTr("Current user");
            }
            Loader {
                id: userLoader;
                anchors { left: parent.left; right: parent.right; }
                sourceComponent: msettings.isLogin ? userComp : loginComp;

                Component {
                    id: userComp;
                    Item {
                        id: root;

                        width: userLoader.width;
                        height: 120;

                        Image {
                            id: portraitImg;
                            width: 120;
                            height: 120;
                            source: msettings.userDetail.user_avatar.medium;
                        }
                        Text {
                            anchors {
                                left: portraitImg.right; leftMargin: constant.paddingMedium;
                                right: parent.right; bottom: portraitImg.verticalCenter;
                            }
                            text: msettings.userDetail.user_name;
                            font: constant.titleFont;
                            color: constant.colorLight;
                        }
                        Button {
                            anchors {
                                right: parent.right; top: parent.verticalCenter;
                                margins: constant.paddingMedium;
                            }
                            width: 150;
                            text: qsTr("Logout");
                            onClicked: {
                                msettings.token = "";
                                Script.initialize();
                            }
                        }
                    }
                }

                Component {
                    id: loginComp;
                    Item {
                        width: userLoader.width;
                        height: childrenRect.height;
                        Button {
                            anchors {
                                left: parent.left; right: parent.right;
                                margins: constant.graphicSizeMedium;
                            }
                            text: qsTr("Login");
                            onClicked: pageStack.push(Qt.resolvedUrl("LoginPage.qml"));
                        }
                    }
                }
            }
            Item { width: 1; height: constant.paddingMedium; }
            SectionHeader {
                title: qsTr("Background");
            }
            Column {
                anchors { left: parent.left; leftMargin: constant.paddingMedium; }
                CheckableGroup { id: bgGroup; }
                RadioButton {
                    platformExclusiveGroup: bgGroup;
                    text: qsTr("Pure color");
                    checked: msettings.bgImageUrl.toString() == "";
                    onClicked: {
                        msettings.bgImageUrl = "";
                        msettings.bgColor = utility.selectColor(msettings.bgColor);
                    }
                }
                RadioButton {
                    platformExclusiveGroup: bgGroup;
                    checked: msettings.bgImageUrl.toString() != "";
                    text: qsTr("Image");
                    onClicked: {
                        var url = utility.selectImage(msettings.bgImageUrl);
                        if (url.toString() == "") checked = false;
                        else msettings.bgImageUrl = url;
                    }
                }
            }
            Item { width: 1; height: constant.paddingMedium; }
            SectionHeader {
                title: qsTr("Mask opacity");
            }
            Slider {
                anchors { left: parent.left; right: parent.right; margins: constant.graphicSizeMedium; }
                value: msettings.bgMaskOpacity;
                onValueChanged: if (pressed) msettings.bgMaskOpacity = value;
            }
            SectionHeader {
                title: qsTr("Author");
            }
            Text {
                anchors { left: parent.left; right: parent.right; }
                height: constant.graphicSizeLarge;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                text: qsTr("Yeatse")
                font: constant.titleFont;
                color: constant.colorLight;
            }
            Item { width: 1; height: constant.paddingMedium; }
            Button {
                anchors {
                    left: parent.left; right: parent.right;
                    margins: constant.graphicSizeMedium;
                }
                text: qsTr("Exit");
                onClicked: Qt.quit();
            }
            Item { width: 1; height: constant.paddingMedium; }
        }
    }
}
