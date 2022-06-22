import QtQuick
import QtQuick.Controls
import "../../scripts/utils.js" as Utils

Dialog {
	id: dialog_addScenarioProfile
	title: "New profile"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	height: 300

	Label {
		text: "Player name"
		TextField {
			id: dialog_addScenarioProfile_text
			anchors.top: parent.bottom
		}
	}

	onAccepted: {
		let name = dialog_addScenarioProfile_text.text
		Game.loadScenario(cbo_selectScenario.currentText)
		Game.createScenarioProfile(name)
		Utils.displayPrompt("0")
		appmenu.height = 0
	}
}