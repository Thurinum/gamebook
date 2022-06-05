// Replace all occurences of a string. Found on CodeGrepper.
function replaceAll(str, find, replace) {
	let escapedFind = find.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
	return str.replace(new RegExp(escapedFind, 'g'), replace);
}

// Expand any variables within a string. Variables start with @!
function parseStr(str) {
	let newstr = "";

	// TODO: Add per-scenario expansions directory
	newstr = replaceAll(str, "@!PLAYER", root.profile);

	return newstr;
}
