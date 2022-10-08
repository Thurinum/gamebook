# Gamebook Studio
A fun little tool to create and play simple dialogue-tree based games.

![image](https://user-images.githubusercontent.com/43908636/184928170-599a84b4-be78-4e88-b7f5-12a82b0823ac.png)

## About
Gamebook Studio is a simple software for creating and parsing dialogue-tree based scenarios.  
It's the result of a few months of work as a personal project. While still incomplete, it incorporate all the base features that make it usable.

### Licensing
This software is licensed under GNU GPLv3.  
It's powered by the Qt framework, also under GPLv3.

### Running on Windows
Unzip the archive and run Gamebook.exe.
To access the dummy scenario, copy the Gamebook Studio Scenarios folder into your My Documents folder.
Config options are available inside gamebook.ini.

### Installing on Windows and Linux
- Install Qt 6.3 using the Online Installer.
- Open the project in Qt Creator.
- In the "Projects" tab, change the Run Configuration's Working Directory to %{ActiveProject:NativePath}
- Build and run, it should work fine (hopefully!).

## How it works
Scenarios hold *prompts*, which in turn contain *replies* that lead to other prompts.  

### Prompts
Prompts represent the text spoken by a character to the player. They are identified by an UUID and:
- Contain HTML-formatted text;
- Are associated with a character;
- May define a background;
- May specify a music track to start playing;
- May define an accent colour;
- May directly lead to another prompt, with no replies;
- May end the story.

### Replies
Replies lead to other prompts. They:
- Have an HTML-formatted label;
- Have a target (UUID of a prompt).

## Features
In this alpha release, all essential features are available and ready for use. These include:

- Creating and editing scenarios;
- Playing existing scenarios;
- Saving user progress;
- Manually importing custom assets, such as character sprites, backgrounds, and music tracks;
- Editing prompts and replies, re-ordering replies;
- Creating and editing characters;
- Visualizing and filtering prompts in an outline view;
- Batch-editing prompts.
