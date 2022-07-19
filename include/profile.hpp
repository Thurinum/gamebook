#ifndef PROFILE_HPP
#define PROFILE_HPP

#include "scenario.hpp"
#include <QObject>

class Profile : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString promptid READ promptid WRITE setPromptid NOTIFY promptidChanged)
public:
	explicit Profile(QString name, Scenario* scenario, QObject* parent = nullptr);

	void create() const;
	bool load();
	void save() const;
	void nuke() const;

	const QString& name() const;
	void		   setName(const QString& newName);

	const QString& promptid() const;
	void		   setPromptid(const QString& newPromptid);

	Scenario* scenario() const;
	void	    setScenario(Scenario* newScenario);

signals:
	void nameChanged();
	void promptidChanged();

private:
	QString   m_name;
	Scenario* m_scenario;
	QString   m_promptid;
};

#endif // PROFILE_HPP
