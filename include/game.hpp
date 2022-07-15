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
	Q_INVOKABLE void createScenario(const QString& name);
	Q_INVOKABLE void createScenarioProfile(const QString& name);
	Q_INVOKABLE void loadScenario(const QString& name);
	Q_INVOKABLE void loadScenarioProfile(const QString& name);
	Q_INVOKABLE void saveScenario();
	Q_INVOKABLE void deleteScenario(const QString& name);

	Q_INVOKABLE Prompt* getPrompt(const QString& id);
	Q_INVOKABLE bool	  addPrompt(const QString& id, Prompt* parent);
	Q_INVOKABLE void	  addReply(Prompt* prompt, const QString& text, QString target = nullptr);

	Q_INVOKABLE Character* getCharacter(const QString& name);
	Q_INVOKABLE void	     addCharacter(const QString& name, const QString& sprite);
	Q_INVOKABLE void	     removeCharacter(const QString& name);
	Q_INVOKABLE QList<Character*> getCharacters();

	Q_INVOKABLE QVariant setting(const QString& key);
	Q_INVOKABLE void	   setSetting(const QString& key, const QVariant& val);

	// helpers
	Q_INVOKABLE QUrl	    getAbsolutePath();
	Q_INVOKABLE QUrl	    getPath(QString resourcePath, QString fallbackPath = "");
	Q_INVOKABLE QUrl	    getScenariosFolder();
	static inline QString getScenarioPath(const QString& name);
	static inline QString getProfilePath(const QString& scnname, const QString& name);

	Game();

private:
	Scenario*  scenario{};
	Profile*   profile{};
	QSettings* settings;
};

#endif // BACKEND_HPP
