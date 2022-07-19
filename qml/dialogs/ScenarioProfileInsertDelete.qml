import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog
	title: "New profile"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay
	width: 400
	height: 300

	property bool shouldCreate: false
	property alias folder: nameFieldModel.folder

	Label {
		visible: dialog.shouldCreate
		text: "Player name"
		padding: 5

		TextField {
			id: createNameField
			width: 150
			anchors.top: parent.bottom
		}
	}

	Column {
		visible: !dialog.shouldCreate
		spacing: 6.9

		Label {
			text: "Choose save profile"
		}

		// TODO: experiment with grid?
		Row {
			spacing: 6.9

			ComboBox {
				id: nameField
				width: 300

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

			Button {
				text: "-"
				onClicked: {
					// TODO: add confirm dialog (connect signal?)
					Game.loadScenarioProfile(nameField.currentText)
					Game.deleteScenarioProfile()
				}
			}
		}

	}

	onAccepted: {
		// create profile?
		if (shouldCreate) {
			let name = createNameField.text

			if (name === "") {
				errorDialog.msg = "Please enter a profile name!";
				errorDialog.open();
				return;
			}


			if (Game.loadScenario(scenarioNameField.currentText) === false) {
				errorDialog.msg = "Failed to load scenario!";
				errorDialog.open();
				return;
			}

			Game.createScenarioProfile(name)

			if (Game.loadScenarioProfile(name) === false) {
				errorDialog.msg = "Failed to load profile!";
				errorDialog.open();
				return;
			}

			GameScript.displayPrompt("0");
			appMenu.height = 0;
			return;
		}

		// load profile
		let name = nameField.currentText

		Game.loadScenario(scenarioNameField.currentText)

		if (name.length === 0) {
			errorDialog.msg = "No profile selected!";
			errorDialog.open();
			return;
		}

		if (Game.loadScenarioProfile(name) === false) {
			errorDialog.msg = "Failed to load profile!";
			errorDialog.open();
			return;
		}

		GameScript.displayPrompt(Game.playerProgress());
		appMenu.height = 0;
	}
}
