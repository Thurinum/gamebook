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

	while (!reader.atEnd()) {
		reader.readNextStartElement();
		QString name = reader.name().toString();

		if (name == "prompt") {
			p = new Prompt();
			QString id = reader.attributes().value("id").toString();
			p->setId(id);
			p->setText(reader.attributes().value("text").toString());
			p->setCharacter(reader.attributes().value("character").toString());
			p->setBackground(reader.attributes().value("background").toString());
			scn->prompts().insert(id, p);
		} else if (p && name == "reply") {
			Reply* r = new Reply();
			r->setTarget(reader.attributes().value("target").toString());
			r->setText(reader.attributes().value("text").toString());
			if (reader.isStartElement())
				p->replies().append(r);
		} else if (name == "replytype") {

		} else if (name == "character") {
			Character* c = new Character;
			c->setName(reader.attributes().value("name").toString());
			c->setSprite(reader.attributes().value("sprite").toString());
			scn->characters().insert(c->getName(), c);
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

Prompt* Game::getPrompt(QString id)
{
	return this->scenario->prompts().value(id);
}

void Game::addReply(Prompt *prompt, QString text, QString target)
{
	// todo: find better solution
	Reply* reply = new Reply;
	reply->setText(text);
	reply->setTarget(target);
	prompt->replies().append(reply);
}

QString Game::getCharacter(QString name)
{
	return this->scenario->characters().value(name)->getSprite();
}

QUrl Game::getScenariosFolder()
{
	return QUrl::fromLocalFile(QDir::currentPath() + "/scenarios");
}
