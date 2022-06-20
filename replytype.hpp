#ifndef REPLYTYPE_HPP
#define REPLYTYPE_HPP

#include <QObject>
#include <QString>

class ReplyType : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
	Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)
public:
	ReplyType();

	const QString& color() const;
	void setColor(const QString& newColor);

	const QString& icon() const;
	void setIcon(const QString& newIconPath);

signals:
	void colorChanged();
	void iconChanged();

private:
	QString m_color;
	QString m_icon;
};

#endif // REPLYTYPE_HPP
