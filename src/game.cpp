#include "game.hpp"
#include "profile.hpp"
#include "prompt.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QGuiApplication>
#include <QHash>
#include <QUrl>
#include <QUuid>
#include <QXmlStreamReader>

Game::Game() : scenario(new Scenario), profile(new Profile) {
	settings = new QSettings(QDir::currentPath() + "/gamebook.ini", QSettings::IniFormat);
}

void Game::createScenario(const QString& name) {
	QFile file(Game::getScenarioPath(name));
	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open file for writing";
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("scenario");
	writer.writeAttribute("name", name);
	writer.writeStartElement("characters");
	writer.writeEndElement();
	writer.writeStartElement("replytypes");
	writer.writeEndElement();
	writer.writeStartElement("prompts");
	writer.writeStartElement("prompt");
	writer.writeAttribute("id", "0");
	writer.writeAttribute("text", "(Right-click on this prompt to start editing)");
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndDocument();
	file.close();
}

void Game::createScenarioProfile(const QString& name) {
	if (this->scenario == nullptr) {
		qWarning() << "Tried to create profile before scenario";
		return;
	}

	QFile file(Game::getProfilePath(this->scenario->name(), name));
	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open file for writing";
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("profile");
	writer.writeAttribute("name", name);
	writer.writeAttribute("progress", "0");
	writer.writeEndElement();
	writer.writeEndDocument();
	file.close();
}

void Game::loadScenario(const QString& name) {
	Scenario* scn = new Scenario();
	scn->setName(name);

	QFile file(Game::getScenarioPath(name));
	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open file for reading";
		return;
	}

	QXmlStreamReader reader(&file);
	Prompt*	     p = nullptr;
	reader.readNextStartElement(); // scenario

	while (!reader.atEnd()) {
		reader.readNextStartElement();
		QString name = reader.name().toString();

		if (name == "prompt") {
			p	     = new Prompt();
			QString id = reader.attributes().value("id").toString();
			p->setId(id);
			p->setText(reader.attributes().value("text").toString());
			p->setCharacter(reader.attributes().value("character").toString());
			p->setBackground(reader.attributes().value("background").toString());
			p->setIsEnd(reader.attributes().value("isend").toString() == "true");
			scn->prompts().insert(id, p);
		} else if (p && name == "reply") {
			Reply* r = new Reply();
			r->setTarget(reader.attributes().value("target").toString());
			r->setText(reader.attributes().value("text").toString());
			if (reader.isStartElement())
				p->replies().append(r);
		} else if (name == "replytype") {
			// TODO: Implement reply types
		} else if (name == "character") {
			Character* c    = new Character;
			QString    name = reader.attributes().value("name").toString();

			if (name == "")
				continue;

			c->setName(name);
			c->setSprite(reader.attributes().value("sprite").toString());
			scn->characters().insert(c->getName(), c);
		}
	}

	file.close();
	this->scenario = scn;
}

void Game::loadScenarioProfile(const QString& name) {
	Profile* profile = new Profile;

	if (!this->scenario) {
		qWarning() << "Tried to load profile before scenario";
		delete profile;
		return;
	}

	QFile file(Game::getProfilePath(this->scenario->name(), name));
	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open file for writing";
		delete profile;
		return;
	}

	QXmlStreamReader reader(&file);
	reader.readNextStartElement(); // profile
	profile->setName(name);
	profile->setPromptid(reader.attributes().value("progress").toString());

	file.close();
	this->profile = profile;
}

void Game::saveScenario() {
	if (!this->scenario) {
		qWarning() << "Cannot save scenario since no scenario is currently opened!";
		return;
	}

	QFile file(Game::getScenarioPath(scenario->name()));
	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open file for reading";
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("scenario");
	writer.writeAttribute("name", scenario->name());
	writer.writeStartElement("characters");
	foreach (Character* c, scenario->characters()) {
		writer.writeStartElement("character");
		writer.writeAttribute("name", c->getName());
		writer.writeAttribute("sprite", c->getSprite());
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeStartElement("replytypes");
	foreach (ReplyType* r, scenario->replyTypes()) {
		writer.writeStartElement("replytype");
		writer.writeAttribute("color", r->color());
		writer.writeAttribute("icon", r->icon());
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeStartElement("prompts");
	foreach (Prompt* p, scenario->prompts()) {
		writer.writeStartElement("prompt");
		writer.writeAttribute("id", p->id());
		writer.writeAttribute("text", p->text());
		writer.writeAttribute("character", p->character());
		writer.writeAttribute("background", p->background());
		writer.writeAttribute("isend", p->isEnd() ? "true" : "false");
		foreach (Reply* r, p->replies()) {
			writer.writeStartElement("reply");
			writer.writeAttribute("text", r->text());
			writer.writeAttribute("target", r->target());
			// writer.writeAttribute("type" TODO: Add reply types
			writer.writeEndElement();
		}
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndDocument();

	file.close();
}

void Game::deleteScenario(const QString& name) {
	QString path = getScenarioPath(name);

	if (!QFile::exists(path)) {
		qWarning() << "Cannot delete non-existing scenario " + name + ".";
		return;
	}

	QFile::remove(path);
}

Prompt* Game::getPrompt(const QString& id) {
	return this->scenario->prompts().value(id);
}

bool Game::addPrompt(const QString& id, Prompt* parent) {
	if (this->scenario->prompts().contains(id)) {
		qWarning() << "Prompt already exists with key '" << id << "'.";
		return false;
	}

	Prompt* p = new Prompt;
	p->setId(id);
	p->setParent(parent);
	p->setText("");
	p->setIsEnd(false);

	this->scenario->prompts()[id] = p;
	return true;
}

void Game::addReply(Prompt* prompt, const QString& text, QString target) {
	if (target == nullptr)
		target = QUuid::createUuid().toString();

	Reply* reply = new Reply;
	reply->setText(text);
	reply->setTarget(target);
	prompt->replies().append(reply);

	addPrompt(target, prompt);
}

Character* Game::getCharacter(const QString& name) {
	auto characters = &this->scenario->characters();

	if (!characters->contains(name))
		qWarning() << "No character " << name;

	return characters->value(name);
}

void Game::addCharacter(const QString& name, const QString& sprite) {
	auto	     characters = &this->scenario->characters();
	Character* c	    = new Character();

	c->setName(name);
	c->setSprite(sprite);
	characters->insert(name, c);
}

void Game::removeCharacter(const QString& name) {
	auto characters = &this->scenario->characters();

	if (!characters->contains(name)) {
		qWarning() << "No character " << name;
		return;
	}

	characters->remove(name);
}

QList<Character*> Game::getCharacters() {
	return this->scenario->characters().values();
}

QVariant Game::setting(const QString& key) {
	return this->settings->value(key);
}

void Game::setSetting(const QString& key, const QVariant& val) {
	settings->setValue(key, val);
}

QUrl Game::getAbsolutePath() {
	return QUrl::fromLocalFile(QDir::currentPath());
}

QUrl Game::getPath(QString resourcePath, QString fallbackPath) {
	QString root = QDir::currentPath() + "/resources/";
	QString path = root + resourcePath;

	QFileInfo info(path);

	if (info.exists() && info.isFile())
		return QUrl::fromLocalFile(path);

	if (fallbackPath == "")
		return QUrl::fromLocalFile(root + setting("Main/sFallbackImage").toString());

	QString fallback = root + fallbackPath;

	if (!setting("Debug/bValidateFallbackPaths").toBool())
		return QUrl::fromLocalFile(fallback);

	info.setFile(fallback);

	if (info.exists() && info.isFile())
		return QUrl::fromLocalFile(fallback);

	qWarning() << "Fallback path " + fallback + " is invalid!";
	return QUrl::fromLocalFile(root + setting("Main/sFallbackImage").toString());
}

QUrl Game::getScenariosFolder() {
	return QUrl::fromLocalFile(QDir::currentPath() + "/scenarios");
}

QString Game::getScenarioPath(const QString& name) {
	return "scenarios/" + name + ".scenario";
}

QString Game::getProfilePath(const QString& scnname, const QString& name) {
	return "scenarios/" + scnname + "-" + name + ".save";
}
