import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../scripts/gamescript.js" as GameScript

Item {
	id: root

	property alias model: characters.model

	Column {
		id: column

		anchors.fill: parent
		anchors.margins: 25
		spacing: 25

		Button {
			height: 35

			text: "+ Add"
			onClicked: {
				edit_dialog.open()
			}
		}

		ListView {
			id: characters
			spacing: 10
			width: column.width
			height: 1000

			delegate: RowLayout {
				width: parent.width
				height: 50
				spacing: 10

				Image {
					id: thumbnail
					Layout.preferredWidth: 50
					Layout.preferredHeight: 50
					source: Game.resource("characters/" + characters.model[index].sprite, true)
					fillMode: Image.PreserveAspectCrop
					verticalAlignment: Qt.AlignTop
				}

				Button {
					width: 35
					height: 35

					text: "Edit"

					onClicked: {
						edit_dialog.character = Game.getCharacter(name.text)
						edit_dialog.open();
					}
				}

				Label  {
					id: name
					Layout.fillWidth: true
					text: characters.model[index].name
				}

				Button {
					width: 35
					height: 35

					text: "X"

					onClicked: {
						confirm_dialog.character = characters.model[index].name
						confirm_dialog.open()
					}
				}
			}
		}
	}
}
