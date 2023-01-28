QT = core gui qml quick quickcontrols2 xml

CONFIG += c++20
SOURCES += $$files("$$PWD/src/*.cpp", true)
HEADERS += $$files("$$PWD/include/*.hpp", true)
INCLUDEPATH += "include"

DISTFILES = $$files("$$PWD/bin/*", true)

DESTDIR = $$PWD/bin
