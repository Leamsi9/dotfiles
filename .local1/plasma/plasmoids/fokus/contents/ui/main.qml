import QtQuick 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0 as Controls
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    Plasmoid.switchWidth: units.gridUnit * 11
    Plasmoid.switchHeight: units.gridUnit * 11

    property string clock_fontfamily: plasmoid.configuration.clock_fontfamily || "Noto Mono"

    property var min: plasmoid.configuration.focus_time
    property var sec: 0
    property var stateVal: 1
    property var maxTime: plasmoid.configuration.focus_time * 60
    property var currTime: plasmoid.configuration.focus_time * 60
    property var customIconSource: plasmoid.file(
                                       "", "icons/pomodoro-start-light.svg")

    function formatNumberLength(num, length) {
        var r = "" + num
        while (r.length < length) {
            r = "0" + r
        }

        return r
    }

    NotificationManager {
        id: notificationManager
    }

    Plasmoid.toolTipMainText: formatNumberLength(
                                  min, 2) + ":" + formatNumberLength(sec, 2)
    Plasmoid.toolTipSubText: ""

    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        onClicked: plasmoid.expanded = !plasmoid.expanded

        PlasmaCore.IconItem {
            id: trayIcon
            width: compactRoot.width
            height: compactRoot.height
            Layout.preferredWidth: height
            source: customIconSource
        }

        ColorOverlay {
            anchors.fill: trayIcon
            source: trayIcon
            color: theme.textColor
        }
    }

    Plasmoid.fullRepresentation: Item {
        id: fullRoot

        Layout.minimumWidth: units.gridUnit * 12
        Layout.maximumWidth: units.gridUnit * 12
        Layout.minimumHeight: units.gridUnit * 11
        Layout.maximumHeight: units.gridUnit * 11

        property bool isPinVisible: {
            return plasmoid.location !== PlasmaCore.Types.Floating
        }

        Binding {
            target: plasmoid
            property: "hideOnWindowDeactivate"
            value: !plasmoid.configuration.pin
        }

        PlasmaComponents.ToolButton {
            visible: isPinVisible
            anchors {
                right: parent.right
                top: parent.top
            }
            width: Math.round(units.gridUnit * 1.25)
            height: width
            checkable: true
            iconSource: "window-pin"
            checked: plasmoid.configuration.pin
            onCheckedChanged: plasmoid.configuration.pin = checked
        }

        Timer {
            id: textTimer
            interval: 1000
            repeat: true
            running: false
            triggeredOnStart: false
            onTriggered: time.set()
        }

        Column {
            anchors {
                top: fullRoot.top
                left: fullRoot.left
                right: fullRoot.right
                bottom: buttonsRow.top
            }

            MouseArea {
                anchors.fill: parent
                property int wheelDelta: 0

                function scrollByWheel(wheelDelta, eventDelta) {
                    // magic number 120 for common "one click"
                    // See: http://qt-project.org/doc/qt-5/qml-qtquick-wheelevent.html#angleDelta-prop
                    wheelDelta += eventDelta;

                    var increment = 0;

                    while (wheelDelta >= 120) {
                        wheelDelta -= 120;
                        increment++;
                    }

                    while (wheelDelta <= -120) {
                        wheelDelta += 120;
                        increment--;
                    }

                    while (increment != 0) {
                        if(increment > 0) {
                            min += 1
                            currTime += 60
                            maxTime += 60
                        } else {
                            if(currTime > 60) {
                                min -= 1
                                currTime -= 60
                                maxTime -= 60
                            }
                        }

                        time.update()
                        increment += (increment < 0) ? 1 : -1;
                    }

                    return wheelDelta;
                }

                onWheel: {
                    wheelDelta = scrollByWheel(wheelDelta, wheel.angleDelta.y);
                }
            }

            ProgressCircle {
                id: progressCircle
                anchors.centerIn: parent
                size: Math.min(parent.width / 1.1, parent.height / 1.1)
                colorCircle: theme.buttonFocusColor
                arcBegin: 0
                arcEnd: Math.ceil((currTime / maxTime) * 360)
                lineWidth: size / 20
            }

            Column {
                anchors.centerIn: parent
                height: time.height

                PlasmaComponents.Label {
                    id: time
                    text: formatNumberLength(min,
                                             2) + ":" + formatNumberLength(sec,
                                                                           2)
                    font.pointSize: progressCircle.width / 7
                    font.family: clock_fontfamily
                    anchors.horizontalCenter: parent.horizontalCenter

                    function set() {
                        if (sec == 0) {
                            min--
                            sec = 59
                        } else {
                            sec--
                        }

                        currTime--

                        if (currTime == 0) {
                            end()
                        }

                        time.update()
                    }

                    function update() {
                        time.text = formatNumberLength(
                                    min, 2) + ":" + formatNumberLength(sec, 2)

                        if (textTimer.running) {
                            customIconSource = plasmoid.file(
                                        "",
                                        "icons/pomodoro-indicator-light-" + formatNumberLength(
                                            Math.ceil(
                                                (currTime / maxTime) * 61),
                                            2) + ".svg")
                        }
                    }
                }

                Controls.PageIndicator {
                    id: pageIndicator
                    count: 4
                    currentIndex: (stateVal - 1) / 2

                    anchors {
                        bottom: time.top
                        horizontalCenter: parent.horizontalCenter
                    }

                    spacing: progressCircle.width / 25
                    delegate: Rectangle {
                        implicitWidth: progressCircle.width / 25
                        implicitHeight: width
                        radius: width / 2
                        color: theme.textColor

                        opacity: index === pageIndicator.currentIndex ? 0.95 : 0.45

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 100
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    id: status
                    text: "focus"
                    font.pointSize: progressCircle.width / 15

                    anchors {
                        top: time.bottom
                        horizontalCenter: parent.horizontalCenter
                    }

                }
            }
        }

        RowLayout {
            id: buttonsRow
            spacing: 8

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }

            PlasmaComponents.Button {
                id: skipBtn
                text: "Skip"
                implicitWidth: minimumWidth
                iconSource: "media-skip-forward"
                onClicked: skip()
            }

            PlasmaComponents.Button {
                id: sessionBtn
                text: "Start"
                implicitWidth: minimumWidth
                iconSource: "media-playback-start"
                onClicked: {
                    if (sessionBtn.text == "Start") {
                        start()
                    } else {
                        pause()
                    }
                }
            }

            PlasmaComponents.Button {
                id: breakBtn
                text: "Stop"
                implicitWidth: minimumWidth
                iconSource: "media-playback-stop"
                onClicked: stop()
            }
        }

        function start() {
            notificationManager.start(stateVal)
            textTimer.start()
            sessionBtn.text = "Pause"
            sessionBtn.iconSource = "media-playback-pause"
            customIconSource = plasmoid.file(
                        "", "icons/pomodoro-indicator-light-61.svg")
        }

        function pause() {
            textTimer.stop()
            sessionBtn.text = "Start"
            sessionBtn.iconSource = "media-playback-start"
            customIconSource = plasmoid.file("",
                                             "icons/pomodoro-start-light.svg")
        }

        function skip() {
            nextState()
            resetTime()
        }

        function stop() {
            notificationManager.stop()
            textTimer.stop()
            stateVal = 1
            resetTime()
            sessionBtn.text = "Start"
            sessionBtn.iconSource = "media-playback-start"
            customIconSource = plasmoid.file("",
                                             "icons/pomodoro-start-light.svg")
        }

        function end() {
            notificationManager.end()
            textTimer.stop()
            sessionBtn.text = "Start"
            sessionBtn.iconSource = "media-playback-start"
            customIconSource = plasmoid.file("",
                                             "icons/pomodoro-start-light.svg")
            nextState()
            resetTime()

            if (plasmoid.configuration.timer_auto_next_enabled) {
                start()
            }
        }

        function resetTime() {
            switch (stateVal) {
            case 1:
            case 3:
            case 5:
            case 7:
                min = plasmoid.configuration.focus_time
                status.text = "focus"
                break
            case 2:
            case 4:
            case 6:
                min = plasmoid.configuration.short_break_time
                status.text = "short break"
                break
            case 8:
                min = plasmoid.configuration.long_break_time
                status.text = "long break"
                break
            }

            sec = 0
            currTime = min * 60
            maxTime = currTime
            time.update()
        }

        function nextState() {
            if (stateVal < 8) {
                stateVal++
            } else {
                stateVal = 1
            }
        }
    }
}
