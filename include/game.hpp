#ifndef BACKEND_HPP
#define BACKEND_HPP

#include "profile.hpp"
#include "scenario.hpp"
#include "utils.hpp"

#include <QDir>
#include <QObject>
#include <QUrl>

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

	Q_INVOKABLE QString playerName();
	Q_INVOKABLE QString playerProgress();
	Q_INVOKABLE void	  loadScenarioProfile(const QString& name);
	Q_INVOKABLE void	  saveScenarioProfile(const QString& id);
	Q_INVOKABLE void	  createScenarioProfile(const QString& name);

	Q_INVOKABLE Prompt* parentPromptOf(Prompt* prompt);
	Q_INVOKABLE bool	  addPrompt(const QString& id, Prompt* parent);
	Q_INVOKABLE void	  addReply(Prompt* prompt, const QString& text, QString target = nullptr);

	Q_INVOKABLE Character* getCharacter(const QString& name);
	Q_INVOKABLE QList<Character*> getCharacters();
	Q_INVOKABLE void			addCharacter(const QString& name, const QString& sprite);
	Q_INVOKABLE void			removeCharacter(const QString& name);

	// helpers
	Q_INVOKABLE static QVariant setting(const QString& key, const QVariant& fallback = QVariant());
	Q_INVOKABLE static void	    setSetting(const QString& key, const QVariant& value);

	Q_INVOKABLE QUrl getAppResource(const QString& resourcePath, const QString& fallbackPath = "");
	Q_INVOKABLE QUrl defaultResourcesFolder();
	Q_INVOKABLE QUrl scenariosFolder();
	Q_INVOKABLE QUrl scenarioSavesFolder();
	Q_INVOKABLE QUrl scenarioCharactersFolder();
	Q_INVOKABLE QUrl scenarioBackgroundsFolder();

	// accessors
	Prompt*	     currentPrompt();
	Q_INVOKABLE void setCurrentPrompt(const QString& id);

	explicit Game()
		: m_scenario(new Scenario), m_profile(new Profile("dummy", m_scenario)),
		  m_currentPrompt(new Prompt(this)){};

signals:
	void currentPromptChanged();

private:
	Scenario* m_scenario;
	Profile*  m_profile;
	Prompt*   m_currentPrompt;
};

#endif // BACKEND_HPP
