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
	property var selectedPrompts: []

	function resetModel() {
		root.model = []
		root.model = Game.prompts(searchField.text, caseSensitiveSortToggle.checked)
	}

	Rectangle {
		id: searchPane
		width: parent.width
		height: root.itemHeight

		Image {
			id: searchIcon
			width: root.itemHeight
			height: root.itemHeight - 15
			fillMode: Image.PreserveAspectFit
			anchors.verticalCenter: parent.verticalCenter

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

		cacheBuffer: 6969 // prevent disappearing items. nice.

		model: root.model
		clip: true

		delegate: MouseArea {
			property int modelIndex: model.index
			property string backgroundColor: "#EEE"

			width: parent?.width
			height: root.itemHeight
			acceptedButtons: Qt.LeftButton | Qt.RightButton

			onClicked: function(event) {
				if (event.button === Qt.RightButton)
					return promptMenu.popup();

				GameScript.displayPrompt(modelData.id);

				let index = root.selectedPrompts.indexOf(this);

				// remove if already there
				if (index !== -1) {
					backgroundColor = "#EEE";
					root.selectedPrompts.splice(index, 1);
					return;
				}

				// select
				backgroundColor = "#CCC";
				root.selectedPrompts.push(this);
				index = root.selectedPrompts.indexOf(this);

				// allow add more if ctrl pressed
				if (event.modifiers & Qt.ControlModifier)
					return;

				// deselect old ones otherwise
				for (let i = 0; i < root.selectedPrompts.length; i++) {
					if (i === index)
						continue;

					root.selectedPrompts[i].backgroundColor = "#EEE";
					root.selectedPrompts.splice(i, 1);
				}
			}


			Rectangle {
				id: background
				anchors.fill: parent
				color: parent.backgroundColor
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
					wrapMode: Text.NoWrap
					textFormat: Text.StyledText
					elide: Text.ElideRight
					clip: true

					text: modelData.text === Game.setting("Main/sPromptTextPlaceholder") ? "<i>(empty)</i>" : modelData.text
				}

				// for copying to clipboard
				TextEdit {
					id: editor
					visible: false
				}
			}

			Menu {
				id: promptMenu


				MenuItem {
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



				MenuItem {
					text: "Batch edit prompts"

					onTriggered: {
						if (root.selectedPrompts.length === 0)
							return;

						promptBatchDialog.prompts = root.selectedPrompts;
						promptBatchDialog.model   = root.model;
						promptBatchDialog.open();
					}
				}


				MenuItem {
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
