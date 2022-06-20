#include "replytype.hpp"

ReplyType::ReplyType()
{

}

const QString& ReplyType::color() const
{
	return m_color;
}
void ReplyType::setColor(const QString& newColor)
{
	if (m_color == newColor)
		return;
	m_color = newColor;
	emit colorChanged();
}

const QString& ReplyType::icon() const
{
	return m_icon;
}
void ReplyType::setIcon(const QString& newIconPath)
{
	if (m_icon == newIconPath)
		return;
	m_icon = newIconPath;
	emit iconChanged();
}
