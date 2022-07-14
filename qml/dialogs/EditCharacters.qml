import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import "../../scripts/utils.js" as Utils

Dialog {
	id: dialog

	width: 500
	height: 400
	title: "Edit characters"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	ListView {
		id: view
		anchors.fill: parent
		spacing: 10

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
					source: Game.getPath(view.model[index].sprite, "background.jpeg")
					fillMode: Image.PreserveAspectCrop
				}

				Rectangle {
					id: thumbnail_overlay
					anchors.fill: thumbnail
					color: "#222222AA"
					visible: thumbnail_mousearea.containsMouse
				}
			}

			TextEdit {
				width: 150
				id: name
				text: view.model[index].name
			}
		}
	}

	onOpened: view.model = Game.getCharacters()

//	FileDialog {
//		id: file_dialog
//		folder: Game.getScenariosFolder() + "/" + app.
//	}

	Dialog {
		id: edit_dialog
		width: 400
		height: 300
		title: "Character " + character.name
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
				text: edit_dialog.character.name
			}

			Label {
				text: "Image path"
			}
			TextField {
				id: character_image
				width: 150
				text: edit_dialog.character.sprite
			}
		}

		onAccepted:  {
			character.name = character_name.text
			character.sprite = character_image.text;
			view.model = []
			view.model = view.model = Game.getCharacters();
		}
	}
}
