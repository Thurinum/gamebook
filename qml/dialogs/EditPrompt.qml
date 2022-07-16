import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/utils.js" as Utils

Dialog {
	width: 400
	height: 350
	title: "Edit dialogue prompt"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property alias name: name
	property alias text: text

	Column {
		width: parent.width
		anchors.margins: 10

		Label {
			text: "Character name"
		}
		ComboBox {
			id: name
			model: if (currentPrompt) Game.getCharacters()
			textRole: "name"
		}

		Label {
			text: "Dialogue contents"
		}
		TextArea {
			id: text
			width: parent.width
			wrapMode: Text.Wrap
		}

		Label {
			text: "Background"
		}

		ComboBox {
			id: background
			width: 200
			textRole: "fileName"
			valueRole: "fileName"

			model: FolderListModel {
				id: background_model
				showDirs: false
				folder: Game.getAbsolutePath() + "/resources/"
				nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
			}
		}

		CheckBox {
			id: bIsEnd
			text: "Ends story"
			checked: currentPrompt ? currentPrompt.isEnd : false
		}
	}

	onAccepted: {
		let txt = text.text;
		currentPrompt.text = txt;
		currentPrompt.character = name.currentText
		currentPrompt.background = background.currentText
		currentPrompt.isEnd = bIsEnd.checked;
		prompt.text = txt;
		Utils.displayPrompt(currentPrompt.id)
	}

	onOpened: {
		name.currentIndex = name.find(currentPrompt.character)

		background.currentIndex = currentPrompt.background
				? background.find(currentPrompt.background)
				: -1;
	}
}
