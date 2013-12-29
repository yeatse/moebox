import QtQuick 1.1
import com.nokia.meego 1.0
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
            ButtonColumn {
                id: btnColumn;
                anchors { left: parent.left; leftMargin: constant.paddingMedium; }
                exclusive: false;
                spacing: constant.paddingSmall;
                RadioButton {
                    id: colorBtn;
                    text: qsTr("Pure color");
                    onClicked: {
                        msettings.bgImageUrl = "";
                        msettings.bgColor = utility.selectColor(msettings.bgColor);
                    }
                }
                RadioButton {
                    id: bgImgBtn;
                    text: qsTr("Image");
                    onClicked: signalCenter.selectImage(bgImgBtn);
                    Connections {
                        target: signalCenter;
                        onImageSelected: {
                            if (caller == bgImgBtn){
                                if (url != "") msettings.bgImageUrl = url;
                                else btnColumn.setCheckedBtn();
                            }
                        }
                    }
                }
                function setCheckedBtn(){
                    colorBtn.checked = msettings.bgImageUrl.toString() == "";
                    bgImgBtn.checked = !colorBtn.checked;
                }
                Component.onCompleted: {
                    setCheckedBtn();
                    msettings.bgImageUrlChanged.connect(setCheckedBtn);
                }
            }
            Item { width: 1; height: constant.paddingMedium; }
            SectionHeader {
                title: qsTr("Mask opacity");
            }
            Slider {
                anchors { left: parent.left; right: parent.right; margins: constant.graphicSizeMedium; }
                value: msettings.bgMaskOpacity;
                valueIndicatorVisible: true;
                onPressedChanged: {
                    if (!pressed) msettings.bgMaskOpacity = value;
                }
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
