#include "backend.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QGuiApplication>
#include <QUrl>

Backend::Backend()
{
	settings = new QSettings(QDir::currentPath() + "/gamebook.ini", QSettings::IniFormat);
}

QVariant Backend::setting(QString key)
{
	return this->settings->value(key);
}

void Backend::setSetting(QString key, QVariant val)
{
	settings->setValue(key, val);
}

void Backend::createScenario(QString name)
{
	Scenario scn(name);
}

QUrl Backend::getScenariosFolder()
{
	return QUrl::fromLocalFile(QDir::currentPath() + "/scenarios");
}
