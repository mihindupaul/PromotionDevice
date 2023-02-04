#include "qtquick1applicationviewer.h"
#include "rfidreader.h"
#include "controlboard.h"

#include <QApplication>
#include <QDeclarativeView>
#include <QDeclarativeContext>
//include <qdebug.h>
//include <QGraphicsObject>
#include <QDebug>
#include <QDeclarativeEngine>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QDeclarativeEngine engine;
    qDebug() << "Default path >> "+engine.offlineStoragePath();
    ControlBoard cb;

    //app.setOverrideCursor(Qt::BlankCursor);

    QtQuick1ApplicationViewer viewer;

    cb.setBackLight(100);
    cb.setBuzzerFreq(0,200000);

    viewer.rootContext()->setContextProperty("myObject", new RfidReader);
    viewer.rootContext()->setContextProperty("control_bord", &cb);

    viewer.addImportPath(QLatin1String("modules"));
    viewer.setOrientation(QtQuick1ApplicationViewer::ScreenOrientationAuto);
    viewer.setMainQmlFile(QLatin1String("qrc:/main.qml"));

#ifdef Q_WS_QWS
     viewer.setCursor(Qt::BlankCursor);
     viewer.showFullScreen();
#else
     viewer.showExpanded();
#endif

    return app.exec();
}
