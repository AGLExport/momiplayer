// Copyright (C) 2023 The Qt Company Ltd.
// Copyright (C) 2024 Automotive Grade Linux
// SPDX-License-Identifier: GPL-3.0+

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import Config

Item {
    id: root

    function clear() {
        elements.clear()
    }

    function read(metadata) {
        if (metadata) {
            for (var key of metadata.keys()) {
                if (metadata.stringValue(key)) {
                    elements.append({
                        name: metadata.metaDataKeyToString(key),
                        value: metadata.stringValue(key)
                    })
                }
            }
        }
    }

    ListModel {
        id: elements
    }

    Item {
        anchors.fill: parent
        anchors.margins: 15

        ListView {
            id: metadataList
            anchors.fill: parent
            spacing: 15
            model: elements
            delegate: ColumnLayout {
                id: row
                width: metadataList.width

                required property string name
                required property string value

                Label {
                    text: row.name + ":"
                    font.bold: true
                    font.pixelSize: 20
                    color: Config.secondaryColor

                    Layout.preferredWidth: root.width / 2
                }
                Label {
                    text: row.value
                    font.pixelSize: 16
                    wrapMode: Text.WrapAnywhere
                    color: Config.secondaryColor

                    Layout.fillWidth: true
                }
            }
        }

        Label {
            visible: !elements.count
            font.pixelSize: 16
            text: qsTr("No metadata present")
            anchors.centerIn: parent
            color: Config.secondaryColor
        }
    }
}
