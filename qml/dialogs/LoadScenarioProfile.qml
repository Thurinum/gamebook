import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel

Dialog {
	id: dialog_loadScenarioProfile
	title: "Load existing save"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	height: 300

	Label {
		text: "Save profile"

		ComboBox {
			id: dialog_loadScenarioProfile_name
			textRole: "fileBaseName"
			valueRole: "fileName"
			anchors.top: parent.bottom
			model: FolderListModel {
				// TODO: Remember last profile
				showDirs: false
				folder: Game.getScenariosFolder()
				nameFilters: [cbo_selectScenario.currentText + "*.save"]
			}
		}
	}

	onAccepted: {
		let name = dialog_loadScenarioProfile_name.currentText

		if (name.length === 0) {
			dialog_error.msg = "No scenario selected!"
			dialog_error.visible = true
			return
		}

		appmenu.height = 0
		Game.loadScenarioProfile(name)
	}
}
