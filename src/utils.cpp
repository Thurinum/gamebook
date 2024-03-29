#include "utils.hpp"

#include <QStandardPaths>

const QString Utils::INI_FILE_LOCATION = QDir::currentPath() + "/gamebook.ini";
const QString Utils::CHARACTERS_PATH   = "assets/characters/";
const QString Utils::BACKGROUNDS_PATH  = "assets/backgrounds/";
const QString Utils::MUSIC_PATH	   = "assets/music/";
const QString Utils::SAVES_PATH	   = "saves/";

QVariant Utils::setting(const QString& key, const QVariant& fallback) {
	QSettings settings(INI_FILE_LOCATION, QSettings::IniFormat);

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

QString Utils::rootPath() {
	return QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/"
		 + Utils::setting("Main/sApplicationName").toString() + " Scenarios/";
}

QString Utils::scenarioFolder(const QString& scenarioName) {
	QString path = rootPath() + scenarioName + "/";
	QDir	  dir;

	// if scenario folder not created yet, make all appropriate paths
	// because QFile cannot create folders and expects them to exist
	if (!dir.exists(path)) {
		dir.mkpath(path);
		dir.mkpath(path + SAVES_PATH);
		dir.mkpath(path + CHARACTERS_PATH);
		dir.mkpath(path + BACKGROUNDS_PATH);
		dir.mkpath(path + MUSIC_PATH);
	}

	return path;
}

QString Utils::scenarioPath(const QString& scenarioName) {
	return scenarioFolder(scenarioName) + scenarioName + ".scenario";
}

QString Utils::scenarioSavePath(const QString& scenarioName, const QString& profileName) {
	return scenarioFolder(scenarioName) + SAVES_PATH + profileName + ".save";
}
