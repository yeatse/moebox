import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "Component"
import "../js/Calculate.js" as Calc
import "../js/main.js" as Script

Item {
    id: root;

    implicitWidth: page.width;
    implicitHeight: page.height;

    clip: true;

    Image {
        id: coverImage;
        anchors { left: parent.left; top: parent.top; right: parent.right; }
        height: width;
        sourceSize.width: parent.width;
        smooth: true;
        source: audio.playing ? internal.musicData.cover.large : "";
        cache: false;

        Image {
            anchors.fill: parent;
            source: "../gfx/cover_large.png";
            visible: coverImage.status != Image.Ready;
            smooth: true;
        }
    }

    ProgressBar {
        id: progressBar;
        anchors {
            left: parent.left; right: parent.right;
            top: coverImage.bottom; margins: constant.paddingSmall;
        }
        value: audio.position / audio.duration * 1.0;
    }

    ProgressBar {
        anchors.fill: progressBar;
        indeterminate: true;
        visible: audio.status == Audio.Loading;
    }

    Text {
        anchors { right: parent.right; top: progressBar.bottom; }
        font: constant.subTitleFont;
        color: constant.colorMid;
        text: Calc.formatTime(audio.position) + "/" + (internal.musicData.stream_time || "00:00")
    }

    Column {
        anchors {
            left: parent.left;
            leftMargin: constant.paddingSmall;
            bottom: controlButtons.top;
            bottomMargin: constant.paddingMedium;
        }
        spacing: constant.paddingMedium;
        Text {
            font {
                family: constant.labelFont.family;
                pixelSize: constant.titleFont.pixelSize + 6;
            }
            color: constant.colorLight;
            text: internal.musicData.sub_title || qsTr("Title");
        }
        Row {
            visible: internal.musicData.wiki_title != "";
            spacing: constant.paddingSmall;
            Image {
                source: "../gfx/music_album.svg";
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                font: constant.subTitleFont;
                color: constant.colorLight;
                text: internal.musicData.wiki_title || qsTr("Album")
            }
        }
        Row {
            visible: internal.musicData.artist != "";
            spacing: constant.paddingSmall;
            Image {
                anchors.verticalCenter: parent.verticalCenter;
                source: "../gfx/contacts.svg";
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter;
                font: constant.subTitleFont;
                color: constant.colorLight;
                text: internal.musicData.artist || qsTr("Artist");
            }
        }
    }

    Row {
        id: controlButtons;

        anchors {
            horizontalCenter: parent.horizontalCenter; bottom: parent.bottom;
            bottomMargin: constant.paddingLarge;
        }

        spacing: (root.width - 320) / 5;

        // Favorite button
        ControlButton {
            iconId: "fav";
            enabled: internal.musicData.sub_id != undefined;
            checked: internal.musicData.isFav||false;
            onClicked: {
                if (!msettings.isLogin){
                    signalCenter.showMessage(qsTr("Please login first"));
                    return;
                }
                loading = true;
                var param = {
                    add: !checked,
                    sub_id: internal.musicData.sub_id,
                    fav_type: 1
                }
                function s(opt){
                    loading = false;
                    if (opt.sub_id == internal.musicData.sub_id){
                        internal.musicData.isFav = param.add;
                    }
                }
                function f(err){
                    loading = false;
                    signalCenter.showMessage(err);
                }
                Script.manageFav(param, s, f);
            }
        }

        ControlButton {
            iconId: audio.playing && !audio.paused ? "pause" : "play";
            onClicked: {
                if (audio.playing){
                    if (audio.paused) audio.play();
                    else audio.pause();
                } else {
                    if (audio.status == Audio.NoMedia||audio.status == Audio.EndOfMedia){
                        internal.playNext();
                    } else {
                        audio.play();
                    }
                }
            }
        }

        ControlButton {
            iconId: "next";
            enabled: audio.status != Audio.Loading;
            onClicked: internal.playNext();
        }

        // Delete button
        ControlButton {
            iconId: "delete";
            enabled: audio.status != Audio.Loading
                     && internal.musicData.sub_id != undefined;
            onClicked: {
                if (!msettings.isLogin){
                    signalCenter.showMessage(qsTr("Please login first"));
                    return;
                }
                loading = true;
                var param = {
                    add: true,
                    sub_id: internal.musicData.sub_id,
                    fav_type: 2
                }
                function s(opt){
                    loading = false;
                    if (opt.sub_id == internal.musicData.sub_id){
                        internal.playNext();
                    }
                }
                function f(err){
                    loading = false;
                    signalCenter.showMessage(err);
                }
                Script.manageFav(param, s, f);
            }
        }
    }
}
