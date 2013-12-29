import QtQuick 1.1
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

Sheet {
    id: root;

    property Item caller: null;

    property int __isPage;  //To make the sheet happy
    property bool __isClosing: false;
    onStatusChanged: {
        if (status == DialogStatus.Closing){
            __isClosing = true;
        } else if (status == DialogStatus.Closed && __isClosing){
            root.destroy(250);
        }
    }
    Component.onCompleted: open();

    rejectButtonText: qsTr("Cancel");
    onRejected: signalCenter.imageSelected(caller, "");

    title: Text {
        font.pixelSize: 32;
        color: constant.colorLight;
        anchors {
            right: parent.right; rightMargin: constant.paddingLarge+2;
            verticalCenter: parent.verticalCenter;
        }
        text: qsTr("Select image");
    }

    DocumentGalleryModel {
        id: galleryModel;
        autoUpdate: true;
        rootType: DocumentGallery.Image;
        properties: ["url", "title", "lastModified", "dateTaken"];
        sortProperties: ["-lastModified","-dateTaken","+title"];
    }

    content: GridView {
        id: view;
        model: galleryModel;
        anchors.fill: parent;
        clip: true;
        cellWidth: parent.width / 3;
        cellHeight: cellWidth;
        delegate: MouseArea {
            implicitWidth: GridView.view.cellWidth;
            implicitHeight: GridView.view.cellHeight;

            onClicked: {
                signalCenter.imageSelected(caller, model.url);
                root.accept();
            }

            Image {
                anchors.fill: parent;
                sourceSize.width: parent.width;
                asynchronous: true;
                source: model.url;
                fillMode: Image.PreserveAspectCrop;
                clip: true;
                opacity: parent.pressed ? 0.7 : 1;
            }
        }
    }
}
