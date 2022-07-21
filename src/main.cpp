#include "game.hpp"
#include "prompt.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QFont>
#include <QGuiApplication>
#include <QHash>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>
#include <QSurfaceFormat>
#include <QUuid>

int main(int argc, char* argv[]) {
	// add Qt Quick configuration to the main INI file
	qputenv("QT_QUICK_CONTROLS_CONF", Utils::INI_FILE_LOCATION.toLocal8Bit());

	qRegisterMetaType<Prompt*>();
	qRegisterMetaType<Reply*>();
	qRegisterMetaType<Scenario*>();
	qRegisterMetaType<Profile*>();

	QGuiApplication app(argc, argv);
	QGuiApplication::setOrganizationName("Thurinum");
	QGuiApplication::setApplicationName(Utils::setting("Main/sApplicationName").toString());

	QSurfaceFormat format;
	format.setSamples(Utils::setting("Main/iAntialiasSamples").toInt());
	QSurfaceFormat::setDefaultFormat(format);

	Game			    backend;
	QQmlApplicationEngine engine;

	engine.rootContext()->setContextProperty("Game", &backend);

	const QUrl url("qml/Main.qml");
	QObject::connect(
		&engine,
		&QQmlApplicationEngine::objectCreated,
		&app,
		[url](QObject* obj, const QUrl& objUrl) {
			if ((obj == nullptr) && url == objUrl)
				QCoreApplication::exit(-1);
		},
		Qt::QueuedConnection);
	engine.load(url);

	return QGuiApplication::exec();
}
