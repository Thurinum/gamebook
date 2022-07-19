#include "scenario.hpp"
#include "utils.hpp"

#include <QFile>
#include <QUuid>
#include <QXmlStreamWriter>

void Scenario::create() const {
	QString path = Utils::scenarioPath(this->name());
	QFile	  file(path);

	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open scenario" << path << "for writing:" << file.errorString();
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(Utils::setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("scenario");
	writer.writeAttribute("name", this->name());
	writer.writeStartElement("characters");
	writer.writeEndElement();
	writer.writeStartElement("replytypes");
	writer.writeEndElement();
	writer.writeStartElement("prompts");
	writer.writeStartElement("prompt");
	writer.writeAttribute("id", "0");
	writer.writeAttribute("text", Utils::setting("Main/sPromptTextPlaceholder").toString());
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndDocument();

	file.close();
}

bool Scenario::load() {
	QString path = Utils::scenarioPath(this->name());
	QFile	  file(path);

	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open scenario" << path << "for reading:" << file.errorString();
		return false;
	}

	QXmlStreamReader reader(&file);
	Prompt*	     current = nullptr;
	reader.readNextStartElement(); // scenario

	while (!reader.atEnd()) {
		reader.readNextStartElement();
		QString name = reader.name().toString();

		if (name == "prompt") {
			QString id = reader.attributes().value("id").toString();

			if (id == "")
				continue;

			Prompt* p = new Prompt(this);

			p->setId(id);
			p->setParentId(reader.attributes().value("parentid").toString());
			p->setText(reader.attributes().value("text").toString());
			p->setCharacter(reader.attributes().value("character").toString());
			p->setBackground(reader.attributes().value("background").toString());
			p->setIsEnd(reader.attributes().value("isend").toString() == "true");

			this->prompts().insert(id, p);
			current = p;
		} else if (current && name == "reply") {
			Reply* r = new Reply(this);
			r->setTarget(reader.attributes().value("target").toString());
			r->setText(reader.attributes().value("text").toString());
			if (reader.isStartElement())
				current->replies().append(r);
		} else if (name == "replytype") {
			// TODO: Implement reply types
		} else if (name == "character") {
			Character* c    = new Character(this);
			QString    name = reader.attributes().value("name").toString();

			if (name == "")
				continue;

			c->setName(name);
			c->setSprite(reader.attributes().value("sprite").toString());
			this->characters().insert(c->getName(), c);
		}
	}

	file.close();
	return true;
}

void Scenario::save() {
	QString path = Utils::scenarioPath(this->name());
	QFile	  file(path);

	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open scenario for reading: " << file.errorString() << ".";
		return;
	}

	QXmlStreamWriter writer(&file);
	writer.setAutoFormatting(true);
	writer.setAutoFormattingIndent(Utils::setting("Main/iXmlIndent").toInt());

	writer.writeStartDocument();
	writer.writeStartElement("scenario");
	writer.writeAttribute("name", this->name());
	writer.writeStartElement("characters");
	foreach (Character* c, this->characters()) {
		writer.writeStartElement("character");
		writer.writeAttribute("name", c->getName());
		writer.writeAttribute("sprite", c->getSprite());
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeStartElement("replytypes");
	foreach (ReplyType* r, this->replyTypes()) {
		writer.writeStartElement("replytype");
		writer.writeAttribute("color", r->color());
		writer.writeAttribute("icon", r->icon());
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeStartElement("prompts");
	foreach (Prompt* p, this->prompts()) {
		if (p->id() == "")
			continue;
		writer.writeStartElement("prompt");
		writer.writeAttribute("id", p->id());
		writer.writeAttribute("parentid", p->parentId());
		writer.writeAttribute("text", p->text());
		writer.writeAttribute("character", p->character());
		writer.writeAttribute("background", p->background());
		writer.writeAttribute("isend", p->isEnd() ? "true" : "false");
		foreach (Reply* r, p->replies()) {
			writer.writeStartElement("reply");
			writer.writeAttribute("text", r->text());
			writer.writeAttribute("target", r->target());
			// writer.writeAttribute("type", )
			writer.writeEndElement();
		}
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndDocument();

	file.close();
}

void Scenario::nuke() const {
	QString path = Utils::scenarioFolder(this->name());
	QDir	  dir(path);

	if (!dir.exists()) {
		qWarning() << "Cannot delete non-existing scenario" << name() << ".\n\tPath:" << path;
		return;
	}

	dir.removeRecursively();
}

const QString& Scenario::name() const {
	return m_name;
}

void Scenario::setName(const QString& newName)
{
	if (m_name == newName)
		return;
	m_name = newName;
	emit nameChanged();
}

QHash<QString, Prompt*>& Scenario::prompts() {
	return m_prompts;
}

const QHash<QString, ReplyType*>& Scenario::replyTypes() const {
	return m_replyTypes;
}

QHash<QString, Character*>& Scenario::characters() {
	return m_characters;
}

void Scenario::setCharacters(const QHash<QString, Character*>& newCharacters) {
	if (m_characters == newCharacters)
		return;
	m_characters = newCharacters;
	emit charactersChanged();
}

Scenario::Scenario() = default;

Scenario::Scenario(QString name) : m_name(std::move(name)) {
	m_id = QUuid::createUuid().toString(QUuid::WithoutBraces);
}
