#ifndef SCENARIO_HPP
#define SCENARIO_HPP

#include "reply.hpp"

#include <QList>
#include <QDomDocument>



class Scenario
{
public:
	QString name;
	QList<Prompt*> prompts;

	Scenario(QString name);

	void save();

private:
	QDomDocument doc;
};

#endif // SCENARIO_HPP
