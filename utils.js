// Replace all occurences of a string. Found on CodeGrepper.
function replaceAll(str, find, replace) {
	let escapedFind = find.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1")
	return str.replace(new RegExp(escapedFind, 'g'), replace)
}

// Expand any variables within a string. Variables start with @!
function parseStr(str) {
	let newstr = ""

	// TODO: Add per-scenario expansions directory
	newstr = replaceAll(str, "@!PLAYER", "PLAYERNAME")

	return newstr
}

// Start "typewriting" the prompt
function writePrompt(text) {
	prompter.stop()
	prompter.i = 0
	prompt.text = ""
	prompter.text = text
	prompter.start()
}

// Displays a prompt and its replies on the UI.
function displayPrompt(id) {
	let prompt = Game.getPrompt(id)

	if (!prompt) {
		Game.addPrompt((parseInt(id) + 1).toString())
	}

	console.log(prompt.isEnd)
	if (prompt.isEnd) {
		endscreen.text = prompt.text
		endscreen.scale = 1
		return
	}

	app.currentPrompt = prompt
	writePrompt(prompt.text)
}
