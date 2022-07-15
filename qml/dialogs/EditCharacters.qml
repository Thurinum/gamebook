import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.folderlistmodel
import "../../scripts/utils.js" as Utils

Dialog {
	id: dialog

	width: 500
	height: 400
	title: "Edit characters"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay



	ListView {
		id: lview
		anchors.fill: parent
		spacing: 10

		header: Button {
			text: "+"
			onClicked: {
				edit_dialog.open()
			}
		}

		delegate: Row {
			height: 50
			spacing: 10

			MouseArea {
				id: thumbnail_mousearea
				width: 50
				height: 50
				hoverEnabled: true

				onClicked: {
					edit_dialog.character = Game.getCharacter(name.text)
					edit_dialog.open();
				}

				Image {
					id: thumbnail
					anchors.fill: thumbnail_mousearea
					source: Game.getPath(lview.model[index].sprite, "background.jpeg")
					fillMode: Image.PreserveAspectCrop
				}

				Rectangle {
					id: thumbnail_overlay
					anchors.fill: thumbnail
					color: "#222222AA"
					visible: thumbnail_mousearea.containsMouse

					Text {
						text: "edit me"
					}
				}
			}

			TextEdit {
				width: 250
				id: name
				text: lview.model[index].name
			}

			MouseArea {
				width: 50
				height: 50

				Rectangle {
					anchors.fill: parent
					color: "red"

					Text {
						text: "nuke me"
					}
				}

				onClicked: {
					confirm_dialog.character = lview.model[index].name
					confirm_dialog.open()
				}
			}
		}
	}

	onOpened: lview.model = Game.getCharacters()

	onAccepted: Utils.displayPrompt(app.currentPrompt.id)

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
					folder: Game.getAbsolutePath() + "/resources/"
					nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
				}
			}
		}

		onAccepted:  {
			let name = character_name.text;
			let sprite = character_image.text;

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
