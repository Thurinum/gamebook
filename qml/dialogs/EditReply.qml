import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog_editReply
	width: 400
	height: 300
	title: "Edit dialogue reply"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property var reply

	Column {
		width: parent.width
		anchors.margins: 10

		Label {
			text: "Reply text"
		}
		TextArea {
			id: dialog_editReply_text
			width: parent.width
			wrapMode: Text.Wrap
			text: dialog_editReply.reply ? dialog_editReply.reply.text : ""
		}

		CheckBox {
			id: checkbox
			text: "Use custom target"
		}
		TextArea {
			id: dialog_editReply_target
			width: parent.width
			enabled: checkbox.checked
			text: dialog_editReply.reply ? dialog_editReply.reply.target : ""
		}
	}

	onAccepted: {
		//reply.text = GameScript.parseStr(dialog_editReply_text.text)
		reply.text = dialog_editReply_text.text

		if (checkbox.checked)
			reply.target = dialog_editReply_target.value
	}
}
