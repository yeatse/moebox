#include <QtDeclarative>
#include "qmlapplicationviewer.h"
#include "utility.h"
#include <QtWebKit/QWebSettings>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
#ifdef Q_OS_SYMBIAN
    // Capture the volume key event.
    QApplication::setAttribute(Qt::AA_CaptureMultimediaKeys);
#endif
    QScopedPointer<QApplication> app(createApplication(argc, argv));

#ifndef Q_OS_HARMATTAN
    QSplashScreen *splash = new QSplashScreen(QPixmap("qml/gfx/splash.png"));
    splash->show();
    splash->raise();
#endif

    app->setApplicationName("moebox");
    app->setOrganizationName("Yeatse");
    app->setApplicationVersion(VER);

    // Install translator for qt
    QString locale = QLocale::system().name();

    QTranslator qtTranslator;
    if (qtTranslator.load("qt_"+locale, QLibraryInfo::location(QLibraryInfo::TranslationsPath)))
        app->installTranslator(&qtTranslator);

    QTranslator translator;
    if (translator.load(app->applicationName()+"_"+locale, ":/i18n/"))
        app->installTranslator(&translator);

    QWebSettings::globalSettings()->setUserStyleSheetUrl(QUrl::fromLocalFile("qml/js/default_theme.css"));

    QmlApplicationViewer viewer;
    viewer.setOrientation(QmlApplicationViewer::ScreenOrientationLockPortrait);
    viewer.rootContext()->setContextProperty("utility", Utility::Instance());

#if defined(Q_OS_HARMATTAN) || defined(Q_WS_SIMULATOR)
    viewer.engine()->addImageProvider(QLatin1String("background"), new BackgroundProvider);
#endif

#ifdef Q_OS_SYMBIAN
    viewer.setMainQmlFile(QLatin1String("qml/moebox/main.qml"));
#elif defined(Q_OS_HARMATTAN)
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
#else
    viewer.setMainQmlFile(QLatin1String("qml/meego/main.qml"));
#endif
    viewer.showExpanded();

#ifndef Q_OS_HARMATTAN
    splash->finish(&viewer);
    splash->deleteLater();
#endif

    return app->exec();
}
