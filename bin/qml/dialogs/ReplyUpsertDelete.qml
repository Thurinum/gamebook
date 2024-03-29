import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog

	property var reply
	property bool shouldDelete: false

	width: 400
	height: 300
	title: reply ? "Edit dialogue reply" : "Add dialogue reply"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	Label {
		visible: shouldDelete
		text: reply ? "Are you sure you want to delete this reply?<br><br>Text: " + dialog.reply.text : ""
	}

	Column {
		width: parent.width
		visible: !shouldDelete
		anchors.margins: 10
		spacing: 10

		Label {
			text: "Reply text"
		}
		TextArea {
			id: replyTextField
			width: parent.width
			wrapMode: Text.Wrap
			text: dialog.reply ? dialog.reply.text : ""
			selectByMouse: true
		}

		CheckBox {
			id: replyUseTargetField
			text: "Use custom target"
		}
		TextArea {
			id: replyTargetField

			width: parent.width
			enabled: replyUseTargetField.checked
			text: dialog.reply ? dialog.reply.target : ""
			selectByMouse: true
		}
	}

	// TODO: Add data validation rules
	onAccepted: {
		// delete reply?
		if (reply && shouldDelete) {
			Game.currentPrompt.nukeReply(reply);
			repliesRepeater.model = Game.currentPrompt.replies;
			shouldDelete = false;
			return;
		}

		let target = replyTargetField.text;

		// edit reply?
		if (reply) {
			if (!Game.hasPrompt(target)) {
				errorDialog.show("Cannot edit reply", "Target does not point to a valid prompt.");
				return;
			}

			reply.text = replyTextField.text;

			if (replyUseTargetField.checked) {
				reply.target = target;
			}
			return;
		}

		// add reply?
		let useTarget = replyUseTargetField.checked ? replyUseTargetField.value : null;

		Game.addReply(Game.currentPrompt,
				  GameScript.parseStr(replyTextField.text), target);

		repliesRepeater.model = [];
		repliesRepeater.model = Game.currentPrompt.replies;
	}
}

