#include "character.hpp"

Character::Character(QObject *parent) : QObject{parent} {}

const QString &Character::id() const
{
	return m_id;
}

void Character::setId(const QString &newId)
{
	if (m_id == newId)
		return;
	m_id = newId;
	emit idChanged();
}

const QString &Character::getName() const
{
	return name;
}

void Character::setName(const QString &newName)
{
	if (name == newName)
		return;
	name = newName;
	emit nameChanged();
}

const QString &Character::getSprite() const
{
	return sprite;
}

void Character::setSprite(const QString &newSprite)
{
	if (sprite == newSprite)
		return;
	sprite = newSprite;
	emit spriteChanged();
}
