// Copyright (C) 2023 The Qt Company Ltd.
// Copyright (C) 2024 Automotive Grade Linux
// SPDX-License-Identifier: GPL-3.0+

import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Effects

Button {
    id: control
    flat: true

    contentItem: Image {
        id: image
        source: control.icon.source
    }

    background: MultiEffect {
        source: image
        anchors.fill: control
        visible: control.down
        opacity: 0.5
        shadowEnabled: true
        blurEnabled: true
        blur: 0.5
    }
}
