import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import "../../scripts/gamescript.js" as GameScript

Dialog {
	id: root
	width: isOpened ? parent.width * 0.8 : 0
	height: implicitHeaderHeight + implicitContentHeight + implicitFooterHeight + 40
	opacity: isOpened ? 1 : 0
	title: "Edit dialogue prompt"
	standardButtons: Dialog.Ok | Dialog.Cancel
	anchors.centerIn: Overlay.overlay

	property bool isOpened: false
	property alias character: characterField
	property alias text: textField
	property alias folder: backgroundFieldModel.folder
	property alias musicFolder: musicFieldModel.folder

	onOpened: {
		characterField.model = Game.getCharacters();
		characterField.currentIndex = characterField.find(Game.getCharacter(Game.currentPrompt.characterId)?.name) ?? 0;
		backgroundField.currentIndex = Game.currentPrompt.background
				? backgroundField.find(Game.currentPrompt.background)
				: -1;
		musicField.currentIndex = musicField.find(Game.currentPrompt.music);
		isOpened = true;
	}

	onClosed: isOpened = false

	onAccepted: {
		if (hasTargetField.checked && Game.currentPrompt.replies.length > 0) {
			errorDialog.msg = "This prompt contains replies.<br />Please delete replies manually to make it a monologue.";
			errorDialog.open();
			return;
		}

		Game.currentPrompt.text = textField.text;
		Game.currentPrompt.targetId = hasTargetField.checked ? targetField.text : "";
		Game.currentPrompt.characterId = characterField.currentValue ?? "";
		Game.currentPrompt.color = colorField.text;
		Game.currentPrompt.background = backgroundField.currentText;
		Game.currentPrompt.music = hasMusicField.checked ? musicField.currentText : "";
		Game.currentPrompt.isEnd = isEndField.checked;

		if (!app.isEditingAllowed)
			music.stop();

		GameScript.displayPrompt(Game.currentPrompt.id);
	}

	Behavior on width {
		NumberAnimation {
			duration: 200
			easing.type: Easing.InOutQuad
		}
	}
	Behavior on opacity {
		NumberAnimation {
			duration: 200
			easing.type: Easing.InOutQuad
		}
	}

	ColumnLayout {
		id: layout
		anchors.fill: parent
		spacing: 15

		ColumnLayout {
			Layout.fillWidth: true

			Label {
				text: "Dialogue contents"
			}
			ScrollView {
				Layout.fillWidth: true
				Layout.maximumHeight: 150

				TextArea {
					id: textField

					wrapMode: Text.Wrap
					selectByMouse: true
				}
			}
		}

		RowLayout {
			Layout.fillWidth: true
			spacing: 15

			ColumnLayout {
				Label {
					text: "Character name"
				}
				ComboBox {
					id: characterField
					textRole: "name"
					valueRole: "id"
					Layout.fillWidth: true
				}

				Label {
					text: "Background"
				}
				ComboBox {
					id: backgroundField
					textRole: "fileName"
					valueRole: "fileName"
					Layout.fillWidth: true

					model: FolderListModel {
						id: backgroundFieldModel
						showDirs: false
						nameFilters: ["*.png", "*.jp*g", "*.gif", "*.tif*", "*.webp"]
					}
				}

				Label {
					text: "Color"
				}
				TextField {
					id: colorField

					Layout.fillWidth: true
					color: "white"
					horizontalAlignment: Qt.AlignHCenter
					text: Game.currentPrompt?.color

					background: Rectangle {
						color: colorField.text
					}
				}
			}

			ColumnLayout {
				Layout.fillWidth: true

				CheckBox {
					id: hasMusicField
					text: "Changes music"
					checked: Game.currentPrompt ? Game.currentPrompt.music !== "" : false
				}
				ComboBox {
					id: musicField

					Layout.fillWidth: true

					enabled: hasMusicField.checked
					textRole: "fileName"
					valueRole: "fileName"

					model: FolderListModel {
						id: musicFieldModel
						showDirs: false
						nameFilters: ["*.mp3", "*.wav", "*.ogg"]
					}
				}

				CheckBox {
					id: hasTargetField
					text: "Leads to another prompt"
					checked: Game.currentPrompt ? Game.currentPrompt.targetId !== "" : false
				}
				TextField {
					id: targetField

					Layout.fillWidth: true

					enabled: hasTargetField.checked
					wrapMode: Text.Wrap
					selectByMouse: true
				}

				Switch {
					id: isEndField
					text: "Ends story"
					checked: Game.currentPrompt ? Game.currentPrompt.isEnd : false
				}
			}
		}
	}
}
