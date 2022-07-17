import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

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
			model: if (Game.currentPrompt) Game.getCharacters()
			textRole: "name"
		}

		Label {
			text: "Dialogue contents"
		}
		TextArea {
			id: text
			width: parent.width
			wrapMode: Text.Wrap
			selectByMouse: true
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
			checked: Game.currentPrompt ? Game.currentPrompt.isEnd : false
		}
	}

	onAccepted: {
		let txt = text.text;
		Game.currentPrompt.text = txt;
		Game.currentPrompt.character = name.currentText
		Game.currentPrompt.background = background.currentText
		Game.currentPrompt.isEnd = bIsEnd.checked;
		prompt.text = txt;
		GameScript.displayPrompt(Game.currentPrompt.id)
	}

	onOpened: {
		name.currentIndex = name.find(Game.currentPrompt.character)

		background.currentIndex = Game.currentPrompt.background
				? background.find(Game.currentPrompt.background)
				: -1;
	}
}
