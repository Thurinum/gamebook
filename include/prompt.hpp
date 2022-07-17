#ifndef PROMPT_HPP
#define PROMPT_HPP

#include "reply.hpp"

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
	Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
	Q_PROPERTY(QString character READ character WRITE setCharacter NOTIFY characterChanged)
	Q_PROPERTY(QString background READ background WRITE setBackground NOTIFY backgroundChanged)
	Q_PROPERTY(bool isEnd READ isEnd WRITE setIsEnd NOTIFY isEndChanged)
	Q_PROPERTY(QList<Reply*> replies READ replies WRITE setReplies NOTIFY repliesChanged)

public:
	Prompt(QObject* parent = nullptr) : QObject(parent) {}

	const QString& id() const;
	void		   setId(const QString& newId);

	const QString& text() const;
	void		   setText(const QString& newText);

	const QString& character() const;
	void		   setCharacter(const QString& newCharacter);

	const QString& background() const;
	void		   setBackground(const QString& newBackground);

	QList<Reply*>& replies();
	void		   setReplies(const QList<Reply*>& newReplies);

	bool isEnd() const;
	void setIsEnd(bool newIsEnd);

	const QString& parentId() const;
	void		   setParentId(const QString& newParentId);

	Q_INVOKABLE void moveReply(int index, int newIndex);

signals:
	void idChanged();
	void textChanged();
	void characterChanged();
	void backgroundChanged();
	void repliesChanged();
	void isEndChanged();
	void parentIdChanged();

private:
	QString	  m_id;
	QString	  m_parentId;
	QString	  m_text = "";
	QString	  m_character;
	QString	  m_background;
	bool		  m_isEnd = false;
	QList<Reply*> m_replies;
};

#endif // PROMPT_HPP
