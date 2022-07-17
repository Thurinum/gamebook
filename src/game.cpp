#include "game.hpp"
#include "profile.hpp"
#include "prompt.hpp"
#include "scenario.hpp"
#include <QQmlContext>

#include <QDir>
#include <QGuiApplication>
#include <QHash>
#include <QQmlApplicationEngine>
#include <QUrl>
#include <QUuid>
#include <QXmlStreamReader>

QString Game::getScenarioName() {
	return m_scenario ? m_scenario->name() : "none";
}

void Game::createScenario(const QString& name) {
	m_scenario = new Scenario(name);
	m_scenario->create();
}

void Game::loadScenario(const QString& name) {
	m_scenario = new Scenario(name);
	m_scenario->load();
}

void Game::saveScenario() {
	if (!m_scenario) {
		qWarning() << "Cannot save scenario since no scenario is currently opened!";
		return;
	}

	m_scenario->save();
}

void Game::deleteScenario(const QString& name) {
	m_scenario = new Scenario(name);
	m_scenario->nuke();
}

// --------------------------------------------------------------------------------------

Profile* Game::getScenarioProfile() {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to access profile before scenario";
		return nullptr;
	}

	if (this->m_profile == nullptr) {
		qWarning() << "Tried to access profile but none exists.";
		return nullptr;
	}

	return this->m_profile;
}

void Game::createScenarioProfile(const QString& name) {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to create profile before scenario";
		return;
	}

	m_profile = new Profile(name, m_scenario);
	m_profile->create();
}

void Game::loadScenarioProfile(const QString& name) {
	if (!m_scenario) {
		qWarning() << "Tried to load profile before scenario.";
		return;
	}

	m_profile = new Profile(name, m_scenario);
	m_profile->load();
}

void Game::saveScenarioProfile() {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to save profile before scenario";
		return;
	}

	if (m_profile == nullptr) {
		qWarning() << "There is no current profile! Cannot save.";
		return;
	}

	m_profile->save();
}

// --------------------------------------------------------------------------------------

Prompt* Game::parentPromptOf(Prompt* prompt) {
	return m_scenario->prompts().value(prompt->parentId());
}

bool Game::addPrompt(const QString& id, Prompt* parent) {
	if (m_scenario->prompts().contains(id)) {
		qWarning() << "Prompt already exists with key '" << id << "'.";
		return false;
	}

	Prompt* p = new Prompt(this);
	p->setId(id);
	p->setParentId(parent->id());
	p->setText("(NEW PROMPT)");
	p->setCharacter("");
	p->setBackground("");
	p->setReplies(QList<Reply*>());
	p->setIsEnd(false);

	m_scenario->prompts().insert(id, p);
	return true;
}

void Game::addReply(Prompt* prompt, const QString& text, QString target) {
	prompt->addReply(text, target);
	addPrompt(target, prompt);
}

// --------------------------------------------------------------------------------------

Character* Game::getCharacter(const QString& name) {
	auto* characters = &m_scenario->characters();

	if (!characters->contains(name))
		qWarning() << "No character " << name;

	return characters->value(name);
}

QList<Character*> Game::getCharacters() {
	return m_scenario->characters().values();
}

void Game::addCharacter(const QString& name, const QString& sprite) {
	auto*	     characters = &m_scenario->characters();
	Character* c	    = new Character();

	c->setName(name);
	c->setSprite(sprite);
	characters->insert(name, c);
}

void Game::removeCharacter(const QString& name) {
	auto* characters = &m_scenario->characters();

	if (!characters->contains(name)) {
		qWarning() << "No character " << name;
		return;
	}

	characters->remove(name);
}

// helpers
// --------------------------------------------------------------------------------------

QVariant Game::setting(const QString& key) {
	return m_settings->value(key);
}

void Game::setSetting(const QString& key, const QVariant& val) {
	m_settings->setValue(key, val);
}

// --------------------------------------------------------------------------------------

QUrl Game::getAbsolutePath() {
	return QUrl::fromLocalFile(QDir::currentPath());
}

QUrl Game::getPath(const QString& resourcePath, const QString& fallbackPath) {
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

QString Game::getProfilePath(const QString& scnname, const QString& name) {
	return "scenarios/" + scnname + "-" + name + ".save";
}

QUrl Game::getScenariosFolder() {
	return QUrl::fromLocalFile(QDir::currentPath() + "/scenarios");
}

// accessors
// --------------------------------------------------------------------------------------

Prompt* Game::currentPrompt() {
	return m_currentPrompt;
}

void Game::setCurrentPrompt(const QString& id) {
	Prompt* newCurrentPrompt = m_scenario->prompts().value(id);

	if (m_currentPrompt == newCurrentPrompt)
		return;

	m_currentPrompt = newCurrentPrompt;
	emit currentPromptChanged();
}
