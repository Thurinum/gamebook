import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog
	width: 400
	height: 300
	title: "Character " + (character ? character.name : "")
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

    property var character
	property bool shouldDelete: false
	property alias folder: characterImageField_model.folder

	Column {
		visible: !shouldDelete

		Label {
			text: "Name"
		}
		TextField {
			width: 150
			id: characterNameField
			text:  dialog.character && dialog.character.name ? dialog.character.name : ""
		}

		Label {
			text: "Image path"
		}
		ComboBox {
			id: characterImageField
			width: 350
			textRole: "fileName"
			valueRole: "fileName"

			model: FolderListModel {
				id: characterImageField_model
				showDirs: false
				nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
			}
		}
	}

	Label {
		visible: dialog.shouldDelete
        text: "Are you sure you want to delete '" + (dialog.character ? dialog.character.name : "") + "'?"
	}

	onOpened: {
		characterImageField.currentIndex = character && character.sprite
				? characterImageField.find(character.sprite)
				: -1;
	}

	onAccepted:  {
		let name = characterNameField.text;
		let sprite = characterImageField.currentText;

		if (shouldDelete && character) {
            // remove character
            Game.removeCharacter(character.id);
			charactersTab.model = [];
			charactersTab.model = Game.getCharacters();
			shouldDelete = false;
		} else if (character) {
            // edit character
			character.name = characterNameField.text;
			character.sprite = characterImageField.currentText;
		} else if (!shouldDelete) {
            // add character
			Game.addCharacter(name, sprite);
		} else {
			// TODO: show error popup
			console.warn("Couldnt remove character! Should delete flag set")
		}

        // reload scenario
        Game.saveScenario();
        Game.loadScenario(Game.getScenarioName());

		charactersTab.model = []
		charactersTab.model = Game.getCharacters();
	}
}

