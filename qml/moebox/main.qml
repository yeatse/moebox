import QtQuick 1.1
import com.nokia.symbian 1.1
import com.nokia.extras 1.1
import QtMultimediaKit 1.1
import QtMobility.systeminfo 1.1
import "Component"
import "../js/main.js" as Script

PageStackWindow {
    id: app;

    // For belle fp2.
    platformSoftwareInputPanelEnabled: true;

    initialPage: MainPage { id: mainPage; }

    // To simulate status pane text on belle.
    StatusPaneText { id: statusPaneText; }

    // Application settings and common user data.
    MSettings { id: msettings; }

    // Application constants for easily porting to other platforms.
    Constant { id: constant; }

    // Common function containers.
    SignalCenter { id: signalCenter; }

    // Infomation banner.
    InfoBanner { id: infoBanner; }

    // Custom background.
    Background { id: background; }

    // Audio player.
    Audio { id: audio; volume: volumeIndicator.currentVolume; }

    // To get the system volume.
    DeviceInfo { id: deviceInfo; }

    // Show volume when it changes.
    VolumeIndicator { id: volumeIndicator; currentVolume: Math.min(deviceInfo.voiceRingtoneVolume/100, 0.5); }

    // Set volume of audio.
    Keys.onVolumeUpPressed: volumeIndicator.volumeUp();
    Keys.onVolumeDownPressed: volumeIndicator.volumeDown();
    Keys.onUpPressed: volumeIndicator.volumeUp();
    Keys.onDownPressed: volumeIndicator.volumeDown();

    Component.onCompleted: Script.initialize(signalCenter, msettings);
}
