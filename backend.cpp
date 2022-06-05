#include "backend.hpp"
#include "prompt.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QGuiApplication>
#include <QUrl>

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
	this->currentScenario = new Scenario(name);
	Prompt* root = new Prompt();
	root->setId("0");
	root->setText("test test test");
	this->currentScenario->prompts["0"] = root;
}

QUrl Game::getScenariosFolder()
{
	return QUrl::fromLocalFile(QDir::currentPath() + "/scenarios");
}

Prompt* Game::getPrompt(QString key)
{
	Prompt *root = new Prompt();
	root->setId("0");
	root->setText("test test test");
	return root;
	//return currentScenario->prompts.value(key);
}
