#ifndef CONTROLBOARD_H
#define CONTROLBOARD_H

#include <QObject>
#include <QSettings>

class ControlBoard : public QObject
{
    Q_OBJECT
public:
    explicit ControlBoard(QObject *parent = 0);
    ~ControlBoard();
    //bool isDevice();
    Q_INVOKABLE void setConfigValue(QString name,QVariant val);
    Q_INVOKABLE QVariant getConfigValue(QString name,QVariant def);

signals:

public slots:
    void setBackLight(int v);
    void setBuzzerFreq(int freq,int time_gap);
    void setIdelBuzzerFreq(int freq,int time_gap);
    void saveImages(QByteArray decode_data, QString i_name);
    QString getDevicePin();
    QString getDeviceID();
    QString getAccessCode();
    bool isDevice();
    QString launch(const QString &program);
    int wifiConfig(QString script,QString ssid,QString pw);
    int autoSysytemUpdate(const QString &script, QString v_id);

private:
    int fd,fd1;
    QSettings m_Settings;
};

#endif // CONTROLBOARD_H
