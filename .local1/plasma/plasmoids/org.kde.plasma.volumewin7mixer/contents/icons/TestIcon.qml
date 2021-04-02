import QtQuick 2.5
import QtQuick.Window 2.1
import org.kde.plasma.core 2.0 as PlasmaCore

Window {
	id: window
	x: 0
	y: 0
	width: 300
	height: 300

	MouseArea {
		anchors.fill: parent
		acceptedButtons: Qt.LeftButton
		onClicked: Qt.quit(0)
	}

	Rectangle {
		anchors.fill: parent
		color: "#386" //theme.backgroundColor
	}

	// PlasmaCore.IconItem {
	// 	anchors.centerIn: parent
	// 	source: "audio-speakers"
	// 	// width: 22
	// 	// height: width
	// 	anchors.fill: parent
	// }

	PlasmaCore.SvgItem {
		anchors.fill: parent
		svg: PlasmaCore.Svg {
			imagePath: filepath("speaker.svg")
		}
	}

	function filepath(filename) {
		var qmlPath = Qt.application.arguments[1] // qml path if launched with qmlscene
		qmlPath = qmlPath.substring(0, qmlPath.lastIndexOf('/')+1)
		return qmlPath + filename
	}

	Component.onCompleted: {
		console.log(Qt.application.arguments)
	}
}
