#include "profile.hpp"
#include "utils.hpp"
#include <QDebug>

#include <QDir>
#include <QFile>
#include <QXmlStreamWriter>

Profile::Profile(QString name, Scenario* scenario, QObject* parent)
	: QObject{parent}, m_name(std::move(name)), m_scenario(scenario) {}

void Profile::create() const {
	QString path = Utils::scenarioSavePath(this->scenario()->name(), this->name());
	QFile	  file(path);

	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open profile" << path << "for writing:" << file.errorString();
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(Utils::setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("profile");
	writer.writeAttribute("name", name());
	writer.writeAttribute("scenario", this->scenario()->name());
	writer.writeAttribute("progress", "0");
	writer.writeEndElement();
	writer.writeEndDocument();
	file.close();
}

bool Profile::load() {
	QString path = Utils::scenarioSavePath(this->scenario()->name(), this->name());
	QFile	  file(path);

	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open profile" << path << "for reading:" << file.errorString();
		return false;
	}

	QXmlStreamReader reader(&file);
	reader.readNextStartElement(); // profile

	QString scenarioName = reader.attributes().value("scenario").toString();

	if (scenarioName != this->scenario()->name()) {
		qWarning() << "Cannot load profile " << this->name() << " because it is incompatible with scenario "
			     << scenarioName << ".";
		return false;
	}

	this->setName(reader.attributes().value("name").toString());
	this->setPromptid(reader.attributes().value("progress").toString());

	file.close();
	return true;
}

void Profile::save() const {
	QString path = Utils::scenarioSavePath(this->scenario()->name(), this->name());
	QFile	  file(path);
	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open profile" << path << "for writing:" << file.errorString();
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(Utils::setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("profile");
	writer.writeAttribute("name", this->name());
	writer.writeAttribute("scenario", this->scenario()->name());
	writer.writeAttribute("progress", this->promptid());
	writer.writeEndElement();
	writer.writeEndDocument();
	file.close();
}

void Profile::nuke() {}

const QString& Profile::name() const {
	return m_name;
}
void Profile::setName(const QString& newName) {
	if (m_name == newName)
		return;
	m_name = newName;
	emit nameChanged();
}

Scenario* Profile::scenario() const {
	return m_scenario;
}

void Profile::setScenario(Scenario* newScenario) {
	m_scenario = newScenario;
}

const QString& Profile::promptid() const {
	return m_promptid;
}
void Profile::setPromptid(const QString& newPromptid) {
	if (m_promptid == newPromptid)
		return;
	m_promptid = newPromptid;
	emit promptidChanged();
}
