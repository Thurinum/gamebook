#include "profile.hpp"

Profile::Profile(QObject* parent) : QObject{parent} {}

const QString& Profile::name() const
{
	return m_name;
}
void Profile::setName(const QString& newName)
{
	if (m_name == newName)
		return;
	m_name = newName;
	emit nameChanged();
}

const QString& Profile::promptid() const
{
	return m_promptid;
}
void Profile::setPromptid(const QString& newPromptid)
{
	if (m_promptid == newPromptid)
		return;
	m_promptid = newPromptid;
	emit promptidChanged();
}
