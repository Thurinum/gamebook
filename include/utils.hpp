#ifndef UTILS_HPP
#define UTILS_HPP

#include <QDir>
#include <QSettings>

class Utils
{
public:
	static QVariant setting(const QString& key, const QVariant& fallback = QVariant());
	static void	    setSetting(const QString& key, const QVariant& val);
};

#endif // UTILS_HPP
