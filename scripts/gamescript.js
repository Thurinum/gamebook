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
		scenarioProfileDialog.folder	= scenarioSubFolder("saves")
		characterDialog.folder		= scenarioSubFolder("assets/characters")
		promptDialog.folder		= scenarioSubFolder("assets/backgrounds")
		promptDialog.musicFolder	= scenarioSubFolder("assets/music")
	}
	app.title = "Gamebook Studio - " + Game.getScenarioName();
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
		endScreen.text = parseStr(Game.currentPrompt.text)
		endScreen.scale = 1
		return
	}

	repliesRepeater.model = Game.currentPrompt.replies
	writePrompt(parseStr(Game.currentPrompt.text));

	if (!app.isEditingAllowed)
		Game.saveScenarioProfile(id);

	if (Game.currentPrompt.music !== "") { // else play the old music
		music.source = Game.resource("music/" + Game.currentPrompt.music)
		music.play();
	}
}
