#ifndef PROFILE_HPP
#define PROFILE_HPP

#include <QObject>

class Profile : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString promptid READ promptid WRITE setPromptid NOTIFY promptidChanged)
public:
	explicit Profile(QObject *parent = nullptr);

	const QString& name() const;
	void setName(const QString& newName);

	const QString& promptid() const;
	void setPromptid(const QString& newPromptid);

signals:
	void nameChanged();
	void promptidChanged();

private:
	int id;
	QString m_name;
	QString m_promptid;
};

#endif // PROFILE_HPP
