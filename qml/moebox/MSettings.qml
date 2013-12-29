import QtQuick 1.1

QtObject {
    id: msettings;

    property bool isLogin: false;

    property color bgColor: utility.getValue("bgColor", "#FF93C0FF");
    onBgColorChanged: utility.setValue("bgColor", bgColor);

    property real bgMaskOpacity: utility.getValue("bgMaskOpacity", 0.7);
    onBgMaskOpacityChanged: utility.setValue("bgMaskOpacity", bgMaskOpacity);

    property url bgImageUrl: utility.getValue("bgImageUrl", "");
    onBgImageUrlChanged: utility.setValue("bgImageUrl", bgImageUrl);

    property string token: utility.getValue("oauth_token", "");
    onTokenChanged: utility.setValue("oauth_token", token);

    property string tokenSecret: utility.getValue("oauth_token_secret", "");
    onTokenSecretChanged: utility.setValue("oauth_token_secret", tokenSecret);

    property variant userDetail: ({});
}
