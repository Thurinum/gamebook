#ifndef REPLYTYPE_HPP
#define REPLYTYPE_HPP

#include <QObject>
#include <QString>

class ReplyType : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
	Q_PROPERTY(QString iconPath READ iconPath WRITE setIconPath NOTIFY iconPathChanged)
public:
	ReplyType();

	const QString& color() const;
	void setColor(const QString& newColor);

	const QString& iconPath() const;
	void setIconPath(const QString& newIconPath);

signals:
	void colorChanged();
	void iconPathChanged();

private:
	QString m_color;
	QString m_iconPath;
};

#endif // REPLYTYPE_HPP
