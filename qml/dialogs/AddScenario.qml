import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel

Dialog {
	id: dialog_addScenario
	title: "New Scenario"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	height: 300

	property alias name: dialog_addScenario_text.text

	Label {
		text: "Scenario name"
		TextField {
			id: dialog_addScenario_text
			width: dialog_addScenario.availableWidth
			anchors.top: parent.bottom
		}
	}

	onAccepted: {
		Game.createScenario(name)
	}
}
