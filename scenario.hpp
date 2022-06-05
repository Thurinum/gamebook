#ifndef SCENARIO_HPP
#define SCENARIO_HPP

#include "reply.hpp"

#include <QDomDocument>
#include <QHash>


class Scenario
{
public:
	QString name;
	QHash<QString, Prompt*> prompts;

	Scenario(QString name);

	void save();

private:
	QDomDocument doc;
};

#endif // SCENARIO_HPP
