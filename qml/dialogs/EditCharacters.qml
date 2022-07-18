import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: dialog

	width: 500
	height: 400
	title: "Edit characters"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay


}
