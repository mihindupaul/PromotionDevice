QT += multimedia

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    rfidreader.cpp \
    apihandler.cpp \
    controlboard.cpp


RESOURCES += qml.qrc

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick1applicationviewer/qtquick1applicationviewer.pri)

# Default rules for deployment.
include(deployment.pri)

#thirdparty for
include(3rdparty/qextserialport/src/qextserialport.pri)

HEADERS += \
    rfidreader.h \
    apihandler.h \
    controlboard.h


DISTFILES += scripts/* \
    scripts/wifi.sh \
    scripts/setwifi.sh

# MP: addtion to link touch screen prebuilt sdk libs
# provided on the distribution package
#LIBS += -L/usr/local/arm/tslib/lib -lts
