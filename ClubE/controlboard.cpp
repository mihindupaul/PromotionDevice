#include "controlboard.h"

#include <stdio.h>

#ifdef Q_WS_QWS
#include <sys/ioctl.h>
#endif

#include <fcntl.h>
#include <QImage>
#include <QDebug>
#include <QFile>
#include <QDir>
#include <QProcess>
#include <QCryptographicHash>

#ifdef Q_WS_QWS
#include <QNetworkInterface>
#endif

#define PWM_IOCTL_SET_FREQ	1
#define PWM_IOCTL_STOP		0

ControlBoard::ControlBoard(QObject *parent)
    : QObject(parent)
    ,m_Settings(QSettings::NativeFormat,QSettings::UserScope,"Buzz","app")
{
#ifdef Q_WS_QWS
    fd = ::open("/dev/buzzer", O_RDWR);
    fd1 = ::open("/sys/class/backlight/pwm-backlight/brightness",O_RDWR|O_NONBLOCK);
#endif
}

ControlBoard::~ControlBoard()
{
#ifdef Q_WS_QWS
    ioctl(fd, PWM_IOCTL_STOP);
    ::close(fd);//84EB18ADBF0F
#endif
}

void ControlBoard::setBackLight(int v)
{
#ifdef Q_WS_QWS
    char buf[20];
    sprintf(buf,"%d",v);
    ::write(fd1,buf,sizeof(buf));
#endif
}

void ControlBoard::setBuzzerFreq(int freq,int time_gap)
{
#ifdef Q_WS_QWS
    ioctl(fd, PWM_IOCTL_SET_FREQ, freq);
    usleep(time_gap);
    ioctl(fd, PWM_IOCTL_SET_FREQ, 0);
    usleep(time_gap);
    ioctl(fd, PWM_IOCTL_SET_FREQ, freq);
    usleep(time_gap);
    ioctl(fd, PWM_IOCTL_SET_FREQ, 0);
#endif
}

void ControlBoard::setIdelBuzzerFreq(int freq,int time_gap)
{
#ifdef Q_WS_QWS
    ioctl(fd, PWM_IOCTL_SET_FREQ, freq);
    usleep(time_gap);
    ioctl(fd, PWM_IOCTL_SET_FREQ, 0);
#endif
}

QString ControlBoard::getDevicePin(){
    return "123456";
}

QString ControlBoard::getDeviceID(){

    QString text;
    #ifdef Q_WS_QWS
    foreach(QNetworkInterface interface, QNetworkInterface::allInterfaces())
    {
        if(interface.name() == "eth0")
        {
            return interface.hardwareAddress().replace(':',"");
        }
    }
    #endif

    return "84EB18ADBF0F";
}

QString ControlBoard::getAccessCode(){

    //return QCryptographicHash::hash(getDeviceID().toAscii(),QCryptographicHash::Sha1).toHex();
    return "c1773e9120b4340cb43c2e9781265bce506de5d3";
}

void ControlBoard::saveImages(QByteArray decode_data, QString i_name){

    QByteArray bimage = QByteArray::fromBase64(decode_data);
    #ifdef Q_WS_QWS
        QString fileName="/home/root/test/"+ i_name +".png";
    #else
        QString fileName="/home/ranjana/clube_pro/ClubE/coupon_images/"+ i_name +".png";
    #endif
    qDebug() << fileName;
    QFile f(fileName);

    if(f.open(QIODevice::ReadWrite))
    {
        f.write(bimage);
        f.flush();
        f.close();
    }

}

bool ControlBoard::isDevice()
{
#ifdef Q_WS_QWS
    return false;
#else
    return true;
#endif
}

QString ControlBoard::launch(const QString &program)
{
    QProcess m_process;
    qDebug() << program;

    m_process.start(program);
    m_process.waitForFinished(-1);
    QByteArray bytes = m_process.readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    //qDebug() << bytes;
    return output;
}

int ControlBoard::wifiConfig(QString script,QString ssid,QString pw){
   qDebug() << script << ssid << pw;
    QProcess m_process;
    m_process.start("/bin/bash", QStringList() << script << ssid << pw);
    m_process.waitForFinished(-1);
    QByteArray bytes = m_process.readAllStandardOutput();
    QString output = QString::fromLocal8Bit(bytes);
    //qDebug() << output;
    return 0;
}

void ControlBoard::setConfigValue(QString name,QVariant val)
{
    if(val.type()==QVariant::Bool)
        m_Settings.setValue(name,val.toInt());
    else
        m_Settings.setValue(name,val);

    m_Settings.sync();
}

QVariant ControlBoard::getConfigValue(QString key,QVariant def = QVariant())
{
    QVariant ret = m_Settings.value(key,def);

    qDebug() << "Config Read " << key << ":" << ret << "( Defualt:" << def << ")";
    return m_Settings.value(key,def);
}

int ControlBoard::autoSysytemUpdate(const QString &script, QString v_id){
    QProcess m_process;
    m_process.start("/bin/bash", QStringList() << script << v_id);
    m_process.waitForFinished(-1);
    return m_process.exitCode();
}
