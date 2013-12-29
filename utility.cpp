#include "utility.h"

#ifdef Q_OS_SYMBIAN
#include <mgfetch.h>                //launch library
#include <akndiscreetpopup.h>       // notification
#include <avkon.hrh>                // ...
#endif

Utility::Utility(QObject *parent) :
    QObject(parent),
    settings(0)
{
    settings = new QSettings(this);
}

Utility::~Utility()
{
}

Utility* Utility::Instance()
{
    static Utility u;
    return &u;
}

QVariant Utility::getValue(const QString &key, const QVariant &defaultValue)
{
    if (map.contains(key)){
        return map.value(key);
    } else {
        return settings->value(key, defaultValue);
    }
}

void Utility::setValue(const QString &key, const QVariant &value)
{
    if (map.value(key) != value){
        map.insert(key, value);
        settings->setValue(key, value);
    }
}


QColor Utility::selectColor(const QColor &defaultColor)
{
    QColor selected = QColorDialog::getColor(defaultColor);
    if (selected.isValid()) return selected;
    else return defaultColor;
}

QUrl Utility::selectImage(const QUrl &defaultUrl)
{
    QString result;
#ifdef Q_OS_SYMBIAN
    TRAP_IGNORE(result = LaunchLibrary());
#else
    result =  QFileDialog::getOpenFileName(0, QString(), QString(), "Images (*.png *.jpg)");
#endif
    if (result.isEmpty()) return defaultUrl;
    else return QUrl(result);
}

void Utility::showNotification(const QString &title, const QString &message) const
{
#ifdef Q_OS_SYMBIAN
    TPtrC16 sTitle(static_cast<const TUint16 *>(title.utf16()), title.length());
    TPtrC16 sMessage(static_cast<const TUint16 *>(message.utf16()), message.length());
    TRAP_IGNORE(CAknDiscreetPopup::ShowGlobalPopupL(sTitle, sMessage, KAknsIIDNone, KNullDesC, 0, 0, KAknDiscreetPopupDurationLong, 0, NULL, {0x2006DFFC}));
#else
    qDebug() << "showNotification:" << title << message;
#endif
}

#ifdef Q_OS_SYMBIAN

QString Utility::LaunchLibrary()
{
    QString res;
    CDesCArrayFlat* fileArray = new(ELeave)CDesCArrayFlat(3);
    CleanupStack::PushL(fileArray);
    if (MGFetch::RunL(*fileArray, EImageFile, EFalse)){
        HBufC* result = fileArray->MdcaPoint(0).Alloc();
        res = QString((QChar*)result->Des().Ptr(), result->Length());
    }
    CleanupStack::PopAndDestroy();
    return res;
}

#endif

#if defined(Q_OS_HARMATTAN) || defined(Q_WS_SIMULATOR)
BackgroundProvider::BackgroundProvider(QDeclarativeImageProvider::ImageType type)
    : QDeclarativeImageProvider(type)
{
}

QPixmap BackgroundProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(requestedSize);

    int idx1 = id.indexOf("/");
    int idx2 = id.indexOf("/", idx1+1);

    double opacity = id.left(idx1).toDouble();
    QColor maskColor = QColor(Qt::black);
    maskColor.setAlphaF(opacity);
    QColor bgColor = QColor(id.mid(idx1+1, idx2-idx1-1));
    QString bgImgUrl = id.mid(idx2+1).replace("file:///", "/");

    QSize desktopSize = qApp->desktop()->screenGeometry().size();
#ifdef Q_OS_HARMATTAN
    desktopSize.transpose();
#endif
    size->setWidth(desktopSize.width());
    size->setHeight(desktopSize.height());

    QImage result(desktopSize, QImage::Format_ARGB32);
    if (result.load(bgImgUrl)){
        result = result.scaled(desktopSize, Qt::KeepAspectRatioByExpanding);
        result = result.copy(0, 0, desktopSize.width(), desktopSize.height());
    } else {
        result.fill(bgColor.rgba());
    }

    QPainter p(&result);
    p.fillRect(result.rect(), maskColor);

    return QPixmap::fromImage(result);
}

#endif
