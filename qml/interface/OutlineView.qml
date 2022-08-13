import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../scripts/gamescript.js" as GameScript

Item {
	id: root
	z: 69

	property var model

	ListView {
		anchors.fill: parent
		model: root.model

		delegate: MouseArea {
			width: parent?.width
			height: 50
			acceptedButtons: Qt.LeftButton | Qt.RightButton

			onClicked: (event) => {
				if (event.button === Qt.RightButton)
					return promptMenu.popup();

				GameScript.displayPrompt(modelData.id);
			}

			Rectangle {
				anchors.fill: parent
				color: "#EEEEEE"
			}

			Row {
				anchors.fill: parent

				Image {
					width: 50
					height: 50
					source: Game.resource("characters/" + Game.getCharacter(modelData.characterId).sprite)
				}

				Label {
					width: root.width - 100
					height: 50
					text: modelData.text === Game.setting("Main/sPromptTextPlaceholder") ? "<i>(empty)</i>" : modelData.text
					wrapMode: Text.NoWrap
					textFormat: Text.StyledText
					elide: Text.ElideRight
					clip: true
				}
			}

			Menu {
				id: promptMenu


				Action {
					id: editPromptAction

					property string oldPromptId

					text: "Edit prompt"
					onTriggered: {
						console.log(324324)
						oldPromptId = Game.currentPrompt.id;
						GameScript.displayPrompt(modelData.id);
						promptDialog.character.currentIndex = 0;
						promptDialog.text.text = Game.currentPrompt.text;
						promptDialog.open();
						restoreOldPrompt.enabled = true;
					}

				}

				// restore old prompt on window close
				Connections {
					id: restoreOldPrompt
					enabled: false
					target: promptDialog
					function onClosed() { GameScript.displayPrompt(editPromptAction.oldPromptId); enabled = false; }
				}

				Action {
					text: "Edit reply?"
				}
			}
		}
	}

}
