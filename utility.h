#ifndef UTILITY_H
#define UTILITY_H

#include <QtDeclarative>

class Utility : public QObject
{
    Q_OBJECT
public:
    static Utility* Instance();
    ~Utility();

    Q_INVOKABLE QVariant getValue(const QString &key, const QVariant &defaultValue = QVariant());
    Q_INVOKABLE void setValue(const QString &key, const QVariant &value);

    Q_INVOKABLE QColor selectColor(const QColor &defaultColor);
    Q_INVOKABLE QUrl selectImage(const QUrl &defaultUrl);

    Q_INVOKABLE void showNotification(const QString &title, const QString &message) const;

private:
    explicit Utility(QObject *parent = 0);

    QSettings* settings;
    QMap<QString, QVariant> map;

#ifdef Q_OS_SYMBIAN
    QString LaunchLibrary();
#endif
};

#if defined(Q_OS_HARMATTAN) || defined(Q_WS_SIMULATOR)
// To provide a subtransparent background image.
class BackgroundProvider : public QDeclarativeImageProvider
{
public:
    BackgroundProvider(QDeclarativeImageProvider::ImageType type = QDeclarativeImageProvider::Pixmap);
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // Q_OS_HARMATTAN or Q_WS_SIMULATOR

#endif // UTILITY_H
