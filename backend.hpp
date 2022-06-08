#ifndef BACKEND_HPP
#define BACKEND_HPP

#include "profile.hpp"
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

	Q_INVOKABLE QUrl getScenariosFolder();
	Q_INVOKABLE void createScenario(QString name);
	Q_INVOKABLE void createScenarioProfile(QString name);
	Q_INVOKABLE void loadScenario(QString name);
	Q_INVOKABLE void loadScenarioProfile(QString name);

	Q_INVOKABLE Prompt* getPrompt(QString id);
	Q_INVOKABLE void addReply(Prompt* prompt, QString text, QString target);
	Q_INVOKABLE QString getCharacter(QString name);
	Q_INVOKABLE QList<QString> getCharacterNames();

	// helpers
	static inline QString getScenarioPath(QString name);
	static inline QString getProfilePath(QString scnname, QString name);

	Game();

signals:

private:
	QSettings* settings;
	Scenario* scenario;
	Profile* profile;
};

#endif // BACKEND_HPP
