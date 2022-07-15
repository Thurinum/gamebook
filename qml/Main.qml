import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "../scripts/utils.js" as Utils
import "./dialogs" as Dialog

ApplicationWindow {
	id: app

	property var currentPrompt
	property bool isEditingAllowed

	width: 640
	height: 480
	visible: true
	title: "Gamebook"

	menuBar: MenuBar {
		visible: app.isEditingAllowed
		Menu {
			title: "File"
			MenuItem {
				text: "Save scenario"
				onTriggered: Game.saveScenario()
			}
			MenuItem {
				text: "Back to menu"
				onTriggered: appmenu.height = app.height
			}
			MenuItem {
				text: "Quit"
				onTriggered: Qt.exit(0)
			}
		}
		Menu {
			title: "Scenario"
			MenuItem {
				text: "Edit characters..."
				onTriggered: dialog_editCharacters.open()
			}
			MenuItem {
				text: "Edit reply types..."
				onTriggered: {

				}
			}
			MenuItem {
				text: "Edit variables..."
				onTriggered: {

				}
			}
		}
	}

	Image {
		id: background

		property double fac: 0.2

		width: app.width
		height: app.height
		scale: 1.5
		x: parallaxOverlay.point.position.x * fac - width / 2 * fac
		y: parallaxOverlay.point.position.y * fac - height / 2 * fac
		fillMode: Image.PreserveAspectCrop

		source: app.currentPrompt && app.currentPrompt.background ? Game.getAbsolutePath() + "/resources/" + app.currentPrompt.background : Game.getPath(Game.setting("Main/sMainMenuBackground"))
	}

	Rectangle {
		id: appmenu

		color: "transparent"
		clip: true

		width: app.width
		implicitHeight: app.height

		Behavior on height {
			NumberAnimation {
				duration: 1000
				easing.type: Easing.InOutQuad
			}
		}

		Rectangle {
			id: appmenu_wrapper

			anchors.fill: appmenu
			anchors.margins: 50

			color: Qt.hsla(0, 0, 1, 0.8)
			radius: 10
			border.width: 5
			border.color: Universal.accent

			Column {
				anchors.centerIn: appmenu_wrapper
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
						id: cbo_selectScenario
						textRole: "fileBaseName"
						valueRole: "fileName"

						model: FolderListModel {
							id: cbo_selectScenario_model
							showDirs: false
							folder: Game.getScenariosFolder()
							nameFilters: ["*.scenario"]
						}

						onActivated: {
							Game.setSetting("Main/sLastScenario",
									    currentText)
						}
					}

					Binding {
						target: cbo_selectScenario
						property: "currentIndex"
						value: {
							cbo_selectScenario.count
							let lastScenario = Game.setting(
								    "Main/sLastScenario")
							if (lastScenario)
								cbo_selectScenario.currentIndex
										= cbo_selectScenario.find(
											lastScenario)
						}
					}

					Button {
						text: "+"
						onClicked: dialog_addScenario.visible = true
					}
					Button {
						text: "-"
						onClicked: dialog_removeScenario.visible = true
					}
				}

				Button {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Play scenario from beginning"

					onClicked: {
						dialog_addScenarioProfile.visible = true
					}
				}

				Button {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Load existing save"

					onClicked: {
						dialog_loadScenarioProfile.visible = true
					}
				}

				Button {
					anchors.horizontalCenter: parent.horizontalCenter
					text: "Edit scenario"

					onClicked: {
						if (cbo_selectScenario.currentText === "") {
							dialog_error.msg = "Please select a scenario!"
							dialog_error.visible = true
							return
						}

						appmenu.height = 0
						app.isEditingAllowed = true
						Game.loadScenario(cbo_selectScenario.currentText)
						//Game.loadScenarioProfile("_editModeProfile");
						Utils.displayPrompt("0")
					}
				}
			}
		}
	}

	HoverHandler {
		id: parallaxOverlay
		target: parent
	}

	Rectangle {
		id: game

		width: app.width
		height: app.height

		anchors.top: appmenu.bottom

		color: "#CCCCCC44"
		border.width: 10
		border.color: "darkred"

		ScrollView {
			id: promptview

			width: game.width
			height: game.height / 2
			clip: true

			x: game.border.width
			y: game.border.width

			Label {
				id: prompt

				width: game.width
				font.family: "serif"
				font.pixelSize: 25
				padding: 10
				text: app.currentPrompt ? app.currentPrompt.text : "empty prompt"

				textFormat: Text.StyledText
				wrapMode: Text.WordWrap
			}

			Timer {
				id: prompter
				interval: 100
				repeat: true

				property int i: 0
				property string text: "Dummy text."

				onTriggered: {
					if (".:".includes(text[i]))
						interval = 300
					else if (",;".includes(text[i]))
						interval = 150
					else
						interval = 50

					prompt.text += text[i]
					i++
					if (i >= text.length) {
						i = 0
						prompter.stop()
					}
				}
			}
		}

		Rectangle {
			id: replies
			width: game.width
			height: game.height / 2 - 15
			anchors.top: promptview.bottom
			y: game.height / 2

			color: Qt.hsla(0, 0, 1, 0.5)
			border.color: "lightblue"
			border.width: 10

			Image {
				id: character
				x: game.width - width - 10
				y: -game.height / 2

				height: app.height - 25
				fillMode: Image.PreserveAspectFit
				source: app.currentPrompt && app.currentPrompt.character
					  ? Game.getAbsolutePath() + "/resources/" + Game.getCharacter(app.currentPrompt.character).sprite
					  : Game.getAbsolutePath() + "/resources/" + Game.setting("Main/sFallbackImage");
			}

			Column {
				id: repliesView

				width: replies.width - character.width - 25
				x: 25
				anchors.verticalCenter: replies.verticalCenter
				spacing: 10

				Repeater {
					id: repliesRepeater
					model: app.currentPrompt
						 && app.currentPrompt.replies.length
						 > 0 ? app.currentPrompt.replies : 0
					delegate: Button {
						property int index: model.index

						width: repliesView.width * 0.9
						height: 40
						text: modelData.text

						onClicked: {
							Utils.displayPrompt(
										app.currentPrompt.replies[index].target)
						}
					}
				}
			}

			Menu {
				id: repliesEditMenu

				property Item selection

				MenuItem {
					text: "Add reply..."
					enabled: app.currentPrompt ? !app.currentPrompt.isEnd : false
					onTriggered: {
						dialog_addReply.open()
					}
				}
				MenuItem {
					text: "Edit reply..."
					enabled: repliesEditMenu.selection
					onTriggered: {
						dialog_editReply.open()
					}
				}
				MenuItem {
					text: "Go back"
					enabled: app.currentPrompt ? app.currentPrompt.parent : false
					onTriggered: Utils.displayPrompt(app.currentPrompt.parent.id)
				}
				MenuItem {
					text: "Save"
					onTriggered: {
						Game.saveScenario()
					}
				}
			}

			MouseArea {
				anchors.fill: replies
				enabled: app.isEditingAllowed
				acceptedButtons: Qt.RightButton
				onClicked: mouse => {
						     let pt = mapToItem(repliesView, mouse.x, mouse.y)
						     repliesEditMenu.selection = repliesView.childAt(pt.x, pt.y)

						     if (repliesEditMenu.selection)
						     dialog_editReply.reply = app.currentPrompt.replies[repliesEditMenu.selection.index]
						     repliesEditMenu.popup()
					     }
			}
		}

		Menu {
			id: promptEditMenu

			MenuItem {
				text: "Edit prompt..."
				onTriggered: {
					dialog_editPrompt.name.currentIndex = 0
					dialog_editPrompt.text.text = app.currentPrompt.text
					dialog_editPrompt.visible = true
				}
			}
		}

		MouseArea {
			width: parent.width
			height: parent.height / 2
			acceptedButtons: Qt.RightButton
			enabled: app.isEditingAllowed

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

		Behavior on scale {
			NumberAnimation {
				duration: 1000
				easing.type: Easing.InOutQuad
			}
		}

		Label {
			anchors.centerIn: endscreen
			text: "<h1>The End<h1><br /><h2>" + endscreen.text + "</h2>"
		}
	}

	Dialog.AddScenario { id: dialog_addScenario }
	Dialog.DeleteScenario { id: dialog_removeScenario }
	Dialog.AddScenarioProfile { id: dialog_addScenarioProfile }
	Dialog.LoadScenarioProfile { id: dialog_loadScenarioProfile }
	Dialog.EditPrompt { id: dialog_editPrompt }
	Dialog.AddReply { id: dialog_addReply }
	Dialog.EditReply { id: dialog_editReply }
	Dialog.EditCharacters { id: dialog_editCharacters }
	Dialog.Error { id: dialog_error }
}
