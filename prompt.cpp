#include "prompt.hpp"

const QString& Prompt::id() const
{
	return m_id;
}
void Prompt::setId(const QString& newId)
{
	if (m_id == newId)
		return;
	m_id = newId;
	emit idChanged();
}

const QString& Prompt::text() const
{
	return m_text;
}
void Prompt::setText(const QString& newText)
{
	if (m_text == newText)
		return;
	m_text = newText;
	emit textChanged();
}

const QString& Prompt::characterPath() const
{
	return m_characterPath;
}
void Prompt::setCharacterPath(const QString& newCharacterPath)
{
	if (m_characterPath == newCharacterPath)
		return;
	m_characterPath = newCharacterPath;
	emit characterPathChanged();
}

const QString& Prompt::backgroundPath() const
{
	return m_backgroundPath;
}
void Prompt::setBackgroundPath(const QString& newBackgroundPath)
{
	if (m_backgroundPath == newBackgroundPath)
		return;
	m_backgroundPath = newBackgroundPath;
	emit backgroundPathChanged();
}

QList<Reply*>& Prompt::replies()
{
	return m_replies;
}
void Prompt::setReplies(const QList<Reply*>& newReplies)
{
	if (m_replies == newReplies)
		return;
	m_replies = newReplies;
	emit repliesChanged();
}
