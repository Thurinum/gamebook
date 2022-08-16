import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: root
	width: 400
	height: 550
	title: "Edit dialogue prompts"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property var model
	property var prompts: []

	property alias backgroundsFolder: backgroundFieldModel.folder
	property alias musicsFolder: musicFieldModel.folder

	Column {
		width: parent.width
		anchors.margins: 10

		CheckBox {
			id: characterFieldToggle
			text: "Change character"
		}
		ComboBox {
			id: characterField

			enabled: characterFieldToggle.checked
			width: contentWidth
			model: if (Game.currentPrompt) Game.getCharacters()
			textRole: "name"
			valueRole: "id"
		}

		CheckBox {
			id: textFieldToggle
			text: "Change text"
		}
		TextArea {
			id: textField

			enabled: textFieldToggle.checked
			width: parent.width
			wrapMode: Text.Wrap
			selectByMouse: true
		}

		CheckBox {
			id: colorFieldToggle
			text: "Change color"
		}
		TextField {
			id: colorField

			color: "white"
			horizontalAlignment: Qt.AlignHCenter

			background: Rectangle {
				color: colorField.text
			}
		}

		CheckBox {
			id: backgroundFieldToggle
			text: "Change background"
		}
		ComboBox {
			id: backgroundField
			width: 200
			textRole: "fileName"
			valueRole: "fileName"

			enabled: backgroundFieldToggle.checked
			model: FolderListModel {
				id: backgroundFieldModel
				showDirs: false
				nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
			}
		}

		CheckBox {
			id: musicFieldToggle
			text: "Change music"
			checked: Game.currentPrompt ? Game.currentPrompt.music !== "" : false
		}
		ComboBox {
			id: musicField
			enabled: musicFieldToggle.checked
			width: 200
			textRole: "fileName"
			valueRole: "fileName"

			model: FolderListModel {
				id: musicFieldModel
				showDirs: false
				nameFilters: ["*.mp3", "*.wav", "*.ogg"]
			}
		}
	}

	onOpened: {
		// reset fields
		textFieldToggle.checked = false;
		textField.clear();

		characterFieldToggle.checked = false;
		backgroundFieldToggle.checked = false;
		musicFieldToggle.checked = false;

		backgroundsFolder = promptDialog.folder;
		musicsFolder = promptDialog.musicFolder;
	}

	onAccepted: {
		for (let i = 0; i < prompts.length; i++) {
			let prompt = model[prompts[i].modelIndex];

			if (!prompt)
				return;

			if (textFieldToggle.checked)
				prompt.text = textField.text;

			if (colorFieldToggle.checked)
				prompt.text = colorField.text;

			if (characterFieldToggle.checked)
				prompt.characterId = characterField.currentValue;

			if (backgroundFieldToggle.checked)
				prompt.background = backgroundField.currentText;

			if (musicFieldToggle.checked)
				prompt.music = musicField.currentText;
		}
	}
}
