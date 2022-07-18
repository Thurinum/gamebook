import QtQuick
import QtQuick.Controls
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog_addScenarioProfile
	title: "New profile"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	width: 200
	height: 300

	Label {
		text: "Player name"
		padding: 5
		TextField {
			id: dialog_addScenarioProfile_text
			width: 150
			anchors.top: parent.bottom
		}
	}

	onAccepted: {
		let name = dialog_addScenarioProfile_text.text

		if (Game.loadScenario(scenarioNameField.currentText) === false) {
			dialog_error.msg = "Failed to load scenario!"
			dialog_error.visible = true
			return
		}

		Game.createScenarioProfile(name)

		if (Game.loadScenarioProfile(name) === false) {
			dialog_error.msg = "Failed to load profile!"
			dialog_error.visible = true
			return
		}

		GameScript.displayPrompt("0")
		appmenu.height = 0
	}


}
