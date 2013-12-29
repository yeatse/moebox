import QtQuick 1.1
import com.nokia.meego 1.0

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

    Timer {
        id: timeoutTimer;
        interval: 40000;
        onTriggered: root.loading = false;
    }
}
