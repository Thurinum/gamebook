import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog

	width: 500
	height: 400
	title: "Edit characters"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property alias folder: character_image_model.folder

	ColumnLayout {
		anchors.fill: parent
		spacing: 25

		Button {
			width: 35
			height: 35

			text: "+ Add"
			onClicked: {
				edit_dialog.open()
			}
		}

		ListView {
			id: lview
			spacing: 10
			Layout.fillHeight: true

			delegate: RowLayout {
				width: dialog.width - 50
				height: 50
				spacing: 10

				Image {
					id: thumbnail
					Layout.preferredWidth: 50
					Layout.preferredHeight: 50
					source: Game.resource("characters/" + lview.model[index].sprite, true)
					fillMode: Image.PreserveAspectCrop
					verticalAlignment: Qt.AlignTop
				}

				Button {
					width: 35
					height: 35

					text: "Edit"

					onClicked: {
						edit_dialog.character = Game.getCharacter(name.text)
						edit_dialog.open();
					}
				}

				Label  {
					id: name
					Layout.fillWidth: true
					text: lview.model[index].name
				}

				Button {
					width: 35
					height: 35

					text: "X"

					onClicked: {
						confirm_dialog.character = lview.model[index].name
						confirm_dialog.open()
					}
				}
			}
		}
	}

	onOpened: lview.model = Game.getCharacters()

	onAccepted: {
		Game.saveScenario()
		Game.loadScenario(Game.getScenarioName())
		GameScript.displayPrompt(Game.currentPrompt.id)
	}

	Dialog {
		id: edit_dialog
		width: 400
		height: 300
		title: "Character " + (character ? character.name : "")
		standardButtons: Dialog.Ok | Dialog.Cancel
		anchors.centerIn: Overlay.overlay

		property var character

		Column {
			Label {
				text: "Name"
			}
			TextField {
				width: 150
				id: character_name
				text: edit_dialog.character ? edit_dialog.character.name : ""
			}

			Label {
				text: "Image path"
			}
			ComboBox {
				id: character_image
				width: 200
				textRole: "fileName"
				valueRole: "fileName"

				model: FolderListModel {
					id: character_image_model
					showDirs: false
					nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
				}
			}
		}

		onAccepted:  {
			let name = character_name.text;
			let sprite = character_image.currentText;

			if (character) {
				character.name = character_name.text;
				character.sprite = character_image.currentText;
			} else {
				Game.addCharacter(name, sprite);
			}

			lview.model = []
			lview.model = Game.getCharacters();
		}

		onOpened: {
			character_image.currentIndex = character && character.sprite
					? character_image.find(character.sprite)
					: -1;
		}
	}

	Dialog {
		id: confirm_dialog
		width: 400
		height: 300
		title: "Confirm deletion"
		standardButtons: Dialog.Yes | Dialog.No
		anchors.centerIn: Overlay.overlay

		property string character

		Label {
			text: "Are you sure you want to delete '" + confirm_dialog.character + "'?"
		}

		onAccepted:  {
			Game.removeCharacter(character);
			lview.model = []
			lview.model = Game.getCharacters();
		}
	}
}
