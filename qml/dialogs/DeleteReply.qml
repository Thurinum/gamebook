import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	width: 400
	height: 300
	title: "Edit dialogue reply"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property int index

	Label {
		text: "Are you sure you want to nuke this reply from existence?"
	}

	onAccepted: {
		Game.currentPrompt.nukeReply(index)
		repliesRepeater.model = Game.currentPrompt.replies
	}
}
