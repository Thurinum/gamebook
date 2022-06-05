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

public:
	const QString& id() const;
	void setId(const QString& newId);

	const QString& text() const;
	void setText(const QString& newText);

signals:
	void idChanged();
	void textChanged();

private:
	QString m_id;

	QString m_text = "";
	QString m_characterPath;
	QString m_backgroundPath;

	QList<Reply*> m_replies;

	Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
};

#endif // PROMPT_HPP
