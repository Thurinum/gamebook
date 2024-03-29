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

const QString& Prompt::parentId() const {
	return m_parentId;
}

void Prompt::setParentId(const QString& newParentId) {
	if (m_parentId == newParentId)
		return;
	m_parentId = newParentId;
	emit parentIdChanged();
}

const QString& Prompt::targetId() const {
	return m_targetId;
}

void Prompt::setTargetId(const QString& newTarget) {
	if (m_targetId == newTarget)
		return;
	m_targetId = newTarget;
	emit targetIdChanged();
}

const QString& Prompt::music() const {
	return m_music;
}

void Prompt::setMusic(const QString& newMusic) {
	if (m_music == newMusic)
		return;
	m_music = newMusic;
	emit musicChanged();
}

const QColor& Prompt::color() const
{
	return m_color;
}

void Prompt::setColor(const QColor& newColor)
{
	if (m_color == newColor)
		return;
	m_color = newColor;
	emit colorChanged();
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

const QString& Prompt::characterId() const {
	return m_characterId;
}
void Prompt::setCharacterId(const QString& newCharacter) {
	if (m_characterId == newCharacter)
		return;
	m_characterId = newCharacter;

	emit characterIdChanged();
}

const QString& Prompt::background() const
{
	return m_background;
}
void Prompt::setBackground(const QString& newBackground) {
	if (m_background == newBackground)
		return;
	m_background = newBackground;
	emit backgroundChanged();
}

QList<Reply*>& Prompt::replies()
{
	return m_replies;
}
void Prompt::setReplies(const QList<Reply*>& newReplies) {
	if (m_replies == newReplies)
		return;

	m_replies = newReplies;
	emit repliesChanged();
}

bool Prompt::isEnd() const
{
	return m_isEnd;
}
void Prompt::setIsEnd(bool newIsEnd) {
	if (m_isEnd == newIsEnd)
		return;
	m_isEnd = newIsEnd;
	emit isEndChanged();
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
