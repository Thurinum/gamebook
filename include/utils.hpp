#ifndef UTILS_HPP
#define UTILS_HPP

#include <QDir>
#include <QSettings>

class Utils
{
public:
	static const QString INI_FILE_LOCATION;
	static const QString SAVES_PATH;
	static const QString CHARACTERS_PATH;
	static const QString BACKGROUNDS_PATH;

	static QVariant setting(const QString& key, const QVariant& fallback = QVariant());
	static void	    setSetting(const QString& key, const QVariant& val);

	static QString rootPath();
	static QString scenarioFolder(const QString& scenarioName);
	static QString scenarioPath(const QString& scenarioName);
	static QString scenarioSavesFolder(const QString& scenarioName);
	static QString scenarioSavePath(const QString& scenarioName, const QString& profileName);
};

#endif // UTILS_HPP
