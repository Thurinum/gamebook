import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript


Dialog {
	id: dialog
	width: 400
	height: 200
	anchors.centerIn: Overlay.overlay

	title: "Load existing save"
	standardButtons: Dialog.Ok | Dialog.Cancel

	property alias folder: nameFieldModel.folder

	Label {
		text: "Save profile"

		ComboBox {
			id: nameField
			width: 300
			anchors.top: parent.bottom

			textRole: "fileBaseName"
			valueRole: "fileName"

			model: FolderListModel {
				id: nameFieldModel
				showDirs: false
				nameFilters: ["*.save"]
			}

			onActivated: {
				Game.setSetting("Main/sLastProfile", currentText)
			}

			Binding on currentIndex {
				value: {
					// idk what I'm doing wrong, but this statement
					// is required for the binding to work
					nameField.count

					let lastProfile = Game.setting("Main/sLastProfile");

					if (!lastProfile || lastProfile === "")
						return;

					let index = nameField.find(lastProfile);

					if (index === -1)
						return;

					nameField.currentIndex = index;
				}
			}
		}
	}

	onAccepted: {
		let name = nameField.currentText

		Game.loadScenario(scenarioNameField.currentText)

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
