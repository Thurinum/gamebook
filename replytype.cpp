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

const QString& ReplyType::iconPath() const
{
	return m_iconPath;
}
void ReplyType::setIconPath(const QString& newIconPath)
{
	if (m_iconPath == newIconPath)
		return;
	m_iconPath = newIconPath;
	emit iconPathChanged();
}
