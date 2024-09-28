// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Fusion
import QtMultimedia
import Config

Rectangle {
    id: root
    implicitWidth: 380
    color: Config.mainColor
    border.color: "lightgrey"
    radius: 10

    property alias metadataInfo: metadataInfo
    required property MediaPlayer mediaPlayer
    required property int selectedAudioTrack
    required property int selectedVideoTrack
    required property int selectedSubtitleTrack

    MouseArea {
        anchors.fill: root
        preventStealing: true
    }

    Item {
        id: bar
        anchors.fill: root
        anchors.margins: 30

        Label {
            id: label
            font.bold: true
            font.pixelSize: 20
            text: qsTr("Metadata")
            color: Config.secondaryColor

            Layout.fillWidth: true
       }

       MetadataInfo {
           id: metadataInfo
           anchors.fill: bar
           anchors.topMargin: label.height + 0
       }
    }
}
