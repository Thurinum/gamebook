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

int main(int argc, char* argv[])
{
	qputenv("QT_QUICK_CONTROLS_CONF", QDir::currentPath().toLocal8Bit() + "/gamebook.ini");
	qRegisterMetaType<Prompt*>();
	qRegisterMetaType<QSharedPointer<Prompt>>();
	qRegisterMetaType<Reply*>();
	qRegisterMetaType<Scenario*>();
	qRegisterMetaType<Profile*>();
	qRegisterMetaType<QList<Reply*>>();

	QGuiApplication app(argc, argv);
	QGuiApplication::setOrganizationName("Thurinum");
	QGuiApplication::setApplicationName("Gamebook");

	QQmlApplicationEngine engine;
	Game			    backend(&engine);

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
