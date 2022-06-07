#ifndef SCENARIO_HPP
#define SCENARIO_HPP

#include "prompt.hpp"
#include "replytype.hpp"

#include <QHash>

class Scenario : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QHash<QString, Prompt*> prompts READ prompts NOTIFY promptsChanged)
	Q_PROPERTY(QHash<QString, ReplyType*> replyTypes READ replyTypes NOTIFY replyTypesChanged)

public:
	const QString& name() const;
	void setName(const QString& newName);

	QHash<QString, Prompt*>& prompts();
	const QHash<QString, ReplyType*>& replyTypes() const;

	Scenario();

signals:
	void nameChanged();
	void promptsChanged();
	void replyTypesChanged();

private:
	int id;
	QString m_name;
	QHash<QString, Prompt*> m_prompts;
	QHash<QString, ReplyType*> m_replyTypes;
};

#endif // SCENARIO_HPP
