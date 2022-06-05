#ifndef BACKEND_HPP
#define BACKEND_HPP

#include <QObject>
#include <QSettings>
#include <QUrl>
#include <QVariant>

class Backend : public QObject
{
	Q_OBJECT
public:
	Q_INVOKABLE QVariant setting(QString key);
	Q_INVOKABLE void setSetting(QString key, QVariant val);

	Q_INVOKABLE void createScenario(QString name);

	Q_INVOKABLE QUrl getScenariosFolder();

	Backend();

private:
	QSettings* settings;
};

#endif // BACKEND_HPP
