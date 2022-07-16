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

		CheckBox {
			id: checkbox
			text: "Use custom target"
		}
		TextArea {
			id: dialog_addReply_target
			width: parent.width
			enabled: checkbox.checked
			text: dialog_editReply.reply ? dialog_editReply.reply.target : ""
		}
	}

	onAccepted: {
		// TODO: Add validation for dialogs
		console.log(currentPrompt)
		let target = checkbox.checked ? dialog_addReply_target.value : null
		Game.addReply(currentPrompt,
				  Utils.parseStr(dialog_addReply_text.text),
				  target)
		dialog_addReply_text.text = ""
		repliesRepeater.model = []
		repliesRepeater.model = currentPrompt.replies
	}
}
