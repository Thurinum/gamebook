// Replace all occurences of a string. Found on CodeGrepper.
function replaceAll(str, find, replace) {
	let escapedFind = find.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
	return str.replace(new RegExp(escapedFind, 'g'), replace);
}

// Expand any variables within a string. Variables start with @!
function parseStr(str) {
	let newstr = "";

	// TODO: Add per-scenario expansions directory
	newstr = replaceAll(str, "@!PLAYER", profile.player);

	return newstr;
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
	app.currentPrompt = Game.getPrompt(id);
	console.log(app.currentPrompt.characterPath)
	writePrompt(app.currentPrompt.text);
}
