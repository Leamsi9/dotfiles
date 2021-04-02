
/***************************************************************************
*   Copyright (C) 2019 by Dr_i-glu4IT <dr@i-glu4it.ru>     *
***************************************************************************/
import QtQuick 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.4 as QtControls
import QtMultimedia 5.8
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.5 as QQC2

Item {
    id: root
    Layout.fillWidth: true
    Layout.fillHeight: true
    anchors.centerIn: parent

    width: 220
    height: 300
    ServersModel {
        id: serversModel
    }

    PlasmaCore.DataSource {
        id: notificationSource
        engine: "notifications"
        connectedSources: "org.freedesktop.Notifications"
    }

    Component.onCompleted: {
        playMusic.stop()
        playMusic.source = ''
        reloadServerModel()
    }

    Connections {
        target: plasmoid.configuration
        onServersChanged: {
            playMusic.stop()
            playMusic.source = ''
            reloadServerModel()
        }
    }

    Item {
        id: tool

        property int preferredTextWidth: units.gridUnit * 20
        Layout.minimumWidth: childrenRect.width + units.gridUnit
        Layout.minimumHeight: childrenRect.height + units.gridUnit
        Layout.maximumWidth: childrenRect.width + units.gridUnit
        Layout.maximumHeight: childrenRect.height + units.gridUnit

        RowLayout {

            anchors {
                left: parent.left
                top: parent.top
                margins: units.gridUnit / 2
            }

            spacing: units.largeSpacing
            Image {
                id: tooltipImage
                source: root.imgurl
                visible: tool != null && tool.image != ""
                Layout.alignment: Qt.AlignTop
                width: 80
                ColorOverlay {
                    anchors.fill: tooltipImage
                    source: tooltipImage
                    color: PlasmaCore.ColorScope.textColor
                    visible: !root.imgurl.startsWith("http")
                    antialiasing: true
                }
            }

            ColumnLayout {
                PlasmaExtras.Heading {
                    id: tooltipMaintext
                    level: 3
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    wrapMode: Text.Wrap
                    text: root.title
                    visible: text != ""
                }
                PlasmaComponents.Label {
                    id: tooltipSubtext
                    Layout.fillWidth: true
                    height: undefined
                    wrapMode: Text.WordWrap
                    text: root.subtitle
                    opacity: 0.8
                    visible: text != ""
                    maximumLineCount: 8
                }
            }
        }
    }

    property bool notification: plasmoid.configuration.Notification
    property bool transback: plasmoid.configuration.transback
    property string title: i18n("Advanced Radio Player")
    property string subtitle: i18n("Choose station")
    property string imgurl: isPlaying(
                                ) ? "../images/unknown.svg" : "../images/blank.svg"
    property color textColor: plasmoid.location == PlasmaCore.Types.Floating
                              && plasmoid.configuration.transback ? plasmoid.configuration.fontColor : PlasmaCore.ColorScope.textColor

    onSubtitleChanged: {
        root.notification == true ? title != i18n("Advanced Radio Player")
                                    && title != i18n(
                                        "Unknown Artist") ? createNotification(
                                                                ) : '' : ''
    }
    Plasmoid.backgroundHints: plasmoid.configuration.transback ? "NoBackground" : "DefaultBackground"

    MediaPlayer {
        id: playMusic
        onError: {
            playMusic.stop()
            playMusic.source = ''
            reloadServerModel()
        }
        onStopped: {

        }
        volume: 0.8
    }

    Timer {
        interval: 1000
        repeat: isPlaying() ? true : false
        running: true
        id: im
        onTriggered: {
            if (playMusic.metaData.title != undefined
                    && playMusic.metaData.title.indexOf(' - ') != -1
                    && playMusic.metaData.title.length < 1000) {
                var strings = playMusic.metaData.title.split(' - ')
                var var1 = strings[0].trim(), var2 = strings[1].trim()
                var xmlhttp = new XMLHttpRequest()
                var url = "http://ws.audioscrobbler.com/2.0/?method=track.getInfo&api_key=ada39a6834a3be4d641cc1aec7e64d48&artist=" + encodeURIComponent(
                            var1) + "&track=" + encodeURIComponent(
                            var2) + "&autocorrect=1&format=json"
                xmlhttp.onreadystatechange = function () {
                    if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                        var myArr = JSON.parse(xmlhttp.responseText)

                        myFunction(myArr)
                    }
                }
                xmlhttp.open("GET", url)
                xmlhttp.send()

                function myFunction(arr) {
                    var art = (arr.track
                               && arr.track.artist) ? (arr.track.artist.name) : var1
                    var tit = (arr.track) ? (arr.track.name) : var2
                    var img
                    root.title = (isPlaying()) ? art : i18n(
                                                     "Advanced Radio Player")
                    root.subtitle = (isPlaying()) ? tit : i18n("Choose station")
                    if (arr.track && arr.track.album
                            && arr.track.album.image[1]['#text']
                            && arr.track.album.image[1]['#text'] != 'undefined'
                            && arr.track.album.image[1]['#text'].startsWith(
                                'http')) {
                        img = arr.track.album.image[1]['#text']
                    } else {
                        img = "../images/unknown.svg"
                    }
                    root.imgurl = (isPlaying()) ? img : "../images/blank.svg"
                }
            } else {
                root.imgurl = (isPlaying(
                                   )) ? "../images/unknown.svg" : "../images/blank.svg"
                root.title = (isPlaying()) ? i18n("Unknown Artist") : i18n(
                                                 "Advanced Radio Player")
                root.subtitle = (isPlaying()) ? i18n("Unknown Song") : i18n(
                                                    "Choose station")

                im.restart()
            }
        }
    }

    function createNotification() {
        var service = notificationSource.serviceForSource("notification")
        var operation = service.operationDescription("createNotification")
        operation.appName = i18n("Advanced Radio Player")
        operation["appIcon"] = plasmoid.configuration.icon
        operation.summary = root.title
        operation["body"] = root.subtitle
        operation["timeout"] = 5000
        service.startOperationCall(operation)
    }

    Plasmoid.compactRepresentation: Item {
        id: comp
        width: parent.width
        height: parent.width

        PlasmaCore.IconItem {
            id: ima
            anchors.fill: parent
            source: plasmoid.configuration.icon
            width: parent.width
            height: parent.height
            opacity: isPlaying() ? 0.5 : 1
        }

        PlasmaCore.IconItem {
            id: stat
            source: 'media-playback-start'
            visible: isPlaying()
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height * 0.5
        }

        PlasmaComponents.Label {
            id: volumeControl
            visible: false
            width: parent.width
            height: parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(playMusic.volume * 100) + "%"
        }

        Timer {
            id: elapsedTimer
            interval: 3000
            running: false
            repeat: false
            onTriggered: {
                volumeControl.visible = false
                stat.opacity = 1
                ima.visible = true
                im.start()
            }
        }

        MouseArea {
            id: mouseArea
            width: parent.width
            height: parent.width
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {

            }
            onExited: {
                elapsedTimer.start()
            }
            onClicked: {
                plasmoid.expanded = !plasmoid.expanded
            }
            onWheel: {
                im.stop()
                volumeControl.visible = true
                stat.opacity = 0
                ima.visible = false
                if (wheel.angleDelta.y > 0 && playMusic.volume < 1) {
                    playMusic.volume += 0.05
                } else if (wheel.angleDelta.y < 0 && playMusic.volume > 0) {
                    playMusic.volume -= 0.05
                }
                elapsedTimer.start()
            }
        }

        PlasmaCore.ToolTipArea {
            id: toolTip
            width: parent.width
            height: parent.height
            anchors.fill: parent
            mainItem: tool
            interactive: true
        }
    }

    Plasmoid.fullRepresentation: Rectangle {
        Layout.preferredWidth: 200
        Layout.preferredHeight: 300
        clip: true
        color: "transparent"
        anchors.margins: plasmoid.location == PlasmaCore.Types.Floating
                         && root.transback == true ? root.width * 0.055 : 0
        Rectangle {
            id: square
            width: 200
            height: 20
            color: "transparent"
            z: 10
            PlasmaComponents.Label {
                id: nameText2
                color: textColor
                height: parent.height
                text: isPlaying() ? root.title + ' - ' + root.subtitle : i18n(
                                        "Advanced Radio Player")
                verticalAlignment: Text.AlignVCenter

                onTextChanged: {
                    anim.restart()
                }
            }
            NumberAnimation {
                property: "x"
                id: anim
                target: nameText2
                from: isPlaying() && root.title != i18n(
                          "Advanced Radio Player") ? square.width : square.width + 150
                to: (isPlaying(
                         )) ? -nameText2.width : -nameText2.width / 2 + square.width / 2
                duration: 20 * Math.abs(to - from)
                loops: (isPlaying()) ? Animation.Infinite : 1
            }
            PlasmaCore.ToolTipArea {
                id: toolTip2
                width: parent.width
                height: parent.height
                anchors.fill: parent
                mainItem: tool
                interactive: true
                visible: plasmoid.location == PlasmaCore.Types.Floating
            }
            MouseArea {
                id: mouseArea2
                width: parent.width
                height: parent.width
                anchors.fill: parent
                hoverEnabled: true
                visible: plasmoid.location !== PlasmaCore.Types.Floating
                onEntered: {
                    (isPlaying()) ? anim.pause() : anim.resume()
                }
                onExited: {
                    anim.resume()
                }
                onClicked: {

                }
            }
        }
        ListView {
            id: serversListView
            anchors.fill: parent
            anchors.topMargin: 25
            anchors.bottomMargin: 25
            model: serversModel
            clip: false

            delegate: Item {
                height: nameText.paintedHeight * 1.3
                width: parent.width
                PlasmaComponents.Label {
                    id: icon
                    color: textColor
                    height: parent.height
                    text: model.index + 1
                    width: 16
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    visible: model.status === 0
                }
                PlasmaCore.IconItem {
                    id: numberPlay
                    width: 16
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: icon.horizontalCenter
                    height: parent.height
                    source: isPlaying(
                                ) ? 'media-playback-start' : 'media-playback-stop'
                    visible: false
                    opacity: model.status === 1
                             && playMusic.bufferProgress < 1 ? 0.3 : 1
                    ColorOverlay {
                        anchors.fill: numberPlay
                        source: numberPlay
                        color: textColor
                        antialiasing: true
                    }
                }
                QtControls.BusyIndicator {
                    width: icon.width * 1
                    height: icon.height * 1
                    anchors.verticalCenter: icon.verticalCenter
                    anchors.horizontalCenter: icon.horizontalCenter
                    running: model.status === 1 && playMusic.bufferProgress < 1
                    visible: model.status === 1 && playMusic.bufferProgress < 1
                }
                PlasmaComponents.Label {
                    id: nameText

                    color: textColor
                    width: serversListView.width - 50
                    anchors.left: icon.right
                    anchors.leftMargin: 5
                    height: parent.height
                    text: model.name.length === 0 ? model.hostname : model.name
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    font.bold: model.status === 1 ? true : false
                }

                MouseArea {
                    id: mouseArea3
                    anchors.top: icon.top
                    anchors.bottom: icon.bottom
                    anchors.left: icon.left
                    width: serversListView.width
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: {
                        icon.visible = false
                        numberPlay.visible = true
                        numberPlay.source = model.status === 1 ? isPlaying(
                                                                     ) ? 'media-playback-stop' : 'media-playback-stop' : 'media-playback-start'
                    }
                    onExited: {
                        icon.visible = model.status === 1 ? false : true
                        numberPlay.visible = model.status === 1 ? true : false
                        numberPlay.source = model.status
                                === 1 ? 'media-playback-start' : 'media-playback-stop'
                    }
                    onClicked: {
                        icon.visible = model.status === 1 ? false : true
                        numberPlay.visible = model.status === 0 ? false : true
                        numberPlay.source = model.status
                                === 1 ? 'media-playback-start' : 'media-playback-stop'
                        refreshServer(model.index)
                    }
                }
            }
        }
        Rectangle {
            id: square2
            width: 200
            height: 30
            anchors.top: serversListView.bottom
            color: "transparent"
            z: 10
            PlasmaComponents.Label {
                id: nameText3
                color: textColor
                font.pixelSize: 10
                height: parent.height
                width: parent.width
                text: isPlaying(
                          ) ? i18n("Bitrate:") + ' ' + Math.round(
                                  playMusic.metaData.audioBitRate / 1000) + 'Kb/s, ' + i18n(
                                  "Genre:") + ' '
                              + playMusic.metaData.genre : playMusic.bufferProgress < 1
                              && play.running == true ? i18n("Buffering") + ' ' + Math.round(playMusic.bufferProgress * 100) + "%" : i18n(
                                                            "Choose station and enjoy...")
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }
        }

        PlasmaComponents.Button {
            anchors.centerIn: parent
            text: i18n("Add stations")
            visible: serversModel.count == 0
            onClicked: plasmoid.action("configure").trigger()
        }
    }
    function reloadServerModel() {
        serversModel.clear()
        playMusic.stop()
        var servers = JSON.parse(plasmoid.configuration.servers)
        for (var i = 0; i < servers.length; i++) {
            if (servers[i].active) {
                serversModel.append(servers[i])
            }
        }
    }
    function refreshServer(index) {
        if (isPlaying() && playMusic.source == serversModel.get(
                    index).hostname) {
            playMusic.stop()
            playMusic.source = ''
            serversModel.setProperty(index, "status", 0)
        } else {
            reloadServerModel()
            playMusic.source = serversModel.get(index).hostname
            serversModel.setProperty(index, "status", 1)
            play.restart()
        }
    }
    Timer {
        id: play
        interval: 200
        repeat: false
        running: false
        onTriggered: {
            if (playMusic.bufferProgress == 1) {
                playMusic.play()
                play.stop()
            } else {
                play.restart()
            }
        }
    }

    //    function copyselect() {
    //        nameText2.selectAll()
    //        nameText2.copy()
    //        nameText2.deselect()
    //    }
    function isPlaying() {
        return playMusic.playbackState == MediaPlayer.PlayingState
    }
}
