/*
 *  SPDX-FileCopyrightText: 2024 Ludgie
 *  SPDX-FileCopyrightText: 2022 ivan (@ratijas) tkachenko <me@ratijas.tk>
 *
 *  SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick

import org.kde.kirigami as Kirigami
import org.kde.plasma.extras as PlasmaExtras

ListDelegate {
    id: item

    PlasmaExtras.Highlight {
        id: delegateHighlight
        visible: false
        hovered: true
        z: -1
    }
    highlight: delegateHighlight

    activeFocusOnTab: true

    iconItem: Kirigami.Icon {
        anchors.fill: parent
        source: item.icon.name
    }
}
