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
