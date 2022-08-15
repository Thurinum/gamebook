#include "scenario.hpp"
#include "utils.hpp"

#include <QFile>
#include <QUuid>
#include <QXmlStreamWriter>

void Scenario::create() const
{
	QString path = Utils::scenarioPath(this->name());
	QFile file(path);

	if (!file.open(QIODevice::WriteOnly)) {
		qCritical() << "Failed to open scenario" << path
				<< "for writing:" << file.errorString();
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

bool Scenario::load()
{
	QString path = Utils::scenarioPath(this->name());
	QFile file(path);

	if (!file.open(QIODevice::ReadOnly)) {
		qCritical() << "Failed to open scenario" << path
				<< "for reading:" << file.errorString();
		return false;
	}

	QXmlStreamReader reader(&file);
	Prompt* current = nullptr;
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
			p->setParentId(reader.attributes().value("parent-id").toString());
			p->setTargetId(reader.attributes().value("target-id").toString());
			p->setText(reader.attributes().value("text").toString());
			p->setColor(reader.attributes().value("color").toString());
			p->setCharacterId(reader.attributes().value("character-id").toString());
			p->setBackground(reader.attributes().value("background").toString());
			p->setMusic(reader.attributes().value("music").toString());
			p->setIsEnd(reader.attributes().value("is-end").toString() == "true");
			this->prompts().insert(id, p);
			current = p;
		} else if (current && name == "reply") {
			Reply* r = new Reply(this);
			r->setTarget(reader.attributes().value("target-id").toString());
			r->setText(reader.attributes().value("text").toString());
			if (reader.isStartElement())
				current->replies().append(r);
		} else if (name == "replytype") {
			// TODO: Implement reply types
		} else if (name == "character") {
			Character* c = new Character(this);
			QString id = reader.attributes().value("id").toString();

			if (id == "")
				continue;

			c->setId(id);
			c->setName(reader.attributes().value("name").toString());
			c->setSprite(reader.attributes().value("sprite").toString());
			this->characters().insert(id, c);
		}
	}

	file.close();
	return true;
}

void Scenario::save()
{
	QString path = Utils::scenarioPath(this->name());
	QFile file(path);

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
		writer.writeAttribute("id", c->id());
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
		writer.writeAttribute("parent-id", p->parentId());
		writer.writeAttribute("target-id", p->targetId());
		writer.writeAttribute("text", p->text());
		writer.writeAttribute("color", p->color().name(QColor::NameFormat::HexRgb));
		writer.writeAttribute("character-id", p->characterId());
		writer.writeAttribute("background", p->background());
		writer.writeAttribute("music", p->music());
		writer.writeAttribute("is-end", p->isEnd() ? "true" : "false");
		foreach (Reply* r, p->replies()) {
			writer.writeStartElement("reply");
			writer.writeAttribute("text", r->text());
			writer.writeAttribute("target-id", r->target());
			writer.writeEndElement();
		}
		writer.writeEndElement();
	}
	writer.writeEndElement();
	writer.writeEndElement();
	writer.writeEndDocument();

	file.close();
}

void Scenario::nuke() const
{
	QString path = Utils::scenarioFolder(this->name());
	QDir dir(path);

	if (!dir.exists()) {
		qWarning() << "Cannot delete non-existing scenario" << name() << ".\n\tPath:" << path;
		return;
	}

	dir.removeRecursively();
}

const QString& Scenario::name() const
{
	return m_name;
}

void Scenario::setName(const QString& newName)
{
	if (m_name == newName)
		return;
	m_name = newName;
	emit nameChanged();
}

QHash<QString, Prompt*>& Scenario::prompts()
{
	return m_prompts;
}

const QHash<QString, ReplyType*>& Scenario::replyTypes() const
{
	return m_replyTypes;
}

QHash<QString, Character*>& Scenario::characters()
{
	return m_characters;
}

void Scenario::setCharacters(const QHash<QString, Character*>& newCharacters)
{
	if (m_characters == newCharacters)
		return;
	m_characters = newCharacters;
	emit charactersChanged();
}

Scenario::Scenario() = default;

Scenario::Scenario(QString name) : m_name(std::move(name))
{
	m_id = QUuid::createUuid().toString(QUuid::WithoutBraces);
}
