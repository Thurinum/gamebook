#include "utils.hpp"

QVariant Utils::setting(const QString& key, const QVariant& fallback) {
	QSettings settings(QDir::currentPath() + "/gamebook.ini", QSettings::IniFormat);

	if (!settings.contains(key)) {
		qWarning() << "Attempt to access invalid setting" << key;
		return fallback;
	}
	return settings.value(key);
}

void Utils::setSetting(const QString& key, const QVariant& val) {
	QSettings settings(QDir::currentPath() + "/gamebook.ini", QSettings::IniFormat);
	settings.setValue(key, val);
}
