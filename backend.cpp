#include "backend.hpp"
#include "profile.hpp"
#include "prompt.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QGuiApplication>
#include <QUrl>
#include <QXmlStreamReader>

Game::Game()
{
	settings = new QSettings(QDir::currentPath() + "/gamebook.ini", QSettings::IniFormat);
}

QVariant Game::setting(QString key)
{
	return this->settings->value(key);
}

void Game::setSetting(QString key, QVariant val)
{
	settings->setValue(key, val);
}

void Game::createScenario(QString name)
{
	this->scenario = new Scenario();
}

void Game::loadScenario(QString name)
{
	Scenario* scn = new Scenario();
	scn->setName(name);

	QFile file("scenarios/" + name + ".scenario");
	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open file for writing";
		return;
	}

	QXmlStreamReader reader(&file);
	Prompt* p = nullptr;
	reader.readNextStartElement(); // scenario

	while (!reader.atEnd() && reader.readNextStartElement()) {
		QString name = reader.name().toString();

		if (name == "prompt") {
			p = new Prompt();
			QString id = reader.attributes().value("id").toString();
			p->setId(id);
			p->setText(reader.attributes().value("text").toString());
			scn->prompts().insert(id, p);
		} else if (p && name == "reply") {
			Reply* r = new Reply();
			r->setTarget(reader.attributes().value("target").toString());
			r->setText(reader.attributes().value("text").toString());
			p->replies().append(r);
		}
	}

	file.close();
	this->scenario = scn;
}

void Game::loadScenarioProfile(QString name)
{
	Profile* profile = new Profile;

	if (!this->scenario) {
		qWarning() << "Tried to create profile before scenario";
		return;
	}

	QFile file("scenarios/" + this->scenario->name() + "_" + name + ".scenario");
	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open file for writing";
		return;
	}

	QXmlStreamReader reader(&file);
	reader.readNextStartElement(); // profile
	// TODO load profile
	file.close();
}

QUrl Game::getScenariosFolder()
{
	return QUrl::fromLocalFile(QDir::currentPath() + "/scenarios");
}
