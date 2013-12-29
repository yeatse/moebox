import QtQuick 1.1

QtObject {
    id: signalCenter;

    // Emitted once application launched
    signal initialized;

    signal imageSelected(variant caller, string url);

    property variant gallerySheetComp: null;

    function showMessage(msg){
        if (msg || false){
            infoBanner.text = msg + "";
            infoBanner.show();
        }
    }

    function showGlobalMessage(msg){
        utility.showNotification(qsTr("Moebox"), msg);
    }

    function setLoadingIndicator(flag){
        pageStack.currentPage.loading = flag;
    }

    function selectImage(caller){
        if (!gallerySheetComp){
            gallerySheetComp = Qt.createComponent("Component/GallerySheet.qml");
        }
        gallerySheetComp.createObject(pageStack.currentPage, {"caller": caller});
    }
}
