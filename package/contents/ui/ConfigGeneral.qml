/*
 * SPDX-FileCopyrightText: 2024 Ludgie <ludg1e@hotmail.com>
 * SPDX-FileCopyrightText: 2024 Davide Sandonà <sandona.davide@gmail.com>
 * SPDX-FileCopyrightText: 2015 Kai Uwe Broulik <kde@privat.broulik.de>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Controls as QtControls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.ksvg as KSvg
import org.kde.iconthemes as KIconThemes
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

KCM.SimpleKCM {
    property bool cfg_showFullName
    property string cfg_icon: icon.text
    property alias cfg_showUser: showUser.checked
    property alias cfg_showSysInfo: showSysInfo.checked
    property alias cfg_showSettings: showSettings.checked
    property alias cfg_showReconfigure: showReconfigure.checked
    property alias cfg_showLock: showLock.checked
    property alias cfg_showLogOut: showLogOut.checked
    property alias cfg_showSwitchUser: showSwitchUser.checked
    property alias cfg_showSleep: showSleep.checked
    property alias cfg_showHibernate: showHibernate.checked
    property alias cfg_showRestart: showRestart.checked
    property alias cfg_showShutDown: showShutDown.checked
    
    Kirigami.FormLayout {
        QtControls.ButtonGroup {
            id: nameGroup
        }

        QtControls.RadioButton {
            id: showFullNameRadio

            Kirigami.FormData.label: ("@title:label", "Username style:")

            QtControls.ButtonGroup.group: nameGroup
            text: ("@option:radio", "Full name (if available)")
            checked: cfg_showFullName
            onClicked: if (checked) cfg_showFullName = true;
        }

        QtControls.RadioButton {
            QtControls.ButtonGroup.group: nameGroup
            text: ("@option:radio", "Login username")
            checked: !cfg_showFullName
            onClicked: if (checked) cfg_showFullName = false;
        }


        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.ButtonGroup {
            id: layoutGroup
        }

        Item {
            Kirigami.FormData.isSection: true
        }

        QQC2.Button {
            id: iconButton

            Kirigami.FormData.label: ("Icon:")

            implicitWidth: previewFrame.width + Kirigami.Units.smallSpacing * 2
            implicitHeight: previewFrame.height + Kirigami.Units.smallSpacing * 2
            hoverEnabled: true

            Accessible.name: ("@action:button", "Change Application Launcher's icon")
            Accessible.description: ("@info:whatsthis", "Current icon is %1. Click to open menu to change the current icon or reset to the default icon.", cfg_icon)
            Accessible.role: Accessible.ButtonMenu

            QQC2.ToolTip.delay: Kirigami.Units.toolTipDelay
            QQC2.ToolTip.text: ("@info:tooltip", "Icon name is \"%1\"", cfg_icon)
            QQC2.ToolTip.visible: iconButton.hovered && cfg_icon.length > 0

            KIconThemes.IconDialog {
                id: iconDialog
                onIconNameChanged: {
                    cfg_icon = iconName || "system-shutdown"
                }
            }

            onPressed: iconMenu.opened ? iconMenu.close() : iconMenu.open()

            KSvg.FrameSvgItem {
                id: previewFrame
                anchors.centerIn: parent
                imagePath: Plasmoid.formFactor === PlasmaCore.Types.Vertical || Plasmoid.formFactor === PlasmaCore.Types.Horizontal
                ? "widgets/panel-background" : "widgets/background"
                width: Kirigami.Units.iconSizes.large + fixedMargins.left + fixedMargins.right
                height: Kirigami.Units.iconSizes.large + fixedMargins.top + fixedMargins.bottom

                Kirigami.Icon {
                    anchors.centerIn: parent
                    width: Kirigami.Units.iconSizes.large
                    height: width
                    source: cfg_icon
                }
            }

            QQC2.Menu {
                id: iconMenu

                // Appear below the button
                y: parent.height

                QQC2.MenuItem {
                    text: ("@item:inmenu Open icon chooser dialog", "Choose…")
                    icon.name: "document-open-folder"
                    Accessible.description: ("@info:whatsthis", "Choose an icon for Application Launcher")
                    onClicked: iconDialog.open()
                }
                QQC2.MenuItem {
                    text: ("@item:inmenu Reset icon to default", "Reset to default icon")
                    icon.name: "edit-clear"
                    enabled: cfg_icon !== "plasma-symbolic"
                    onClicked: cfg_icon = "plasma-symbolic"
                }
            }
        }

        Item {
            Kirigami.FormData.isSection: true
        }


        QtControls.CheckBox {
            Kirigami.FormData.label: ("@title:label", "Menu entries:")
            id: showUser
            text: ("@option:check", "Users")
        }

        QtControls.CheckBox {
            id: showSysInfo
            text: ("@option:check", "About this System")
        }

        QtControls.CheckBox {
            id: showSettings
            text: ("@option:check", "System Settings")
        }

        QtControls.CheckBox {
            id: showReconfigure
            text: ("@option:check", "Reconfigure")
        }

        QtControls.CheckBox {
            id: showLock
            text: ("@option:check", "Lock")
        }

        QtControls.CheckBox {
            id: showLogOut
            text: ("@option:check", "Log Out")
        }

        QtControls.CheckBox {
            id: showSwitchUser
            text: ("@option:check", "Switch User")
        }

        QtControls.CheckBox {
            id: showSleep
            text: ("@option:check", "Sleep")
        }

        QtControls.CheckBox {
            id: showHibernate
            text: ("@option:check", "Hibernate")
        }

        QtControls.CheckBox {
            id: showRestart
            text: ("@option:check", "Restart")
        }

        QtControls.CheckBox {
            id: showShutDown
            text: ("@option:check", "Shut Down")
        }
    }
}
