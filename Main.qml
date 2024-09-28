// Copyright (C) 2023 The Qt Company Ltd.
// Copyright (C) 2024 Automotive Grade Linux
// SPDX-License-Identifier: GPL-3.0+

import QtQuick
import QtQuick.Window
import QtQuick.Controls.Fusion
import QtMultimedia
import QtQuick.Effects
import QtCore
import Qt.labs.folderlistmodel
import MediaControls
import Config

ApplicationWindow {
    id: root
    width: 1920
    height: 1080
    visible: true
    color: Config.mainColor
    title: qsTr("Momi Player")

    property alias currentFile: playlistInfo.currentIndex
    property alias playlistLooped: playbackControl.isPlaylistLooped
    property alias metadataInfo: settingsInfo.metadataInfo

    function playMedia() {
        mediaPlayer.source = playlistInfo.getSource()
        mediaPlayer.play()
    }

    function closeOverlays() {
        settingsInfo.visible = false
        playlistInfo.visible = false
    }

    function showOverlay() {
        settingsInfo.visible = true
        playlistInfo.visible = true
    }

    function scanMediaFile() {
        for (var i = 0; i < mediaFolder.count; i++)  {
            playlistInfo.addFile(playlistInfo.mediaCount, mediaFolder.get(i, "fileUrl"))
        }
        if (0 < mediaFolder.count) {
            currentFile = 0
            playMedia()
        }
    }

    FolderListModel {
        id: mediaFolder
        showDirs: false
        folder: StandardPaths.standardLocations(StandardPaths.MusicLocation)[0]
        nameFilters: ["*.mp3", "*.wav", "*.mpg", "*.mpeg", "*.avi", "*.mp4", "*.wmv"]

        onStatusChanged: {
            if (mediaFolder.status == FolderListModel.Ready) {
                scanMediaFile()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: {
            if (!seeker.opacity) {
                if (videoOutput.fullScreen) {
                    showControls.start()
                }
            } else {
                timer.restart()
            }
        }
    }

    Timer {
        id: timer
        interval: 3000
        onTriggered: {
            if (!seeker.isMediaSliderPressed) {
                if (videoOutput.fullScreen) {
                    hideControls.start()
                }
            } else {
                timer.restart()
            }
        }
    }

    ErrorPopup {
        id: errorPopup
    }

    MediaPlayer {
        id: mediaPlayer

        videoOutput: videoOutput
        audioOutput: AudioOutput {
            id: audio
            volume: 100
        }

        function updateMetadata() {
            root.metadataInfo.clear()
            root.metadataInfo.read(mediaPlayer.metaData)
        }

        onMetaDataChanged: updateMetadata()
        onActiveTracksChanged: updateMetadata()
        onErrorOccurred: {
            errorPopup.errorMsg = mediaPlayer.errorString
            errorPopup.open()
        }
        onTracksChanged: {
            updateMetadata()
        }

        onMediaStatusChanged: {
            if ((MediaPlayer.EndOfMedia === mediaStatus && mediaPlayer.loops !== MediaPlayer.Infinite) &&
                    ((root.currentFile < playlistInfo.mediaCount - 1) || playlistInfo.isShuffled)) {
                if (!playlistInfo.isShuffled) {
                    ++root.currentFile
                }
                root.playMedia()
            } else if (MediaPlayer.EndOfMedia === mediaStatus && root.playlistLooped && playlistInfo.mediaCount) {
                root.currentFile = 0
                root.playMedia()
            }
        }
    }

    VideoOutput {
        id: videoOutput

        anchors.top: parent.top
        anchors.bottom: fullScreen ? parent.bottom : playbackControl.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: fullScreen ? 0 : 20
        anchors.rightMargin: fullScreen ? 0 : 20
        visible: mediaPlayer.hasVideo

        property bool fullScreen: false

        TapHandler {
            onDoubleTapped: {
                parent.fullScreen = !parent.fullScreen
            }
            onTapped: {
                root.closeOverlays()
            }
        }
    }

    Image {
        id: defaultCoverArt
        anchors.horizontalCenter: videoOutput.horizontalCenter
        anchors.verticalCenter: videoOutput.verticalCenter
        visible: !videoOutput.visible && mediaPlayer.hasAudio
        source: Config.iconSource("Default_CoverArt", false)
    }

    Rectangle {
        id: background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: seeker.opacity ? seeker.top : playbackControl.top
        color: Config.mainColor
        opacity: videoOutput.fullScreen ? 0.75 : 0.5
    }

    Image {
        id: shadow
        source: `qrc:/qt/qml/MediaControls/icons/Shadow.png`
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    PlaybackSeekControl {
        id: seeker
        anchors.left: playbackControl.left
        anchors.right: playbackControl.right
        anchors.bottom: playbackControl.top
        mediaPlayer: mediaPlayer
    }

    PlaybackControl {
        id: playbackControl

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        mediaPlayer: mediaPlayer
        isPlaylistVisible: playlistInfo.visible

        onPlayNextFile: {
            if (playlistInfo.mediaCount) {
                if (!playlistInfo.isShuffled){
                    ++root.currentFile
                    if (root.currentFile > playlistInfo.mediaCount - 1 && root.playlistLooped) {
                        root.currentFile = 0
                    } else if (root.currentFile > playlistInfo.mediaCount - 1 && !root.playlistLooped) {
                        --root.currentFile
                        return
                    }
                }
                root.playMedia()
            }
        }

        onPlayPreviousFile: {
            if (playlistInfo.mediaCount) {
                if (!playlistInfo.isShuffled){
                    --root.currentFile
                    if (root.currentFile < 0 && isPlaylistLooped) {
                        root.currentFile = playlistInfo.mediaCount - 1
                    } else if (root.currentFile < 0 && !root.playlistLooped) {
                        ++root.currentFile
                        return
                    }
                }
                root.playMedia()
            }
        }

        playlistButton.onClicked: !playlistInfo.visible ? root.showOverlay() : root.closeOverlays()
    }

    MultiEffect {
        source: settingsInfo
        anchors.fill: settingsInfo
        shadowEnabled: settingsInfo.visible || playlistInfo.visible
        visible: settingsInfo.visible || playlistInfo.visible
    }

    PlaylistInfo {
        id: playlistInfo

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: seeker.opacity ? seeker.top : playbackControl.top
        anchors.topMargin: 10
        anchors.rightMargin: 5

        visible: false
        isShuffled: playbackControl.isPlaylistShuffled

        onPlaylistUpdated: {
            if (mediaPlayer.playbackState == MediaPlayer.StoppedState && root.currentFile < playlistInfo.mediaCount - 1) {
                ++root.currentFile
                root.playMedia()
            }
        }

        onCurrentFileRemoved: {
            mediaPlayer.stop()
            if (root.currentFile < playlistInfo.mediaCount - 1) {
                root.playMedia()
            } else if (playlistInfo.mediaCount) {
                --root.currentFile
                root.playMedia()
            }
        }
    }

    SettingsInfo {
        id: settingsInfo

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: seeker.opacity ? seeker.top : playbackControl.top
        anchors.topMargin: 10
        anchors.rightMargin: 5

        mediaPlayer: mediaPlayer
        selectedAudioTrack: mediaPlayer.activeAudioTrack
        selectedVideoTrack: mediaPlayer.activeVideoTrack
        selectedSubtitleTrack: mediaPlayer.activeSubtitleTrack
        visible: false
    }

    ParallelAnimation {
        id: hideControls

        NumberAnimation {
            targets: [playbackControl, seeker, background, shadow]
            property: "opacity"
            to: 0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: playbackControl
            property: "anchors.bottomMargin"
            to: -playbackControl.height - seeker.height
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }

    ParallelAnimation {
        id: showControls

        NumberAnimation {
            targets: [playbackControl, seeker, shadow]
            property: "opacity"
            to: 1
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: background
            property: "opacity"
            to: 0.5
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: playbackControl
            property: "anchors.bottomMargin"
            to: 0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }
}
