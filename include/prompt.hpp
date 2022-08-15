#ifndef PROMPT_HPP
#define PROMPT_HPP

#include "reply.hpp"

#include <QColor>
#include <QDebug>
#include <QList>
#include <QObject>
#include <QString>

class Reply;

class Prompt : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
	Q_PROPERTY(QString parentId READ parentId WRITE setParentId NOTIFY parentIdChanged)
	Q_PROPERTY(QString targetId READ targetId WRITE setTargetId NOTIFY targetIdChanged)
	Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
	Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
	Q_PROPERTY(QString characterId READ characterId WRITE setCharacterId NOTIFY characterIdChanged)
	Q_PROPERTY(QString background READ background WRITE setBackground NOTIFY backgroundChanged)
	Q_PROPERTY(QString music READ music WRITE setMusic NOTIFY musicChanged)
	Q_PROPERTY(bool isEnd READ isEnd WRITE setIsEnd NOTIFY isEndChanged)
	Q_PROPERTY(QList<Reply *> replies READ replies WRITE setReplies NOTIFY repliesChanged)

public:
	Prompt(QObject *parent = nullptr) : QObject(parent) {}

	const QString &id() const;
	void setId(const QString &newId);

	const QString &text() const;
	void setText(const QString &newText);

	const QString &characterId() const;
	void setCharacterId(const QString &newCharacter);

	const QString &background() const;
	void setBackground(const QString &newBackground);

	QList<Reply *> &replies();
	void setReplies(const QList<Reply *> &newReplies);

	bool isEnd() const;
	void setIsEnd(bool newIsEnd);

	const QString &parentId() const;
	void setParentId(const QString &newParentId);

	Q_INVOKABLE void addReply(const QString &text, QString target = nullptr);
	Q_INVOKABLE void moveReply(int index, int newIndex);
	Q_INVOKABLE void nukeReply(Reply *reply);

	const QString &targetId() const;
	void setTargetId(const QString &newTarget);

	const QString &music() const;
	void setMusic(const QString &newMusic);

	const QColor &color() const;
	void setColor(const QColor &newColor);

signals:
	void idChanged();
	void parentIdChanged();
	void targetIdChanged();
	void textChanged();
	void characterIdChanged();
	void backgroundChanged();
	void repliesChanged();
	void isEndChanged();
	void musicChanged();

	void colorChanged();

private:
	QString m_id;
	QString m_parentId;
	QString m_targetId;
	QString m_text = "";
	QColor m_color;
	QString m_characterId;
	QString m_background;
	QString m_music = "";
	bool m_isEnd = false;
	QList<Reply *> m_replies;
};

#endif // PROMPT_HPP
