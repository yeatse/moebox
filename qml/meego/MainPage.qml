import QtQuick 1.1
import com.nokia.meego 1.0
import QtMultimediaKit 1.1
import "Component"
import "../js/main.js" as Script

MyPage {
    id: page;

    title: qsTr("Moebox");

    onStatusChanged: if (status == PageStatus.Active) view.forceActiveFocus();

    // Main application view.
    // Using a horizontal ListView to simulate swipe gesture.
    ListView {
        id: view;
        currentIndex: 1;
        focus: true;
        anchors.fill: parent;
        preferredHighlightBegin: 0;
        preferredHighlightEnd: 0;
        highlightMoveDuration: 250;
        highlightRangeMode: ListView.StrictlyEnforceRange;
        snapMode: ListView.SnapOneItem;
        boundsBehavior: ListView.StopAtBounds;
        orientation: ListView.Horizontal;
        model: itemModel;

        Component.onCompleted: positionViewAtIndex(1, ListView.Center);
    }

    // The content of view.
    VisualItemModel {
        id: itemModel
        // Settings UI
        SettingsView { id: settingsView; }

        // Music player UI.
        PlayerView { id: playerView; }

        // Playlist UI
        PlaylistView { id: playlistView; }
    }

    // Main playlist model.
    ListModel { id: playlistModel; }

    QtObject {
        id: internal;

        property int currentIndex: 0;
        property variant musicData: ({});
        onMusicDataChanged: console.log("musicdata===============\n",
                                        JSON.stringify(musicData));


        //"", "music", "song", "radio"
        property string playSource: "";
        property int pageNumber: 1;
        property bool hasNext: true;
        onPlaySourceChanged: {
            pageNumber = 1;
            hasNext = true;
        }

        function getPlaylist(callback){
            if (loading) return;
            loading = true;
            var opt = { "model": playlistModel };

            if (playSource != ""){
                opt.fav = playSource;
                if (playSource == "song"||playSource == "radio"){
                    opt.random = true;
                }
                if (pageNumber > 1){
                    opt.page = pageNumber;
                }
            }

            function s(info){
                loading = false;

                if (typeof(info)=="object"
                        && info.hasOwnProperty("parameters")
                        && info.parameters.fav == playSource){
                    hasNext = info.may_have_next;
                    pageNumber = info.page + 1;
                }

                if (typeof(callback) == "function"){
                    callback();
                }
            }
            function f(err){
                loading = false;
                signalCenter.showMessage(err);
            }
            Script.getPlaylist(opt, s, f);
        }

        function playNext(){
            if (currentIndex+1 >= playlistModel.count){
                // Play to the end of list
                // If has next page, request next page of list
                // Else return top of list
                if (hasNext){
                    getPlaylist(playNext);
                } else {
                    playMusic(0);
                }
            } else {
                playMusic(currentIndex+1);
            }
        }

        function playMusic(index){
            if (typeof(index) == 'number') currentIndex = index;

            // Application will crash if play audio when audio status is Audio.Loading.
            if (audio.status == Audio.Loading){
                audioColdDownHandler.target = audio;
            } else if (audio.status != Audio.Loading){
                audioColdDownTimer.restart();
            }
        }
    }

    Timer {
        id: audioColdDownTimer;
        interval: 500;
        onTriggered: {
            internal.musicData = playlistModel.get(internal.currentIndex);
            audio.source = internal.musicData.url;
            audio.play();
            var msg = qsTr("Now playing:")+internal.musicData.sub_title
            signalCenter.showGlobalMessage(msg);
        }
    }

    Connections {
        target: signalCenter;
        onInitialized: {
            internal.currentIndex = 0;
            internal.musicData = {};
            internal.playSource = "";
            playlistModel.clear();
            internal.getPlaylist(internal.playMusic);
        }
    }

    Connections {
        id: audioColdDownHandler;
        target: null;
        onStatusChanged: {
            if (audio.status != Audio.Loading){
                audioColdDownHandler.target = null;
                internal.playMusic();
            }
        }
    }

    Connections {
        target: audio;
        onStatusChanged: {
            if (audio.status == Audio.EndOfMedia){
                console.log("Audio: end of media");
                if (msettings.isLogin){
                    // Upload playing record.
                    Script.logRecord(internal.musicData.sub_id);
                }
                internal.playNext();
            }
        }
        onError: {
            console.log("Audio: error "+audio.error);
            internal.playNext();
        }
    }
}
