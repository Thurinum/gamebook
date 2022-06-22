import QtQuick
import QtQuick.Controls

Dialog {
	id: dialog_error
	title: "Error"
	standardButtons: Dialog.Ok
	anchors.centerIn: Overlay.overlay

	property string msg

	Label {
		text: dialog_error.msg
	}
}