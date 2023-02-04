#include "qextserialport.h"
#include "rfidreader.h"
#include "controlboard.h"

//#include <unistd.h>
//include <QSoundEffect>
//include <Windows.h>
#include <QtNetwork/QNetworkReply>
#include <QThread>

#include <stdio.h>

#ifdef Q_QWS
    #include <sys/ioctl.h>
    #include <fcntl.h>
#endif


#define PWM_IOCTL_SET_FREQ	1
#define PWM_IOCTL_STOP		0

int status;
char arr[50];
int count;

//#pragma comment(lib,"Winmm.lib")

RfidReader::RfidReader()
{
    openSerialPort();
}

RfidReader::~RfidReader()
{
    if (serial->isOpen())
        serial->close();
}

void RfidReader::openSerialPort()
{
//    QString port_name=findAvailablePort();
//    if(port_name == "no USB found")
//    {
//        //not found message
//        qDebug() << "could not found Serial Port .......";
//    }
//    else
//    {
    serial = new QextSerialPort("ttyO2");
    connect(serial, SIGNAL(readyRead()), this, SLOT(readData()));
    serial->setBaudRate(BAUD9600);
    serial->setFlowControl(FLOW_OFF);
    serial->setParity(PAR_NONE);
    serial->setDataBits(DATA_8);
    serial->setStopBits(STOP_1);

    if (serial->open(QIODevice::ReadWrite | QIODevice::Unbuffered))
        qDebug() << "open Serial Port ........";
    else
        qDebug() << "error openning Serial Port .......";
//    }
}

QString RfidReader::findAvailablePort()
{
    const int MAX_COM_PORT = 100;
    QString testPortName;
    QextSerialPort testPort;
    testPort.setBaudRate(BAUD9600);
    testPort.setFlowControl(FLOW_OFF);
    testPort.setParity(PAR_NONE);
    testPort.setDataBits(DATA_8);
    testPort.setStopBits(STOP_1);

    for (int i = 0; i < MAX_COM_PORT; i++)
    {

#ifdef WIN32
        testPortName = QString("COM%1").arg(i);
#else
        testPortName = QString("ttyUSB%1").arg(i);
#endif

        testPort.setPortName(testPortName);
        if (testPort.open(QIODevice::ReadWrite))
        {
            testPort.close();
            return testPortName;
        }
    }
    return "no USB found";
}

unsigned char h2d(char a)
{
    if(a >= '0' && a <= '9')
        return a - '0';
    else if(a >= 'A' && a <= 'F')
        return 10+(a - 'A');
    else if(a>='a' && a <= 'f')
        return 10+(a - 'a');
    return -1;
}

unsigned char tohex(char a,char b)
{
    return (h2d(a) << 4)|h2d(b);
}


#define STAT_IDLE   0
#define STAT_SOH    1

void RfidReader::readData()
{
    //status
    //0=not fill
    //1=fill
    //2=wait
    try
    {
        QByteArray data = serial->readAll();
        qDebug() << __FUNCTION__ << data ;

        for(int i=0;i<data.size();i++){

            switch(status)
            {
                case STAT_IDLE:
                    if ((int)data[i] == 2)
                    {
                        status=STAT_SOH;
                        arr[50] = '\0';
                        count=0;
                    }
                    break;
                case STAT_SOH:
                    if((char)data[i]==3)
                    {
                        // packet completion
                        int c=0,xor_tot=0;
                        unsigned char tmp;
                        int final = 0;
                        //status=0;
                        for (int a=0;a<5;a++)
                        {
                            tmp=tohex(arr[c],arr[c+1]);

                            xor_tot ^= tmp;

                            if(a > 0)
                                final |= (tmp << (4-a)*8);

                            c=c+2;
                        }

                        if(xor_tot != 0 && tohex(arr[c],arr[c+1]) == xor_tot)
                        {
                            qDebug() << xor_tot << arr[c] <<  arr[c+1] << tohex(arr[c],arr[c+1]);
                            //status=2;
                            //QFuture<void> f = QtConcurrent::run(this,&RfidReader::manageAPICaller,final);
                            emit captureCard(QString("%1").arg(final, 10, 10, QChar('0')));

                            //status=0;
                        }

                        // reset buffer to handle next SOH
                        status = STAT_IDLE;
                    }
                    else
                    {
                        // store in the buffer

                        //if array over flow ,reset state machine
                        if(count > 49)
                            status = STAT_IDLE;
                        else
                            arr[count++]=data[i];
                    }

                    break;

            }
        }
    }
    catch(std::exception e)
    {
        qDebug() << e.what();
    }
}

void RfidReader::activateRfidReader(const int &val)
{
    status=val;
}
