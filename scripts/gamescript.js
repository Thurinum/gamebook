// Gets a subfolder relative to the current scenario's folder
function scenarioSubFolder(path, asUrl = true) {
	return Game.scenarioFolder(asUrl) + path;
}

// Replace all occurences of a string. Found on CodeGrepper.
function replaceAll(str, find, replace) {
	let escapedFind = find.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1")
	return str.replace(new RegExp(escapedFind, 'g'), replace)
}

// Loads the scenario, then sets the appropriate paths for folderlist models
function loadScenario() {
	let text = scenarioNameField.currentText;
	if (text !== "") {
		Game.loadScenario(text)
		dialog_loadScenarioProfile.folder	= scenarioSubFolder("saves")
		edit_dialog.folder			= scenarioSubFolder("assets/characters")
		dialog_editPrompt.folder		= scenarioSubFolder("assets/backgrounds")
	}
}

// Expand any variables within a string. Variables start with @!
function parseStr(str) {
	let newstr = ""

	// TODO: Add per-scenario expansions directory
	newstr = replaceAll(str, "@!PLAYER", Game.playerName())

	return newstr
}

// Start "typewriting" the prompt
function writePrompt(text) {
	promptTimer.stop()
	promptTimer.i = 0
	prompt.text = ""
	promptTimer.text = text
	promptTimer.start()
}

// Displays a prompt and its replies on the UI.
function displayPrompt(id) {
	writePrompt("")
	repliesRepeater.model = []
	Game.setCurrentPrompt(id);

	if (Game.currentPrompt.isEnd && !app.isEditingAllowed) {
		endscreen.text = parseStr(Game.currentPrompt.text)
		endscreen.scale = 1
		return
	}

	repliesRepeater.model = Game.currentPrompt.replies
	writePrompt(parseStr(Game.currentPrompt.text));

	if (!app.isEditingAllowed)
		Game.saveScenarioProfile(id);
}
