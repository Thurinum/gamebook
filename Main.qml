import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import "utils.js" as Utils

Window {
	id: app

	width: 640
	height: 480
	visible: true
	title: "Gamebook"

	Image {
		id: background

		width: app.width
		height: app.height
		x: 0
		y: 0

		source: Game.setting("Main/sMainMenuBackground");
	}

	Rectangle {
		id: appmenu

		color: "transparent"

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
							Game.setSetting("Main/sLastScenario", currentText);
						}
					}

					Binding {
						target: cbo_selectScenario
						property: "currentIndex"
						value: {
							cbo_selectScenario.count;
							let lastScenario = Game.setting("Main/sLastScenario");
							if (lastScenario)
								cbo_selectScenario.currentIndex = cbo_selectScenario.find(lastScenario);
						}
					}

					Button {
						text: "+"
						onClicked: dialog_addScenario.visible = true
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
							dialog_error.msg = "Please select a scenario!";
							dialog_error.visible = true;
							return;
						}

						appmenu.height = 0;
						game.isEditingAllowed = true

						Utils.displayPrompt(Game.getPrompt("0"));
					}
				}
			}
		}
	}

	Rectangle {
		id: game

		property string currentBackground
		property bool isEditingAllowed

		width: app.width
		height: app.height

		anchors.top: appmenu.bottom

		color: "lightgrey"
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
				text: ""

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
			}

			Column {
				id: repliesView

				width: replies.width - character.width - 25
				x: 25
				anchors.verticalCenter: replies.verticalCenter
				spacing: 10
			}

			Menu {
				id: repliesEditMenu

				property Item selection

				MenuItem {
					text: "Add reply..."
				}
				MenuItem {
					text: "Edit reply..."
					enabled: repliesEditMenu.selection
					onTriggered: {
						dialog_editReply.open();
					}
				}
			}

			MouseArea {
				anchors.fill: replies
				acceptedButtons: Qt.RightButton
				onClicked: (mouse) => {
					let pt = mapToItem(repliesView, mouse.x, mouse.y)
					repliesEditMenu.selection = repliesView.childAt(pt.x, pt.y);
					//dialog_editReply_text.text = story.value(game.currentnode).split("|")[2].split("~")[2]; // :P
					repliesEditMenu.popup();
				}
			}
		}

		Menu {
			id: promptEditMenu

			MenuItem {
				text: "Edit prompt..."
				onTriggered: {
					dialog_editPrompt_text.text = prompt.text
					dialog_editPrompt.visible = true;
				}
			}
		}

		MouseArea {
			anchors.fill: parent
			acceptedButtons: Qt.RightButton
			enabled: game.isEditingAllowed

			onClicked: {
				promptEditMenu.popup();
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

	Dialog {
		id: dialog_addScenario
		title: "New Scenario"
		standardButtons: Dialog.Ok | Dialog.Cancel
		anchors.centerIn: Overlay.overlay
		height: 300

		Label {
			text: "Scenario name"
			TextField { id: dialog_addScenario_text; width: dialog_addScenario.availableWidth; anchors.top: parent.bottom }
		}

		onAccepted: {
			let name = dialog_addScenario_text.text
			Game.createScenario(name);
		}
	}

	Dialog {
		id: dialog_addScenarioProfile
		title: "New profile"
		standardButtons: Dialog.Ok | Dialog.Cancel
		anchors.centerIn: Overlay.overlay
		height: 300

		Label {
			text: "Player name"
			TextField { id: dialog_addScenarioProfileo_text; anchors.top: parent.bottom }
		}

		onAccepted: {
			let name = dialog_addScenarioProfileo_text.text
			Game.createScenarioProfile(name);
		}
	}

	Dialog {
		id: dialog_loadScenarioProfile
		title: "Load existing save"
		standardButtons: Dialog.Ok | Dialog.Cancel
		anchors.centerIn: Overlay.overlay
		height: 300

		Label {
			text: "Save profile"
			ComboBox { id: dialog_loadScenarioProfile_name; anchors.top: parent.bottom }
		}

		onAccepted: {
			let name = dialog_loadScenarioProfile_name.currentText;

			if (name.length === 0) {
				dialog_error.msg = "No scenario selected!";
				dialog_error.visible = true;
				return;
			}

			appmenu.height = 0;
			Game.loadScenarioProfile(name);
		}
	}

	Dialog {
		id: dialog_editPrompt
		width: 400
		height: 300
		title: "Edit dialogue prompt"
		standardButtons: Dialog.Ok | Dialog.Cancel
		anchors.centerIn: Overlay.overlay

		Column {
			width: parent.width
			anchors.margins: 10

			Label { text: "Character name" }
			ComboBox {
				id: dialog_editPrompt_name
			}

			Label { text: "Dialogue contents"; }
			TextArea { id: dialog_editPrompt_text; width: parent.width; wrapMode: Text.Wrap}
		}


		onAccepted: {
			let text = dialog_editPrompt_text.text;
			prompt.text = parseStr(text);

			// replace prompt text
			let data = story.value(game.currentnode).split("|");
			data[1] = text;

			story.setValue(game.currentnode, data.join("|"));
		}
	}

	Dialog {
		id: dialog_error
		title: "Error"
		standardButtons: Dialog.Ok
		anchors.centerIn: Overlay.overlay

		property string msg

		Label {
			text: dialog_error.msg
		}
	}
}
