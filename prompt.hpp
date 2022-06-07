#ifndef PROMPT_HPP
#define PROMPT_HPP

#include "reply.hpp"

#include <QList>
#include <QObject>
#include <QString>

class Reply;

class Prompt : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
	Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
	Q_PROPERTY(QString characterPath READ characterPath WRITE setCharacterPath NOTIFY characterPathChanged)
	Q_PROPERTY(QString backgroundPath READ backgroundPath WRITE setBackgroundPath NOTIFY backgroundPathChanged)
	Q_PROPERTY(QList<Reply*> replies READ replies WRITE setReplies NOTIFY repliesChanged)

public:
	const QString& id() const;
	void setId(const QString& newId);

	const QString& text() const;
	void setText(const QString& newText);

	const QString& characterPath() const;
	void setCharacterPath(const QString& newCharacterPath);

	const QString& backgroundPath() const;
	void setBackgroundPath(const QString& newBackgroundPath);

	QList<Reply*>& replies();
	void setReplies(const QList<Reply*>& newReplies);

signals:
	void idChanged();
	void textChanged();
	void characterPathChanged();
	void backgroundPathChanged();
	void repliesChanged();

private:
	QString m_id;
	QString m_text = "";
	QString m_characterPath;
	QString m_backgroundPath;
	QList<Reply*> m_replies;
};

#endif // PROMPT_HPP
