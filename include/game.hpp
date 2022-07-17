#ifndef BACKEND_HPP
#define BACKEND_HPP

#include "profile.hpp"
#include "scenario.hpp"

#include <QDir>
#include <QObject>
#include <QSettings>
#include <QUrl>
#include <QVariant>

class Game : public QObject
{
	Q_OBJECT
	Q_PROPERTY(Prompt* currentPrompt READ currentPrompt NOTIFY currentPromptChanged)
public:
	Q_INVOKABLE QString getScenarioName();
	Q_INVOKABLE void	  createScenario(const QString& name);
	Q_INVOKABLE void	  saveScenario();
	Q_INVOKABLE void	  loadScenario(const QString& name);
	Q_INVOKABLE void	  deleteScenario(const QString& name);

	Q_INVOKABLE QString  playerName();
	Q_INVOKABLE QString  playerProgress();
	Q_INVOKABLE void	   loadScenarioProfile(const QString& name);
	Q_INVOKABLE void	   saveScenarioProfile(const QString& id);
	Q_INVOKABLE void	   createScenarioProfile(const QString& name);

	Q_INVOKABLE Prompt* parentPromptOf(Prompt* prompt);
	Q_INVOKABLE bool	  addPrompt(const QString& id, Prompt* parent);
	Q_INVOKABLE void	  addReply(Prompt* prompt, const QString& text, QString target = nullptr);

	Q_INVOKABLE Character* getCharacter(const QString& name);
	Q_INVOKABLE QList<Character*> getCharacters();
	Q_INVOKABLE void			addCharacter(const QString& name, const QString& sprite);
	Q_INVOKABLE void			removeCharacter(const QString& name);

	// helpers
	Q_INVOKABLE QVariant setting(const QString& key);
	Q_INVOKABLE void	   setSetting(const QString& key, const QVariant& val);

	Q_INVOKABLE QUrl	    getAbsolutePath();
	Q_INVOKABLE QUrl	    getPath(const QString& resourcePath, const QString& fallbackPath = "");
	Q_INVOKABLE QUrl	    getAppFolder();

	// accessors
	Prompt*	     currentPrompt();
	Q_INVOKABLE void setCurrentPrompt(const QString& id);

	explicit Game()
		: m_scenario(new Scenario), m_profile(new Profile("dummy", m_scenario)),
		  m_settings(new QSettings(QDir::currentPath() + "/gamebook.ini", QSettings::IniFormat)),
		  m_currentPrompt(new Prompt(this)){};

signals:
	void currentPromptChanged();

private:
	Scenario*  m_scenario;
	Profile*   m_profile;
	QSettings* m_settings;
	Prompt*    m_currentPrompt;
};

#endif // BACKEND_HPP
