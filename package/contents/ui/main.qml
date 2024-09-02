/*
 *  SPDX-FileCopyrightText: 2024 Ludgie <ludg1e@hotmail.com>
 *  SPDX-FileCopyrightText: 2024 Davide Sandonà <sandona.davide@gmail.com>
 *  SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiComponents
import org.kde.config as KConfig  // KAuthorized.authorizeControlModule
import org.kde.coreaddons as KCoreAddons // kuser
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kcmutils as KCMUtils
import org.kde.plasma.extras as PlasmaExtras

import org.kde.plasma.private.sessions as Sessions

import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    // from configuration
    readonly property bool showFullName: Plasmoid.configuration.showFullName
    property string icon: Plasmoid.configuration.icon
    readonly property bool showUser: Plasmoid.configuration.showUser
    readonly property bool showSysInfo: Plasmoid.configuration.showSysInfo
    readonly property bool showSettings: Plasmoid.configuration.showSettings
    readonly property bool showReconfigure: Plasmoid.configuration.showReconfigure
    readonly property bool showLock: Plasmoid.configuration.showLock
    readonly property bool showLogOut: Plasmoid.configuration.showLogOut
    readonly property bool showSwitchUser: Plasmoid.configuration.showSwitchUser
    readonly property bool showSleep: Plasmoid.configuration.showSleep
    readonly property bool showHibernate: Plasmoid.configuration.showHibernate
    readonly property bool showRestart: Plasmoid.configuration.showRestart
    readonly property bool showShutDown: Plasmoid.configuration.showShutDown

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool inPanel: (Plasmoid.location === PlasmaCore.Types.TopEdge
        || Plasmoid.location === PlasmaCore.Types.RightEdge
        || Plasmoid.location === PlasmaCore.Types.BottomEdge
        || Plasmoid.location === PlasmaCore.Types.LeftEdge)
    
    readonly property string avatarIcon: kuser.faceIconUrl.toString()
    readonly property string displayedName: showFullName ? kuser.fullName : kuser.loginName

    // switchWidth: Kirigami.Units.gridUnit * 10
    // switchHeight: Kirigami.Units.gridUnit * 12

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: function(source, data) {
            disconnectSource(source)
        }

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    toolTipTextFormat: Text.StyledText
    toolTipSubText: i18n("You are logged in as %1", displayedName)

    Plasmoid.icon: icon

    KCoreAddons.KUser {
        id: kuser
    }

    fullRepresentation: Item {
        id: fullRoot

        implicitHeight: column.implicitHeight
        implicitWidth: column.implicitWidth

        Layout.preferredWidth: Kirigami.Units.gridUnit * 12
        Layout.preferredHeight: implicitHeight
        Layout.minimumWidth: Layout.preferredWidth
        Layout.minimumHeight: Layout.preferredHeight
        Layout.maximumWidth: Layout.preferredWidth
        Layout.maximumHeight: Screen.height / 2

        Sessions.SessionManagement {
            id: sessionManagement
        }

        Sessions.SessionsModel {
            id: sessionsModel
        }

        ColumnLayout {
            id: column

            anchors.fill: parent
            spacing: 0  

            ActionListDelegate {
                id: currentUserItem
                text: root.displayedName
                subText: "Current user"
                source: root.avatarIcon
                onClicked: KCMUtils.KCMLauncher.openSystemSettings("kcm_users")

                ToolTip.visible: hovered
                ToolTip.text: "Open user settings"
                ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
                
                property alias source: avatar.source

                iconItem: KirigamiComponents.AvatarButton {
                    id: avatar

                    anchors.fill: parent
                    name: currentUserItem.text  
                }
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                visible: true
            }

            ActionListDelegate {
                id: sysInfoButton
                text: ("@action", "About this System")
                icon.name: "documentinfo-symbolic"
                visible: showSysInfo
                onClicked: KCMUtils.KCMLauncher.openInfoCenter("")
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                visible: true
            }

            ActionListDelegate {
                id: settingsButton
                text: ("@action", "System Settings")
                icon.name: "settings-configure-symbolic"
                visible: showSettings 
                onClicked: KCMUtils.KCMLauncher.openSystemSettings("");
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                visible: true
            }

            ActionListDelegate {
                id: reconfigureButton
                text: ("@action", "Restart KDE Plasma")
                icon.name: "help-contents-symbolic"
                visible: showReconfigure
                onClicked: executable.exec("systemctl --user restart plasma-plasmashell")
                // systemctl --user (add more commands/services to restart?)
            }

            ActionListDelegate {
                id: lockButton
                text: ("@action", "Lock")
                icon.name: "system-lock-screen"
                visible: sessionManagement.canLock && showLock
                onClicked: sessionManagement.lock()
            }

            ActionListDelegate {
                id: logOutButton
                text: ("@action", "Log Out")
                icon.name: "system-log-out"
                visible: sessionManagement.canLogout && showLogOut
                onClicked: sessionManagement.requestLogout(1)
            }

            ActionListDelegate {
                id: switchUserButton
                text: ("@action", "Switch user")
                icon.name: "system-switch-user"
                visible: sessionsModel.canStartNewSession && showSwitchUser
                onClicked: sessionsModel.startNewSession(sessionsModel.shouldLock)
            }

            Kirigami.Separator {
                Layout.fillWidth: true
                visible: true
            }

            ActionListDelegate {
                id: sleepButton
                text: ("@action", "Sleep")
                icon.name: "system-suspend"
                visible: sessionManagement.canSuspend && showSleep
                onClicked: sessionManagement.suspend()
            }

            ActionListDelegate {
                id: hibernateButton
                text: ("@action", "Hibernate")
                icon.name: "system-suspend-hibernate"
                visible: sessionManagement.canHybridSuspend && showHibernate
                onClicked: sessionManagement.hybridSuspend()
            }

            ActionListDelegate {
                id: restartButton
                text: ("@action", "Restart")
                icon.name: "system-reboot"
                visible: sessionManagement.canReboot && showRestart
                onClicked: sessionManagement.requestReboot(1)
            }

            ActionListDelegate {
                id: shutDownButton
                text: ("@action", "Shut Down")
                icon.name: "system-shutdown"
                visible: sessionManagement.canShutdown && showShutDown
                onClicked: sessionManagement.requestShutdown(1)
            }
        }

        Connections {
            target: root
            function onExpandedChanged() {
                if (root.expanded) {
                    sessionsModel.reload();
                }
            }
        }
    }
}
