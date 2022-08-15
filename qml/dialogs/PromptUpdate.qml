import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: root
	width: 400
	height: 550
	title: "Edit dialogue prompt"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property alias character: characterField
	property alias text: textField
	property alias folder: backgroundFieldModel.folder
	property alias musicFolder: musicFieldModel.folder

	Column {
		width: parent.width
		anchors.margins: 10

		Label {
			text: "Character name"
		}
		ComboBox {
			id: characterField
			textRole: "name"
			valueRole: "id"
			width: contentWidth
		}

		Label {
			text: "Dialogue contents"
		}
		TextArea {
			id: textField
			width: parent.width
			wrapMode: Text.Wrap
			selectByMouse: true
		}

		Label {
			text: "Background"
		}

		ComboBox {
			id: backgroundField
			width: 200
			textRole: "fileName"
			valueRole: "fileName"

			model: FolderListModel {
				id: backgroundFieldModel
				showDirs: false
				nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
			}
		}

		CheckBox {
			id: hasMusicField
			text: "Music"
			checked: Game.currentPrompt ? Game.currentPrompt.music !== "" : false
		}
		ComboBox {
			id: musicField
			enabled: hasMusicField.checked
			width: 200
			textRole: "fileName"
			valueRole: "fileName"

			model: FolderListModel {
				id: musicFieldModel
				showDirs: false
				nameFilters: ["*.mp3", "*.wav", "*.ogg"]
			}
		}

		CheckBox {
			id: hasTargetField
			text: "Leads to another prompt"
			checked: Game.currentPrompt ? Game.currentPrompt.targetId !== "" : false
		}
		TextField {
			id: targetField
			enabled: hasTargetField.checked
			width: parent.width
			wrapMode: Text.Wrap
			selectByMouse: true
		}

		Switch {
			id: isEndField
			text: "Ends story"
			checked: Game.currentPrompt ? Game.currentPrompt.isEnd : false
		}
	}

	onOpened: {
		characterField.model = Game.getCharacters();
		characterField.currentIndex = characterField.find(Game.getCharacter(Game.currentPrompt.characterId).name)
		backgroundField.currentIndex = Game.currentPrompt.background
				? backgroundField.find(Game.currentPrompt.background)
				: -1;
		musicField.currentIndex = musicField.find(Game.currentPrompt.music)
	}

	onAccepted: {
		if (hasTargetField.checked && Game.currentPrompt.replies.length > 0) {
			errorDialog.msg = "This prompt contains replies.<br />Please delete replies manually to make it a monologue.";
			errorDialog.open();
			return;
		}

		Game.currentPrompt.text = textField.text;
		Game.currentPrompt.targetId = hasTargetField.checked ? targetField.text : "";
		Game.currentPrompt.characterId = characterField.currentValue;
		Game.currentPrompt.background = backgroundField.currentText;
		Game.currentPrompt.music = hasMusicField.checked ? musicField.currentText : "";
		Game.currentPrompt.isEnd = isEndField.checked;

		if (!app.isEditingAllowed)
			music.stop();

		GameScript.displayPrompt(Game.currentPrompt.id);
	}
}
