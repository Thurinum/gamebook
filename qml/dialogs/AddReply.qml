import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/utils.js" as Utils

Dialog {
	id: dialog_addReply
	width: 400
	height: 300
	title: "Add dialogue reply"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	Column {
		width: parent.width
		anchors.margins: 10

		Label {
			text: "Reply text"
		}
		TextArea {
			id: dialog_addReply_text
			width: parent.width
			wrapMode: Text.Wrap
		}

		Label {
			text: "Reply target"
		}
		SpinBox {
			id: dialog_addReply_target
			width: parent.width
		}
	}

	onAccepted: {
		// TODO: Add validation for dialogs
		let target = dialog_addReply_target.value
		Game.addReply(app.currentPrompt,
				  Utils.parseStr(dialog_addReply_text.text),
				  target)
		dialog_addReply_text.text = ""

		repliesRepeater.model = []
		repliesRepeater.model = app.currentPrompt.replies
	}
}
