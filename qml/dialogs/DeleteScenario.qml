import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/utils.js" as Utils

Dialog {
	id: dialog_removeScenario
	width: 400
	height: 350
	title: "Delete scenario?"
	standardButtons: Dialog.Yes | Dialog.No
	anchors.centerIn: Overlay.overlay

	Label {
		text: "Are you sure you want to nuke scenario '" + cbo_selectScenario.currentText + "'."
	}

	onAccepted: Game.deleteScenario(cbo_selectScenario.currentText)
}
