#ifndef SCENARIO_HPP
#define SCENARIO_HPP

#include "character.hpp"
#include "prompt.hpp"
#include "replytype.hpp"

#include <QDebug>
#include <QHash>

class Scenario : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QHash<QString, Prompt*> prompts READ prompts NOTIFY promptsChanged)
	Q_PROPERTY(QHash<QString, Character*> characters READ characters WRITE setCharacters NOTIFY charactersChanged)
	Q_PROPERTY(QHash<QString, ReplyType*> replyTypes READ replyTypes NOTIFY replyTypesChanged)

public:
	Scenario();
	explicit Scenario(QString name);

	void create() const;
	bool load();
	void save();
	void nuke() const;

	QHash<QString, Prompt*>&	    prompts();
	const QHash<QString, ReplyType*>& replyTypes() const;

	QHash<QString, Character*>& characters();
	void				    setCharacters(const QHash<QString, Character*>& newCharacters);

	const QString& name() const;
	void		   setName(const QString& newName);

signals:
	void nameChanged();
	void promptsChanged();
	void replyTypesChanged();
	void charactersChanged();

private:
	QString			   m_id;
	QString			   m_name;
	QHash<QString, Prompt*>	   m_prompts;
	QHash<QString, Character*> m_characters;
	QHash<QString, ReplyType*> m_replyTypes;
};

#endif // SCENARIO_HPP
