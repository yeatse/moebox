import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import QtMultimediaKit 1.1
import "Component"
import "../js/main.js" as Script

PageStackWindow {
    id: app;

    platformStyle: PageStackWindowStyle {
        cornersVisible: pageStack.currentPage != mainPage;
        background: "image://background/"
                    +msettings.bgMaskOpacity
                    +"/"+msettings.bgColor
                    +"/"+msettings.bgImageUrl;
    }

    initialPage: MainPage { id: mainPage; }

    // Application settings and common user data.
    MSettings { id: msettings; }

    // Application constants for easily porting to other platforms.
    Constant { id: constant; }

    // Common function containers.
    SignalCenter { id: signalCenter; }

    // Infomation banner.
    InfoBanner { id: infoBanner; topMargin: 36; }

    // Audio player.
    Audio { id: audio; }

    Binding { target: theme; property: "inverted"; value: true; }

    CustomProgressBar {
        anchors { top: parent.top; topMargin: 36; left: parent.left; right: parent.right; }
        visible: pageStack.currentPage.loading || false;
    }

    Component.onCompleted: Script.initialize(signalCenter, msettings);
}
