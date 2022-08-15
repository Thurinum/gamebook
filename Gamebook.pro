QT += qml quick quickcontrols2 xml
QT -= network

CONFIG += c++17
SOURCES += $$files("src/*.cpp", true)
HEADERS += $$files("include/*.hpp", true)
INCLUDEPATH += "include"

DISTFILES += \
	gamebook.ini \
	$$files("qml/*.qml", true) \
	$$files("scripts/*.js", true) \
	$$files("resources/*", true) \
	$$files("scenarios/*", true) \
	qml/dialogs/PromptUpdateBatch.qml \
	qml/interface/EndScreen.qml \
	qml/interface/OutlineView.qml
