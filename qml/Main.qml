import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import Qt.labs.folderlistmodel
import Qt5Compat.GraphicalEffects
import "../scripts/gamescript.js" as GameScript
import "./dialogs" as Dialog
import "./interface" as Interface
import "./reusable" as Reusable

ApplicationWindow {
	id: app

	property bool isEditingAllowed

	width: 1280
	height: 720
	visible: true
	title: "Gamebook Studio"

	Image {
		id: background

		property double fac: 0.2

		width: app.width
		height: app.height
		x: parallaxOverlay.point.position.x * fac - width / 2 * fac
		y: parallaxOverlay.point.position.y * fac - height / 2 * fac
		scale: 1.5

		fillMode: Image.PreserveAspectCrop

		source: Game.currentPrompt.background
			  ? Game.resource("backgrounds/" + Game.currentPrompt.background, true)
			  : Game.appResource(Game.setting("Main/sMainMenuBackground"), true)
	}

	FastBlur {
		source: background
		anchors.fill: background
		scale: 1.5
		radius: 10
	}

	Rectangle {
		id: appMenu

		width: app.width
		implicitHeight: app.height

		color: "transparent"
		clip: true

		Rectangle {
			id: appMenuPanel

			anchors.fill: appMenu
			anchors.margins: 50

			color: Qt.hsla(0, 0, 1, 0.8)
			radius: 10
			border.width: 5
			border.color: Universal.accent

			Column {
				anchors.centerIn: appMenuPanel
				spacing: 10

				Label {
					text: "<h1>Gamebook</h1>"
					anchors.horizontalCenter: parent.horizontalCenter
				}

				Row {
					spacing: 5
					Label {
						text: "<h2>Select scenario</h2>"
					}

					ComboBox {
						id: scenarioNameField
						width: 250
						textRole: "fileBaseName"
						valueRole: "fileName"

						model: FolderListModel {
							id: scenarioNameFieldModel
							showDirs: true
							showDirsFirst: true
							folder: Game.scenariosFolder()
						}

						onActivated: {
							Game.setSetting("Main/sLastScenario", currentText)
							GameScript.loadScenario();
						}

						Binding on currentIndex {
							value: {
								// idk what I'm doing wrong, but this statement
								// is required for the binding to work
								scenarioNameField.count

								let lastScenario = Game.setting("Main/sLastScenario");

								if (!lastScenario || lastScenario === "")
									return;

								let index = scenarioNameField.find(lastScenario);

								if (index === -1)
									return;

								scenarioNameField.currentIndex = index;
								GameScript.loadScenario();
							}
						}
					}


					Button {
						text: "+"
						onClicked: scenarioDialog.open()
					}
					Button {
						text: "-"
						onClicked: {
							scenarioDialog.shouldDelete = true;
							scenarioDialog.open();
						}
					}
				}

				Button {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Play scenario from beginning"

					onClicked: {
						scenarioProfileDialog.shouldCreate = true;
						scenarioProfileDialog.open();
					}
				}

				Button {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Load existing save"

					onClicked: scenarioProfileDialog.open()
				}

				Button {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Edit scenario"

					onClicked: {
						if (scenarioNameField.currentText === "") {
							errorDialog.msg = "Please select a scenario!"
							errorDialog.open();
							return;
						}

						if (Game.loadScenario(scenarioNameField.currentText) === false) {
							errorDialog.msg = "Failed to load scenario!";
							errorDialog.open();
							return;
						}

						appMenu.height = 0;
						app.isEditingAllowed = true;
						GameScript.displayPrompt("0");
					}
				}
			}
		}


		Behavior on height {
			NumberAnimation {
				duration: 1000
				easing.type: Easing.InOutQuad
			}
		}
	}

	HoverHandler {
		id: parallaxOverlay
		target: parent
	}

	Rectangle {
		id: game

		width: app.width - (rightPane.visible ? rightPane.handleWidth : 0)
		height: app.height
		anchors.top: appMenu.bottom

		color: Qt.hsla(0, 0, 0.6, 0.5)

		ScrollView {
			id: promptView

			width: game.width
			height: game.height / 2

			x: game.border.width
			y: game.border.width

			clip: true

			Label {
				id: prompt

				width: game.width
				padding: 10

				font.family: "Times New Roman,Linux Libertine,Liberation Serif,Noto Serif,Deja Vu Serif"
				font.pixelSize: promptView.height * 0.15

				text: Game.currentPrompt ? Game.currentPrompt.text : "empty prompt"
				textFormat: Text.StyledText
				style: Text.Outline
				styleColor: "#888"
				wrapMode: Text.WordWrap
			}

			Timer {
				id: promptTimer

				property int i: 0
				property string text: "Dummy text."

				interval: 100
				repeat: true

				onTriggered: {
					if (".:".includes(text[i]))
						interval = 300;
					else if (",;".includes(text[i]))
						interval = 150;
					else
						interval = 50;

					prompt.text += text[i];
					i++;

					if (i >= text.length) {
						i = 0;
						promptTimer.stop();
					}
				}
			}
		}

		Rectangle {
			id: repliesPanel
			width: game.width
			height: game.height / 2 - 15
			anchors.bottom: game.bottom
			y: game.height / 2

			color: Qt.hsla(0, 0, 1, 0.5)
			border.color: Universal.accent
			border.width: 9

			Rectangle {
				id: characterNameBadge

				width: characterName.implicitWidth + 50
				height: 80

				anchors.left: repliesPanel.left
				anchors.top:  repliesPanel.top
				anchors.leftMargin: 50
				anchors.topMargin: -(height / 2)

				border.color: Universal.accent
				border.width: 6
				radius: 15

				Label {
					id: characterName

					anchors.centerIn: characterNameBadge
					horizontalAlignment: Qt.AlignHCenter
					verticalAlignment: Qt.AlignVCenter

					font.pixelSize: repliesPanel.height * 0.1
					font.family: "Times New Roman"

					text: Game.currentPrompt.character
						? Game.getCharacter(Game.currentPrompt.character).name
						: "Unnamed Character"
				}
			}

			DropShadow {
				source: characterNameBadge
				anchors.fill: characterNameBadge

				horizontalOffset: 0
				verticalOffset: 10

				color: Qt.hsla(0, 0, 0, 0.5)
				transparentBorder: true
				radius: 30
			}

			Image {
				id: character

				width: app.width / 2 - 100
				height: app.height - 50

				anchors.right: repliesPanel.right
				anchors.bottom: repliesPanel.bottom
				anchors.bottomMargin: 30

				horizontalAlignment: Qt.AlignRight
				verticalAlignment: Qt.AlignBottom
				fillMode: Image.PreserveAspectFit

				source: Game.currentPrompt.character
					  ? Game.resource("characters/" + Game.getCharacter(Game.currentPrompt.character).sprite)
					  : ""
			}

			DropShadow {
				source: character
				anchors.fill: character
				horizontalOffset: 0
				verticalOffset: 0

				color: Qt.hsla(0, 0, 0, 0.5)
				radius: 30
			}

			Column {
				id: repliesView

				width: repliesPanel.width - character.paintedWidth - 25
				x: 25
				anchors.verticalCenter: repliesPanel.verticalCenter
				spacing: 10

				Repeater {
					id: repliesRepeater

					model: Game.currentPrompt && Game.currentPrompt.replies.length > 0
						 ? Game.currentPrompt.replies : 0

					delegate: Button {
						property int index: model.index

						width: repliesView.width * 0.9
						height: font.pixelSize + 20

						font.pixelSize: repliesPanel.height * 0.09
						text: modelData.text

						ToolTip.visible: hovered
						ToolTip.delay: 900
						ToolTip.timeout: 2500
						ToolTip.text: modelData.text

						MouseArea {
							anchors.fill: parent

							property double yPos: 0

							onPressed: mouse => yPos = mouse.y
							onClicked: GameScript.displayPrompt(Game.currentPrompt.replies[index].target)
							onPositionChanged: function(mouse) {
								if (!app.isEditingAllowed)
									return;

								let offset = mouse.y - yPos;
								let deadzone = parent.height;
								let index = parent.index;
								let indexOffset = Math.round(Math.abs(offset) / deadzone);

								let dir = null;

								if (offset > deadzone)
									dir = 1;
								else if (offset < -deadzone)
									dir = -1;

								if (!dir)
									return;

								let newIndex = index + (dir * indexOffset);

								if (newIndex < 0 || newIndex > Game.currentPrompt.replies.length - 1)
									return;

								Game.currentPrompt.moveReply(index, newIndex);
								repliesRepeater.model = Game.currentPrompt.replies;
							}
						}
					}
				}
			}

			Menu {
				id: repliesContextMenu

				property Item selection

				function selectedReply() {
					if (repliesContextMenu.selection) {
						return Game.currentPrompt.replies[repliesContextMenu.selection.index];
					}
				}

				MenuItem {
					text: "Add reply..."
					enabled: Game.currentPrompt ? !Game.currentPrompt.isEnd : false
					height: enabled ? implicitHeight : 0
					onTriggered: {
						replyDialog.reply = undefined
						replyDialog.open()
					}
				}
				MenuItem {
					text: "Edit reply..."
					enabled: repliesContextMenu.selection
					height: enabled ? implicitHeight : 0
					onTriggered: {
						replyDialog.reply = repliesContextMenu.selectedReply();
						replyDialog.open()
					}
				}
				MenuItem {
					text: "Delete reply..."
					enabled: repliesContextMenu.selection
					height: enabled ? implicitHeight : 0
					onTriggered: {
						replyDialog.reply = repliesContextMenu.selectedReply();
						replyDialog.shouldDelete = true
						replyDialog.open()
					}
				}
				MenuItem {
					text: "Go back"
					enabled: Game.currentPrompt.parentId !== ""
					height: enabled ? implicitHeight : 0
					onTriggered: GameScript.displayPrompt(Game.currentPrompt.parentId)
				}
			}

			MouseArea {
				anchors.fill: repliesPanel
				enabled: app.isEditingAllowed
				acceptedButtons: Qt.RightButton
				onClicked: mouse => {
						     let pt = mapToItem(repliesView, mouse.x, mouse.y);
						     repliesContextMenu.selection = repliesView.childAt(pt.x, pt.y);
						     repliesContextMenu.popup();
					     }
			}
		}

		Menu {
			id: promptEditMenu

			MenuItem {
				text: "Edit prompt..."
				onTriggered: {
					promptDialog.name.currentIndex = 0
					promptDialog.text.text = Game.currentPrompt.text
					promptDialog.visible = true
				}
			}
		}

		MouseArea {
			width: parent.width
			height: parent.height / 2

			enabled: app.isEditingAllowed
			acceptedButtons: Qt.RightButton

			onClicked: {
				promptEditMenu.popup()
			}
		}
	}

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

	Reusable.HorizontalPane {
		id: rightPane

		visible: app.isEditingAllowed
		target: appMenu
		alignment: Qt.AlignRight
		tabs: [
			TabButton {
				text: "Characters"
			}
		]

		onToggled: {
			charactersTab.model = Game.getCharacters()
			Game.saveScenario()
			Game.loadScenario(Game.getScenarioName())
			GameScript.displayPrompt(Game.currentPrompt.id)
		}

		Interface.CharacterEditor {
			id: charactersTab
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}

	Menu {
		id: mainContextMenu

		x: appMenu.width - width - (rightPane.visible ? rightPane.handleWidth + rightPane.width : 0)
		y: mainContextMenuButton.height

		MenuItem {
			text: "Save scenario"
			enabled: app.isEditingAllowed
			height: enabled ? implicitHeight : 0
			onTriggered: {
				Game.saveScenario()
			}
		}
		MenuItem {
			text: "Back to menu"
			enabled: appMenu.height === 0 //@disable-check M325 (false positive)
			height: enabled ? implicitHeight : 0
			onTriggered: {
				// TODO: UNLOAD PROFILE IN C++ (WILL require REWRITE)
				app.isEditingAllowed = false
				appMenu.height = app.height
			}
		}
		MenuItem {
			text: "Quit"
			onTriggered: Qt.exit(0)
		}
	}

	ToolButton {
		id: mainContextMenuButton

		anchors.right: rightPane.left
		anchors.rightMargin: (rightPane.visible ? rightPane.handleWidth : 0)

		text: "☰"
		font.pointSize: 25

		onClicked: mainContextMenu.open()

		Behavior on anchors.rightMargin {
			NumberAnimation { duration: 500; easing.type: Easing.OutQuad }
		}
	}

	Dialog.ScenarioInsertDelete		{ id: scenarioDialog }
	Dialog.ScenarioProfileInsertDelete	{ id: scenarioProfileDialog }
	Dialog.PromptUpdate			{ id: promptDialog }
	Dialog.ReplyUpsertDelete		{ id: replyDialog }
	Dialog.CharacterUpsertDelete		{ id: characterDialog }
	Dialog.Error				{ id: errorDialog }
}
