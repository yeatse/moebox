import QtQuick 1.1
import com.nokia.symbian 1.1

Page {
    id: root;

    property string title: "";

    property bool loading: false;

    // If set to true, loading status will not last for over 40 seconds.
    property bool timeoutEnabled: true;

    onLoadingChanged: {
        if (timeoutEnabled){
            if (loading) timeoutTimer.restart();
            else timeoutTimer.stop();
        }
    }

    orientationLock: PageOrientation.LockPortrait;

    Binding {
        target: statusPaneText;
        property: "text";
        value: root.title;
        when: title != "" && root.status == PageStatus.Active;
    }

    Timer {
        id: timeoutTimer;
        interval: 40000;
        onTriggered: root.loading = false;
    }
}
