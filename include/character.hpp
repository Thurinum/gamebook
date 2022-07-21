#ifndef CHARACTER_HPP
#define CHARACTER_HPP

#include <QObject>

class Character : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QString id READ id WRITE setId NOTIFY idChanged)
	Q_PROPERTY(QString name READ getName WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString sprite READ getSprite WRITE setSprite NOTIFY spriteChanged)
public:
	explicit Character(QObject* parent = nullptr);

	const QString& getName() const;
	void		   setName(const QString& newName);

	const QString& getSprite() const;
	void		   setSprite(const QString& newSprite);

	const QString& id() const;
	void		   setId(const QString& newId);

signals:
	void nameChanged();
	void spriteChanged();

	void idChanged();

private:
	QString m_id;
	QString name;
	QString sprite;
};

#endif // CHARACTER_HPP
