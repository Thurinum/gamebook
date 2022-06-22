import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/utils.js" as Utils

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

		Label {
			text: "Reply target"
		}
		SpinBox {
			id: dialog_editReply_target
			width: parent.width
			from: -1
			value: dialog_editReply.reply ? dialog_editReply.reply.target : 0
		}
	}

	onAccepted: {
		reply.text = Utils.parseStr(dialog_editReply_text.text)
		reply.target = dialog_editReply_target.value
	}
}
