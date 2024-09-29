// Copyright (C) 2023 The Qt Company Ltd.
// Copyright (C) 2024 Automotive Grade Linux
// SPDX-License-Identifier: GPL-3.0+

import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtMultimedia
import Config

Item {
    id: root
    implicitHeight: 40

    required property MediaPlayer mediaPlayer
    property alias isMediaSliderPressed: mediaSlider.pressed

    function getTime(time : int) {
        const h = Math.floor(time / 3600000).toString()
        const m = Math.floor(time / 60000).toString()
        const s = Math.floor(time / 1000 - m * 60).toString()
        return `${h.padStart(2,'0')}:${m.padStart(2,'0')}:${s.padStart(2, '0')}`
    }

    RowLayout {
        anchors.fill: root
        anchors.leftMargin: 200
        anchors.rightMargin: 200

        Label {
            id: mediaTime
            color: Config.secondaryColor
            font.bold: true
            text: root.getTime(root.mediaPlayer.position)
        }

        CustomSlider {
            id: mediaSlider
            backgroundColor: !Config.activeTheme ? "white" : "#41CD52"
            backgroundOpacity: !Config.activeTheme ? 0.8 : 0.2
            enabled: root.mediaPlayer.seekable
            to: 1.0
            value: root.mediaPlayer.position / root.mediaPlayer.duration

            Layout.fillWidth: true

            onMoved: root.mediaPlayer.setPosition(value * root.mediaPlayer.duration)
        }

        Label {
            id: durationTime
            color: Config.secondaryColor
            font.bold: true
            text: root.getTime(root.mediaPlayer.duration)
        }

    }
}
