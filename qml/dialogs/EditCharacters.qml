import QtQuick
import QtQuick.Controls
import "../../scripts/utils.js" as Utils

Dialog {
	id: dialog

	width: 500
	height: 400
	title: "Edit characters"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	ListView {
		id: view
		anchors.fill: parent
		spacing: 10

		delegate: Row {
			height: 50
			spacing: 10
			Image {
				width: 50
				height: 50
				source: Game.getPath("background.jpeg", "")
				fillMode: Image.PreserveAspectCrop
			}

			TextEdit {
				width: 150
				id: name
				text: view.model[index]
			}

			TextEdit {
				width: 300
				id: url
				//text: Game.getCharacter(name).sprite
			}
		}
	}

	onOpened: view.model = Game.getCharacterNames()
}
