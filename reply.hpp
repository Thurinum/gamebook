#ifndef REPLY_HPP
#define REPLY_HPP

#include <QString>

class Prompt;

class Reply
{
public:
	QString text;
	Prompt* target;

	Reply();
};

#endif // REPLY_HPP
