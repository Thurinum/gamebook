import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import "../../scripts/gamescript.js" as GameScript
import "../dialogs" as Dialog

Rectangle {
	id: pane

	required property Item target
	required property int alignment
	property real contentWidth: Window.width / 3
	property int handleWidth: 25
	default property alias contentItems: paneStackLayout.data
	property alias tabs: paneTabBar.contentChildren

	QtObject {
		id: internal
		property bool toggled: false
	}

	signal toggled

	width: internal.toggled ? contentWidth : 0
	height: Window.height

	anchors.left:  if (alignment === Qt.AlignLeft)  target.left
	anchors.right: if (alignment === Qt.AlignRight) target.right

	MouseArea {
		id: paneToggle

		width: pane.handleWidth
		height: pane.height

		anchors.left:  if (alignment === Qt.AlignLeft)  pane.right
		anchors.right: if (alignment === Qt.AlignRight) pane.left

		onClicked: {
			internal.toggled = !internal.toggled;
			pane.toggled();
		}

		Rectangle {
			id: paneToggleHandle
			anchors.fill: parent
			color: "lightgrey"

			Label {
				anchors.fill: parent
				horizontalAlignment: Qt.AlignHCenter
				verticalAlignment: Qt.AlignVCenter

				text: pane.alignment === Qt.AlignLeft
						? internal.toggled ? "<" : ">"
						: internal.toggled ? ">" : "<"
			}
		}

		DropShadow {
			source: paneToggleHandle
			anchors.fill: paneToggleHandle
			radius: 30
			color: Qt.hsla(0, 0, 0, 0.4)
			transparentBorder: true
		}
	}

	TabBar {
		id: paneTabBar
		width: pane.contentWidth
	}

	StackLayout {
		id: paneStackLayout

		width: pane.contentWidth
		height: pane.height - paneTabBar.implicitHeight
		anchors.top: paneTabBar.bottom
		currentIndex: paneTabBar.currentIndex
		clip: true
	}

	Behavior on width {
		NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
	}
}
