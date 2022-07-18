import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript


Dialog {
	id: dialog_loadScenarioProfile
	title: "Load existing save"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	width: 400
	height: 200

	property alias folder: modellist.folder

	Label {
		text: "Save profile"

		ComboBox {
			id: dialog_loadScenarioProfile_name
			width: 300
			textRole: "fileBaseName"
			valueRole: "fileName"
			anchors.top: parent.bottom
			model: FolderListModel {
				id: modellist
				// TODO: Remember last profile
				showDirs: false
				folder: Game.scenarioSavesFolder()
				nameFilters: ["*.save"]
			}
		}
	}

	onAccepted: {
		let name = dialog_loadScenarioProfile_name.currentText

		Game.loadScenario(cbo_selectScenario.currentText)

		if (name.length === 0) {
			dialog_error.msg = "No profile selected!"
			dialog_error.visible = true
			return
		}

		if (Game.loadScenarioProfile(name) === false) {
			dialog_error.msg = "Failed to load profile!"
			dialog_error.visible = true
			return
		}

		GameScript.displayPrompt(Game.playerProgress())
		appmenu.height = 0
	}
}
