import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel

Dialog {
	id: dialog
	title: shouldDelete ? "Delete scenario" : "New scenario"
	standardButtons: shouldDelete ? Dialog.Yes | Dialog.No : Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	width: 500
	height: 200

	property bool shouldDelete: false

	Label {
		visible: !dialog.shouldDelete
		text: "Scenario name"

		TextField {
			id: _scenarioNameField
			width: dialog.availableWidth
			anchors.top: parent.bottom
		}
	}

	Label {
		visible: dialog.shouldDelete
		text: "Are you sure you want to nuke scenario '" + scenarioNameField.currentText + "'?"
	}

	onAccepted: {
		if (shouldDelete) {
			shouldDelete = false;
			Game.deleteScenario(scenarioNameField.currentText);
			scenarioProfileDialog.folder = ""; // prevent error
			scenarioNameField.currentIndex = 0;
			return;
		}

		Game.createScenario(_scenarioNameField.text);
	}
}
