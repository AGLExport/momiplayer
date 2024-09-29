// Copyright (C) 2023 The Qt Company Ltd.
// Copyright (C) 2024 Automotive Grade Linux
// SPDX-License-Identifier: GPL-3.0+

pragma Singleton
import QtQuick

QtObject {
    enum Theme {
        Light,
        Dark
    }

    property int activeTheme : Config.Theme.Dark

    readonly property bool isMobileTarget : Qt.platform.os === "android" || Qt.platform.os === "ios"
    readonly property color mainColor : activeTheme ? "#09102B" : "#FFFFFF"
    readonly property color secondaryColor : activeTheme ? "#FFFFFF" : "#09102B"

    function iconSource(fileName, addSuffix = true) {
        return `qrc:/qt/qml/MediaControls/icons/${fileName}${activeTheme === Config.Theme.Dark && addSuffix ? "_Dark.svg" : ".svg"}`
    }
}
