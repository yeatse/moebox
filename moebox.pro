TEMPLATE = app
TARGET = moebox

VERSION = 1.1.0
DEFINES += VER=\\\"$$VERSION\\\"

QT += network webkit

# Required by QtMultimediaKit 1.1
CONFIG += mobility
MOBILITY += multimedia systeminfo

INCLUDEPATH += src

HEADERS += \
    utility.h

SOURCES += main.cpp \
    utility.cpp \
#    qml/moebox/*.qml \
#    qml/Component/*.qml

RESOURCES += moebox-res.qrc

TRANSLATIONS += i18n/moebox_zh.ts

folder_symbian3.source = qml/moebox
folder_symbian3.target = qml

folder_harmattan.source = qml/meego
folder_harmattan.target = qml

folder_gfx.source = qml/gfx
folder_gfx.target = qml

folder_js.source = qml/js
folder_js.target = qml

DEPLOYMENTFOLDERS = folder_js folder_gfx

simulator {
    DEPLOYMENTFOLDERS += folder_symbian3 folder_harmattan
}

contains(MEEGO_EDITION, harmattan){
    DEFINES += Q_OS_HARMATTAN
    DEPLOYMENTFOLDERS += folder_harmattan

    CONFIG += qdeclarative-boostable
    MOBILITY += gallery
}

symbian {
    DEPLOYMENTFOLDERS += folder_symbian3

    CONFIG += qt-components localize_deployment
    TARGET.UID3 = 0x2006DFFC
    TARGET.CAPABILITY *= \
        NetworkServices \
        ReadUserData \
        WriteUserData \
        ReadDeviceData \
        WriteDeviceData
    TARGET.EPOCHEAPSIZE = 0x40000 0x4000000

    LIBS *= -lMgFetch -lbafl \#for Selecting Picture
         -lavkon        #for notification

    vendorinfo = "%{\"Yeatse\"}" ":\"Yeatse\""
    my_deployment.pkg_prerules += vendorinfo
    DEPLOYMENT += my_deployment

    # Symbian have a different syntax
    DEFINES -= VER=\\\"$$VERSION\\\"
    DEFINES += VER=\"$$VERSION\"
}

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()
