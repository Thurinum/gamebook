QT += qml quick quickcontrols2 xml

CONFIG += c++17

SOURCES += \
        backend.cpp \
        character.cpp \
        main.cpp \
        profile.cpp \
        prompt.cpp \
        reply.cpp \
        replytype.cpp \
        scenario.cpp

HEADERS += \
	backend.hpp \
	character.hpp \
	profile.hpp \
	prompt.hpp \
	reply.hpp \
	replytype.hpp \
	scenario.hpp

DISTFILES += \
	gamebook.ini \
	gamebook.ini \
	utils.js \
	Main.qml \
	resources/graphics/background.jpeg
