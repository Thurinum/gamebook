#include "prompt.hpp"
#include "scenario.hpp"

#include <QFile>
#include <QXmlStreamWriter>

Scenario::Scenario(QString name)
{
	this->name = name;

	QString filename = "scenarios/" + this->name + ".scenario";
	QFile file(filename);
	QXmlStreamWriter writer(&file);

	if (!file.open(QIODevice::ReadWrite)) {
		qDebug("Could not open XML file to writing");
		return;
	}

	writer.writeStartDocument();
	writer.writeStartElement("scenario");
		writer.writeAttribute("name", name);
		writer.writeStartElement("prompt");
			writer.writeAttribute("id", "0");
		writer.writeEndElement();
	writer.writeEndDocument();
}

void Scenario::save()
{

}
