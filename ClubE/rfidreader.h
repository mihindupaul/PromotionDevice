#ifndef RFIDREADER_H
#define RFIDREADER_H

#include "qextserialport.h"
#include <QObject>
#include <QDebug>
#include <QtCore/QtGlobal>
#include <iostream>
#include <string>
#include <QtCore>

class RfidReader : public QObject
{
    Q_OBJECT

public:
    RfidReader();
    ~RfidReader();

signals:
    void captureCard(QString card_id);
    void waitForResult();
    void errorHandling(QString msg);

private slots:
    void readData();

public slots:
    void activateRfidReader(const int &val);

private:
    void openSerialPort();
    QString findAvailablePort();

    QextSerialPort * serial;
};

#endif // RFIDREADER_H
