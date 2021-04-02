import QtQuick 2.1
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kquickcontrols 2.0 as KQuickControls
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Controls 2.5 as QQC2

Item {
    id: configAppearance
    Layout.fillWidth: true
    property string cfg_icon: plasmoid.configuration.icon
    property alias cfg_fontColor: fontColor.color
    property bool cfg_transback: plasmoid.configuration.transback
    property bool cfg_Notification: plasmoid.configuration.Notification
    ColumnLayout {
        GridLayout {
            columns: 2

            Label {
                text: i18n("Icon:")
            }

            IconPicker {
                currentIcon: cfg_icon
                defaultIcon: "audio-radio-symbolic"
                onIconChanged: cfg_icon = iconName
                enabled: true
            }
        }
        ColumnLayout {
            CheckBox {
                text: i18n("Show notification on track change")
                checked: cfg_Notification
                onClicked: {
                    cfg_Notification = checked
                }
            }
            CheckBox {
                text: i18n("Disable background for desktop representation")
                checked: cfg_transback
                onClicked: {
                    cfg_transback = checked
                }
            }
        }
        GridLayout {
            columns: 3
            PlasmaComponents.Label {
                text: i18n("Font Color:")
                visible: cfg_transback
            }

            KQuickControls.ColorButton {
                id: fontColor
                showAlphaChannel: false
                onColorChanged: {

                }
                visible: cfg_transback
            }
            QQC2.Button {
                text: i18n("Set Default")
                icon.name: "edit-clear"
                visible: cfg_transback
                onClicked: {
                    fontColor.color = PlasmaCore.ColorScope.textColor
                }
            }
        }
    }
}
