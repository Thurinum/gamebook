#include "prompt.hpp"
#include "scenario.hpp"

#include <QFile>
#include <QXmlStreamWriter>

const QString& Scenario::name() const
{
	return m_name;
}
void Scenario::setName(const QString& newName)
{
	if (m_name == newName)
		return;
	m_name = newName;
	emit nameChanged();
}

QHash<QString, Prompt*>& Scenario::prompts()
{
	return m_prompts;
}

const QHash<QString, ReplyType*>& Scenario::replyTypes() const
{
	return m_replyTypes;
}

Scenario::Scenario()
{
	this->id = 0; // TODO: Give scenarios a unique QUuid
}

QHash<QString, Character *> &Scenario::characters()
{
	return m_characters;
}

void Scenario::setCharacters(const QHash<QString, Character *> &newCharacters)
{
	if (m_characters == newCharacters)
		return;
	m_characters = newCharacters;
	emit charactersChanged();
}
