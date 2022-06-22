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
			model: if (app.currentPrompt) Game.getCharacterNames()
		}

		Label {
			text: "Dialogue contents"
		}
		TextArea {
			id: text
			width: parent.width
			wrapMode: Text.Wrap
		}
	}

	onAccepted: {
		//			app.currentPrompt.character = Game.getCharacter(
		//						dialog_editPrompt_name.currentText)
		let txt = text.text // TODO: refactor those names lol
		app.currentPrompt.text = txt
		prompt.text = txt
	}
}
