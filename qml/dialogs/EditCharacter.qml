import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: edit_dialog
	width: 400
	height: 300
	title: "Character " + (character ? character.name : "")
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property var character
	property alias folder: character_image_model.folder

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

