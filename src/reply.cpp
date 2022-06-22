#include "reply.hpp"

Reply::Reply(QObject* parent) : QObject{parent} {}

const QString& Reply::text() const
{
	return m_text;
}
void Reply::setText(const QString& newText)
{
	if (m_text == newText)
		return;
	m_text = newText;
	emit textChanged();
}

const QString& Reply::target() const
{
	return m_target;
}
void Reply::setTarget(const QString& newTarget)
{
	if (m_target == newTarget)
		return;
	m_target = newTarget;
	emit targetChanged();
}
