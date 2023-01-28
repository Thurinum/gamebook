import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../scripts/gamescript.js" as GameScript

Item {
	id: root

	required property string title
	default property alias contentItems: layout.children
	property int padding: 20
	property int radius: 20
	property real sizeFactor: 0.8

	width: parent.width * sizeFactor
	height: dialog.height < parent.height * sizeFactor
	parent: Overlay.overlay
	anchors.centerIn: Overlay.overlay

	Popup {
		id: dialog

		width: root.width

		background: Rectangle {
			color: Universal.background
			radius: root.radius
		}

		ColumnLayout {
			id: layout

			Text {
				text: "sdfsdfsfsdfsdf"
			}
		}
	}

	DropShadow {
		anchors.fill: dialog
		source: dialog
		radius: 16.0
		transparentBorder: true
	}
}
