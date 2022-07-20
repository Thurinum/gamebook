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

	property alias name: characterField
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
			model: if (Game.currentPrompt) Game.getCharacters()
			textRole: "name"
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

		Label {
			text: "Music"
		}
		ComboBox {
			id: musicField
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
			checked: Game.currentPrompt ? Game.currentPrompt.target !== "" : false
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
		characterField.currentIndex = characterField.find(Game.currentPrompt.character)
		backgroundField.currentIndex = Game.currentPrompt.background
				? backgroundField.find(Game.currentPrompt.background)
				: -1;
	}

	onAccepted: {
		if (hasTargetField.checked && Game.currentPrompt.replies.length > 0) {
			errorDialog.msg = "This prompt contains replies.<br />Please delete replies manually to make it a monologue.";
			errorDialog.open();
			return;
		}

		Game.currentPrompt.text = textField.text;
		Game.currentPrompt.target = hasTargetField.checked ? targetField.text : "";
		Game.currentPrompt.character = characterField.currentText
		Game.currentPrompt.background = backgroundField.currentText
		Game.currentPrompt.music = musicField.currentText
		Game.currentPrompt.isEnd = isEndField.checked;

		GameScript.displayPrompt(Game.currentPrompt.id);
	}

}
