#ifndef REPLY_HPP
#define REPLY_HPP

#include "replytype.hpp"

#include <QObject>
#include <QString>

class Prompt;

class Reply : public QObject
{
	Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(QString target READ target WRITE setTarget NOTIFY targetChanged)
public:
	explicit Reply(QObject* parent = nullptr);

	const QString& text() const;
	void		   setText(const QString& newText);

	const QString& target() const;
	void		   setTarget(const QString& newTarget);

signals:
	void textChanged();
	void targetChanged();

private:
	QString   m_text;
	QString   m_target;
	ReplyType m_type;
};

#endif // REPLY_HPP
