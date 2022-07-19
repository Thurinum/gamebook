#include "prompt.hpp"

#include <QUuid>

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

const QString& Prompt::character() const {
	return m_character;
}
void Prompt::setCharacter(const QString& newCharacter)
{
	if (m_character == newCharacter)
		return;
	m_character = newCharacter;
	emit characterChanged();
}

const QString& Prompt::background() const
{
	return m_background;
}
void Prompt::setBackground(const QString& newBackground)
{
	if (m_background == newBackground)
		return;
	m_background = newBackground;
	emit backgroundChanged();
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

bool Prompt::isEnd() const
{
	return m_isEnd;
}
void Prompt::setIsEnd(bool newIsEnd)
{
	if (m_isEnd == newIsEnd)
		return;
	m_isEnd = newIsEnd;
	emit isEndChanged();
}

const QString& Prompt::parentId() const {
	return m_parentId;
}

void Prompt::setParentId(const QString& newParentId) {
	if (m_parentId == newParentId)
		return;
	m_parentId = newParentId;
	emit parentIdChanged();
}

void Prompt::addReply(const QString& text, QString target) {
	Reply* reply = new Reply;
	reply->setText(text);
	reply->setTarget(target);
	this->replies().append(reply);
}

void Prompt::moveReply(int index, int newIndex) {
	this->replies().move(index, newIndex);
}

void Prompt::nukeReply(Reply* reply) {
	this->replies().removeOne(reply);
}
