import QtQuick
import QtQuick.Controls

Rectangle {
	id: endscreen

	property string text

	anchors.fill: game
	scale: 0

	Label {
		anchors.centerIn: endscreen
		text: "<h1>The End<h1><br /><h2>" + endscreen.text + "</h2>"
	}

	Behavior on scale {
		NumberAnimation {
			duration: 1000
			easing.type: Easing.InOutQuad
		}
	}
}
