#ifndef BACKEND_HPP
#define BACKEND_HPP

#include "scenario.hpp"

#include <QObject>
#include <QSettings>
#include <QUrl>
#include <QVariant>

class Game : public QObject
{
	Q_OBJECT
public:
	Q_INVOKABLE QVariant setting(QString key);
	Q_INVOKABLE void setSetting(QString key, QVariant val);

	Q_INVOKABLE void createScenario(QString name);

	Q_INVOKABLE QUrl getScenariosFolder();

	Q_INVOKABLE Prompt* getPrompt(QString key);

	Game();

private:
	QSettings* settings;
	Scenario* currentScenario;
};

#endif // BACKEND_HPP
