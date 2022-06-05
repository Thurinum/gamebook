#ifndef PROMPT_HPP
#define PROMPT_HPP

#include "reply.hpp"

#include <QList>
#include <QString>

class Reply;

class Prompt
{
public:
	int id;

	QString text;
	QString characterPath;
	QString backgroundPath;

	QList<Reply*> replies;

	Prompt();
};

#endif // PROMPT_HPP
