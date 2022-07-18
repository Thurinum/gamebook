import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog_removeScenario
	width: 300
	height: 250
	title: "Delete scenario?"
	standardButtons: Dialog.Yes | Dialog.No
	anchors.centerIn: Overlay.overlay

	Label {
		text: "Are you sure you want to nuke scenario '" + scenarioNameField.currentText + "'."
	}

	onAccepted: {
		Game.deleteScenario(scenarioNameField.currentText)
		dialog_loadScenarioProfile.folder = "" // prevent error
		scenarioNameField.currentIndex = 0
	}
}
