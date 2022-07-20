#include "game.hpp"
#include "profile.hpp"
#include "prompt.hpp"
#include "scenario.hpp"
#include <QQmlContext>

#include <QDir>
#include <QGuiApplication>
#include <QHash>
#include <QQmlApplicationEngine>
#include <QStandardPaths>
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

QString Game::playerName() {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to access profile before scenario";
		return "Invalid";
	}

	if (this->m_profile == nullptr) {
		qWarning() << "Tried to access profile but none exists.";
		return "Dummy";
	}

	return this->m_profile->name();
}

QString Game::playerProgress() {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to access profile before scenario";
		return "Invalid";
	}

	if (this->m_profile == nullptr) {
		qWarning() << "Tried to access profile but none exists.";
		return "Dummy";
	}

	return this->m_profile->promptid();
}

void Game::createScenarioProfile(const QString& name) {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to create profile before scenario";
		return;
	}

	m_profile = new Profile(name, m_scenario);
	m_profile->create();
}

void Game::deleteScenarioProfile() {
	m_profile->nuke();
}

void Game::loadScenarioProfile(const QString& name) {
	if (!m_scenario) {
		qWarning() << "Tried to load profile before scenario.";
		return;
	}

	m_profile = new Profile(name, m_scenario);
	m_profile->load();
}

void Game::saveScenarioProfile(const QString& id) {
	if (m_scenario == nullptr) {
		qWarning() << "Tried to save profile before scenario";
		return;
	}

	if (m_profile == nullptr) {
		qWarning() << "There is no current profile! Cannot save.";
		return;
	}

	m_profile->setPromptid(id);
	m_profile->save();
}

// --------------------------------------------------------------------------------------

Prompt* Game::parentPromptOf(Prompt* prompt) {
	return m_scenario->prompts().value(prompt->parentId());
}

Prompt* Game::childPromptOf(const Reply*& reply) {
	const QString& target = reply->target();

	if (target == "" || !m_scenario->prompts().contains(target)) {
		return nullptr;
	}

	return m_scenario->prompts().value(target);
}

bool Game::addPrompt(const QString& id, Prompt* parent) {
	if (m_scenario->prompts().contains(id)) {
		qWarning() << "Prompt already exists with key '" << id << "'.";
		return false;
	}

	Prompt* p = new Prompt(this);
	p->setId(id);
	p->setParentId(parent->id());
	p->setText(Utils::setting("Main/sPromptTextPlaceholder").toString());
	p->setCharacter("");
	p->setBackground("");
	p->setReplies(QList<Reply*>());
	p->setIsEnd(false);

	m_scenario->prompts().insert(id, p);
	return true;
}

void Game::addReply(Prompt* prompt, const QString& text, QString target) {
	if (target == nullptr)
		target = QUuid::createUuid().toString(QUuid::WithoutBraces);

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

QVariant Game::setting(const QString& key, const QVariant& fallback) {
	return Utils::setting(key, fallback);
}
void Game::setSetting(const QString& key, const QVariant& value) {
	Utils::setSetting(key, value);
}

// --------------------------------------------------------------------------------------

QUrl Game::scenariosFolder() {
	return QUrl::fromLocalFile(Utils::rootPath());
}

QString Game::scenarioFolder(bool asUrl) {
	return (asUrl ? "file:///" : "") + Utils::scenarioFolder(m_scenario->name());
}

// --------------------------------------------------------------------------------------

QString Game::appResource(const QString& path, bool asUrl) {
	return (asUrl ? "file:///" : "") + QDir::currentPath() + "/resources/" + path;
}

QString Game::resource(QString& path, bool asUrl) {
	path = Utils::scenarioFolder(m_scenario->name()) + "assets/" + path;

	QFileInfo info(path);

	if (info.exists() && info.isFile())
		return (asUrl ? "file:///" : "") + path;

	return appResource(Utils::setting("Main/sFallbackImage").toString(), asUrl);
}

bool Game::hasPrompt(const QString& id) {
	return m_scenario->prompts().contains(id);
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
