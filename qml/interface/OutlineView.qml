import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../../scripts/gamescript.js" as GameScript

Item {
	id: root
	z: 69

	property var model
	property int itemHeight: 50

	function resetModel() {
		root.model = []
		root.model = Game.prompts(searchField.text)
	}

	Rectangle {
		id: searchPane
		width: parent.width
		height: root.itemHeight

		Image {
			id: searchIcon
			width: root.itemHeight
			height: root.itemHeight

			source: Game.appResource("search.png")
		}

		TextField {
			id: searchField
			width: root.width - searchIcon.width - 15
			y: 0
			anchors.left: searchIcon.right
			anchors.verticalCenter: parent.verticalCenter
			placeholderText: "search"

			onTextEdited: resetModel()
		}
	}

	Rectangle {
		id: searchOptionsPane
		width: parent.width
		height: root.itemHeight
		anchors.top: searchPane.bottom

		Row {
			anchors.centerIn: parent

			CheckBox {
				id: descendingSortToggle
				text: "Descending"
				checked: Game.setting("Outline/bSortDescending")
				onToggled: {
					Game.setSetting("Outline/bSortDescending", checked);
					resetModel()
				}
			}

			CheckBox {
				id: caseSensitiveSortToggle
				text: "Case sensitive"
				checked: Game.setting("Outline/bSortCaseSensitive")
				onToggled: {
					Game.setSetting("Outline/bSortCaseSensitive", checked)
					resetModel()
				}
			}

			CheckBox {
				id: hideEmptyToggle
				text: "Hide empty"
				checked: Game.setting("Outline/bHideEmpty")
				onToggled: {
					Game.setSetting("Outline/bHideEmpty", checked)
					resetModel()
				}
			}
		}
	}

	DropShadow {
		anchors.fill: searchOptionsPane
		source: searchOptionsPane
		radius: 8.0
		transparentBorder: true
		verticalOffset: 5
		color: "#888"
		z: 1
		scale: 1.1
		cached: true
	}

	ListView {
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.top: searchOptionsPane.bottom
		anchors.bottom: parent.bottom

		model: root.model
		clip: true

		delegate: MouseArea {
			width: parent?.width
			height: root.itemHeight
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
					width: root.itemHeight
					height: root.itemHeight
					source: Game.resource("characters/" + Game.getCharacter(modelData.characterId)?.sprite)
				}

				Label {
					id: promptText
					width: root.width - 100
					height: root.itemHeight
					text: modelData.text === Game.setting("Main/sPromptTextPlaceholder") ? "<i>(empty)</i>" : modelData.text
					wrapMode: Text.NoWrap
					textFormat: Text.StyledText
					elide: Text.ElideRight
					clip: true
				}

				// for copying to clipboard
				TextEdit {
					id: editor
					visible: false
				}
			}

			Menu {
				id: promptMenu


				Action {
					id: editPromptAction

					property string oldPromptId

					text: "Edit prompt"
					onTriggered: {
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
					text: "Copy id"
					onTriggered: {
						editor.text = modelData.id
						editor.selectAll();
						editor.copy()
					}
				}
			}
		}
	}

}
