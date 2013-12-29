import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "Component"

Item {
    id: root;

    implicitWidth: page.width;
    implicitHeight: page.height;

    ListView {
        id: view;
        anchors.fill: parent;
        model: playlistModel;
        header: headerComp;
        delegate: playItemComp;
    }

    SelectionDialog {
        id: playlistSelector;
        titleText: qsTr("Select playlist");
        selectedIndex: 0;
        model: [
            qsTr("Magic play"),
            qsTr("Favorited album"),
            qsTr("Favorited music"),
            qsTr("Favorited radio")
        ];
        onAccepted: {
            if (selectedIndex == 0){
                internal.playSource = "";
            } else if (selectedIndex == 1){
                internal.playSource = "music";
            } else if (selectedIndex == 2){
                internal.playSource = "song";
            } else if (selectedIndex == 3){
                internal.playSource = "radio";
            }
            internal.currentIndex = 0;
            internal.musicData = {};
            playlistModel.clear();
            internal.getPlaylist(internal.playMusic);
        }
        Binding {
            target: playlistSelector;
            property: "selectedIndex";
            value: 0;
            when: !msettings.isLogin;
        }
    }

    Component {
        id: headerComp;
        Item {
            id: headerItem;

            implicitWidth: view.width;
            implicitHeight: contentCol.height + constant.paddingLarge*2;

            Rectangle {
                id: mask;
                anchors.fill: contentCol;
                color: "white";
                opacity: 0.4;
                visible: mouseArea.pressed;
            }

            Column {
                id: contentCol;
                anchors {
                    left: parent.left; leftMargin: constant.paddingSmall;
                    right: parent.right;
                    top: parent.top; topMargin: constant.paddingLarge;
                }
                spacing: constant.paddingSmall;
                Text {
                    font {
                        family: constant.labelFont.family;
                        pixelSize: constant.titleFont.pixelSize + 6;
                    }
                    color: constant.colorLight;
                    text: qsTr("Playlist");
                }
                Text {
                    font: constant.titleFont;
                    color: constant.colorMid;
                    text: playlistSelector.model[playlistSelector.selectedIndex];
                }
            }
            Rectangle {
                anchors { left: parent.left; right: parent.right; bottom: parent.bottom; }
                height: 1;
                color: constant.colorDisabled;
            }
            MouseArea {
                id: mouseArea;
                enabled: msettings.isLogin;
                anchors.fill: parent;
                onClicked: playlistSelector.open();
            }
        }
    }

    Component {
        id: playItemComp;
        AbstractDelegate {
            id: root;

            enabled: audio.status != Audio.Loading;
            onClicked: {
                if (internal.currentIndex == index){
                    if (audio.playing){
                        if (audio.paused) audio.play();
                        else audio.pause();
                    } else {
                        audio.play();
                    }
                } else {
                    internal.playMusic(index);
                }
            }

            Image {
                id: coverImg;
                anchors {
                    left: root.paddingItem.left; top: root.paddingItem.top;
                    bottom: root.paddingItem.bottom;
                }
                width: height;
                source: model.cover.small;
            }

            Column {
                anchors {
                    left: coverImg.right; leftMargin: constant.paddingMedium;
                    verticalCenter: parent.verticalCenter;
                }
                spacing: constant.paddingSmall;
                Text {
                    font: constant.labelFont;
                    color: constant.colorLight;
                    text: model.title;
                }
                Text {
                    font: constant.subTitleFont;
                    color: constant.colorMid;
                    text: model.wiki_title||model.artist||"";
                }
            }
        }
    }
}
