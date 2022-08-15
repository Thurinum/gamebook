import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia
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
		id: backgroundBlur

		source: background
		anchors.fill: background
		scale: 1.5
		radius: 30
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
			border.color: Game.currentPrompt.color

			Column {
				anchors.centerIn: appMenuPanel
				spacing: 10

				Label {
					text: "<h1>Gamebook (Alpha)</h1>"
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
			z: 1

			clip: true

			Label {
				id: prompt

				width: game.width
				padding: 10

				font.family: "Consolas,Courier New"
				//font.family: "Times New Roman,Linux Libertine,Liberation Serif,Noto Serif,Deja Vu Serif"
				//font.pixelSize: promptView.height * 0.15
				font.pixelSize: promptView.height * 0.11
				font.letterSpacing: -1

				text: Game.currentPrompt ? Game.currentPrompt.text : Game.setting("Main/sPromptTextPlaceholder")
				color: Game.currentPrompt?.color
				textFormat: Text.StyledText
				style: Text.Outline
				styleColor: "#666"
				wrapMode: Text.WordWrap
			}

			DropShadow {
				id: promptShadow

				anchors.fill: prompt
				source: prompt

				verticalOffset: 3
				radius: 7.0
				transparentBorder: true
				color: "#222"
			}

			Timer {
				id: promptTimer

				property int i: 0
				property string text: "Dummy text."

				interval: app.isEditingAllowed ? 1 : 100
				repeat: true

				onTriggered: {
					if (!app.isEditingAllowed) {
						if (".:!?".includes(text[i]))
							interval = 350;
						else if (",;".includes(text[i]))
							interval = 150;
						else
							interval = 50;
					}

					prompt.text += text[i];
					i++;

					if (i >= text.length) {
						i = 0;

						if (Game.currentPrompt.targetId !== "")
							promptRedirectionTimer.start();

						promptTimer.stop();

					}
				}
			}

			Timer {
				id: promptRedirectionTimer

				interval: 1000
				repeat: false
				onTriggered: GameScript.displayPrompt(Game.currentPrompt.targetId);
			}

			Menu {
				id: promptEditMenu

				MenuItem {
					text: "Edit prompt..."
					onTriggered: {
						promptDialog.character.currentIndex = 0
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
			id: repliesPanel
			width: game.width
			height: game.height / 2 - 15
			anchors.bottom: game.bottom
			y: game.height / 2

			color: Qt.hsla(0, 0, 1, 0.5)
			border.color: Qt.darker(Game.currentPrompt?.color, 1.5)
			border.width: 9
			radius:5

			Rectangle {
				id: characterNameBadge

				width: characterName.implicitWidth + 50
				height: repliesPanel.height * 0.2

				anchors.left: repliesPanel.left
				anchors.top:  repliesPanel.top
				anchors.leftMargin: 50
				anchors.topMargin: -(height / 2)

				border.color: Qt.darker(Game.currentPrompt?.color, 1.5)
				border.width: 6
				radius: 15

				Label {
					id: characterName

					anchors.centerIn: characterNameBadge
					horizontalAlignment: Qt.AlignHCenter
					verticalAlignment: Qt.AlignVCenter

					font.pixelSize: repliesPanel.height * 0.1
					font.family: "Segoe UI Light"
					style: Text.Outline
					styleColor: "lightgrey"

					text: Game.currentPrompt.characterId
						? Game.getCharacter(Game.currentPrompt.characterId).name
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

			AnimatedImage {
				id: character

				width: app.width / 2 - 100
				height: app.height - 50

				anchors.right: repliesPanel.right
				anchors.bottom: repliesPanel.bottom
				//anchors.bottomMargin: 30

				horizontalAlignment: Qt.AlignRight
				verticalAlignment: Qt.AlignBottom
				fillMode: Image.PreserveAspectFit
				playing: true
				antialiasing: true
				smooth: true
				mipmap: true

				source: Game.currentPrompt.characterId
					  ? Game.resource("characters/" + Game.getCharacter(Game.currentPrompt.characterId).sprite)
					  : ""
			}

			DropShadow {
				source: character
				anchors.fill: character
				horizontalOffset: 0
				verticalOffset: 0

				color: Qt.hsla(0, 0, 0, 0.5)
				transparentBorder: true
				radius: 30
			}

			Column {
				id: repliesView

				width: repliesPanel.width - character.paintedWidth - 25
				x: 25
				anchors.verticalCenter: repliesPanel.verticalCenter
				anchors.verticalCenterOffset: 15
				spacing: 10

				Repeater {
					id: repliesRepeater

					model: Game.currentPrompt && Game.currentPrompt.replies.length > 0
						 ? Game.currentPrompt.replies : 0

					delegate: MouseArea {
						id: replyArea

						property int index: model.index
						property double yPos: 0
						property int margins: 20

						width: repliesView.width * 0.9
						height: reply.height

						hoverEnabled: true

						ToolTip.visible: containsMouse
						ToolTip.delay: 900
						ToolTip.timeout: 2500
						ToolTip.text: modelData.text

						Rectangle {
							id: reply

							width: parent.width
							height: replyLabel.contentHeight + replyArea.margins
							y: parent.pressed ? 5 : 0

							color: Universal.baseLowColor
							border.width: 5
							border.color: Universal.baseMediumLowColor
							radius: 10

							Label {
								id: replyLabel

								anchors.fill: parent
								anchors.margins: replyArea.margins

								font.pixelSize: repliesPanel.height * 0.09
								text: (app.isEditingAllowed && Game.childPromptOf(modelData) && Game.childPromptOf(modelData).text === Game.setting("Main/sPromptTextPlaceholder") ? "<i><font color=\"red\">* </font></i>" : "") + modelData.text
								wrapMode: Label.WordWrap
								textFormat: Text.StyledText

								horizontalAlignment: Text.AlignLeft
								verticalAlignment: Text.AlignVCenter
							}

							Behavior on y {
								NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
							}
						}

						DropShadow {
							id: replyShadow

							anchors.fill: reply
							source: reply
							visible: parent.containsMouse

							verticalOffset: 9
							radius: 7.0
							transparentBorder: true
							color: "#555"
						}


						onPressed: mouse => yPos = mouse.y
						onClicked: GameScript.displayPrompt(Game.currentPrompt.replies[index].target)
						onPositionChanged: function(mouse) {
							if (!app.isEditingAllowed)
								return;

							let offset = mouse.y - yPos;
							let deadzone = height;
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
					enabled: Game.currentPrompt ? Game.currentPrompt.targetId === "" && !Game.currentPrompt.isEnd : false
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
	}

	Interface.EndScreen { id: endScreen }

	Reusable.HorizontalPane {
		id: rightPane
		z: 69

		visible: app.isEditingAllowed
		target: appMenu
		alignment: Qt.AlignRight
		tabs: [
			TabButton {
				text: "Outline"
			},
			TabButton {
				text: "Characters"
			}
		]

		onToggled: {
			charactersTab.model = Game.getCharacters()
			outlineTab.model = Game.prompts()
		}

		Interface.OutlineView {
			id: outlineTab
			Layout.fillWidth: true
			Layout.fillHeight: true
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
				app.isEditingAllowed = false;
				appMenu.height = app.height;
				scenarioProfileDialog.shouldCreate = false;
				music.stop();
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

	MediaPlayer {
		id: music
		audioOutput: AudioOutput {
			volume: 0.05
		}
	}

	Dialog.ScenarioInsertDelete		{ id: scenarioDialog }
	Dialog.ScenarioProfileInsertDelete	{ id: scenarioProfileDialog }
	Dialog.PromptUpdate			{ id: promptDialog }
	Dialog.PromptUpdateBatch            { id: promptBatchDialog }
	Dialog.ReplyUpsertDelete		{ id: replyDialog }
	Dialog.CharacterUpsertDelete		{ id: characterDialog }
	Dialog.Error				{ id: errorDialog }
}
