#include "backend.hpp"
#include "prompt.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QFont>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickStyle>


int main(int argc, char *argv[])
{
	qputenv("QT_QUICK_CONTROLS_CONF", QDir::currentPath().toLocal8Bit() + "/gamebook.ini");

	QGuiApplication app(argc, argv);
	app.setOrganizationName("Thurinum");
	app.setApplicationName("Gamebook");

	QQmlApplicationEngine engine;

	Backend backend;
	engine.rootContext()->setContextProperty("App", &backend);

	const QUrl url("main.qml");
	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
			     &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);
	}, Qt::QueuedConnection);
	engine.load(url);

	return app.exec();
}
