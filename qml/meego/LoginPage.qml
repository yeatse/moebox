import QtQuick 1.1
import com.nokia.meego 1.0
import QtWebKit 1.0
import "Component"
import "../js/main.js" as Script

MyPage {
    id: page;

    title: webView.title || qsTr("Login");

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back";
            onClicked: pageStack.pop();
        }
        ToolIcon {
            id: loginButton;
            platformIconId: "toolbar-mediacontrol-play";
            visible: internal.verifier != "";
            enabled: verifierField.text == internal.verifier && !loading;
            onClicked: internal.accessToken();
        }
    }

    QtObject {
        id: internal;

        property string verifier: "";

        function getUrl(){
            loading = true;
            function s(url){
                loading = false;
                webView.url = url;
            }
            function f(err){
                loading = false;
                signalCenter.showMessage(err);
            }
            Script.requestToken(s, f);
        }

        function urlChanged(){
            var url = webView.url.toString();
            var param = url.substring(url.indexOf("?")+1);
            var map = Script.OAuth.getParameterMap(param);
            var verifier = map.verifier;
            if (verifier){
                internal.verifier = verifier;
                bottomBar.visible = true;
            }
        }

        function accessToken(){
            loading = true;
            function s(){
                loading = false;
                signalCenter.showMessage(qsTr("Login success~"));
                Script.initialize();
                pageStack.pop();
            }
            function f(err){
                loading = false;
                signalCenter.showMessage(err);
            }
            Script.accessToken(s, f);
        }
    }

    Flickable {
        id: view;
        anchors.fill: parent;
        contentWidth: webView.width;
        contentHeight: webView.height;

        WebView {
            id: webView;
            preferredWidth: view.width;
            preferredHeight: view.height;
            onLoadStarted: progressBar.visible = true;
            onLoadFinished: progressBar.visible = false;
            onLoadFailed: progressBar.visible = false;
            onUrlChanged: internal.urlChanged();
            settings {
                minimumFontSize: constant.labelFont.pixelSize;
                minimumLogicalFontSize: constant.labelFont.pixelSize;
            }
        }
    }

    ScrollDecorator { flickableItem: view; }

    ProgressBar {
        id: progressBar;
        visible: false;
        anchors { top: parent.top; left: parent.left; right: parent.right }
        value: webView.progress;
    }

    Rectangle {
        id: bottomBar;
        visible: false;
        anchors { left: parent.left; right: parent.right; bottom: view.bottom; }
        height: bottomCol.height + constant.paddingLarge*2;
        smooth: true;
        color: constant.colorDisabled;
        Column {
            id: bottomCol;
            anchors {
                left: parent.left; right: parent.right; top: parent.top;
                margins: constant.paddingLarge;
            }
            spacing: constant.paddingLarge;
            Text {
                text: qsTr("Please check the verifier below:");
                font: constant.labelFont;
                color: constant.colorLight;
            }
            TextField {
                id: verifierField;
                width: parent.width;
                text: internal.verifier;
                inputMethodHints: Qt.ImhNoPredictiveText;
            }
        }
    }

    Component.onCompleted: internal.getUrl();
}
