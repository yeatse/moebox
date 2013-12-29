import QtQuick 1.1

QtObject {
    id: signalCenter;

    // Emitted once application launched
    signal initialized;

    function showMessage(msg){
        if (msg || false){
            infoBanner.text = msg + "";
            infoBanner.open();
        }
    }

    function showGlobalMessage(msg){
        utility.showNotification(qsTr("Moebox"), msg);
    }

    function setLoadingIndicator(flag){
        pageStack.currentPage.loading = flag;
    }
}
