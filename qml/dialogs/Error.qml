import QtQuick
import QtQuick.Controls

Dialog {
	id: dialog
	title: "Error"
	standardButtons: Dialog.Ok
	anchors.centerIn: Overlay.overlay

	width: 400
	height: 200

	property string msg

	function show(title, msg) {
		dialog.title = title;
		dialog.msg = msg;
		dialog.open();
	}

	Label {
		anchors.fill: parent
		text: dialog.msg
		wrapMode: Text.WordWrap
	}
}
