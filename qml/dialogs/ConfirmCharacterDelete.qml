import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: confirm_dialog
	width: 400
	height: 300
	title: "Confirm deletion"
	standardButtons: Dialog.Yes | Dialog.No
	anchors.centerIn: Overlay.overlay

	property string character

	Label {
		text: "Are you sure you want to delete '" + confirm_dialog.character + "'?"
	}

	onAccepted:  {
		Game.removeCharacter(character);
		charactersTab.model = []
		charactersTab.model = Game.getCharacters();
	}
}
