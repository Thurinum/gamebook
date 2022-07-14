import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/utils.js" as Utils

Dialog {
	width: 400
	height: 300
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
			model: if (app.currentPrompt) Game.getCharacters()
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

		CheckBox {
			id: bIsEnd
			text: "Ends story"
			checked: app.currentPrompt ? app.currentPrompt.isEnd : false
		}
	}

	onAccepted: {
		let txt = text.text;
		app.currentPrompt.text = txt;
		app.currentPrompt.character = name.currentText
		app.currentPrompt.isEnd = bIsEnd.checked;
		prompt.text = txt;
	}
}
