/*
 * Copyright (C) 2016 The Qt Company Ltd.
 * Copyright (C) 2019 Yoshito Momiyama
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import QtQuick 2.6
import QtQuick.Window 2.12
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0
import QtMultimedia 5.6
import MediaPlayer 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1920
    height: 1080
    color: "#222222"
    title: qsTr("momiplayer")

    MediaPlayer {
        id: player
        audioRole: MediaPlayer.MusicRole
        autoLoad: true
        playlist: playlist
        function time2str(value) {
            return Qt.formatTime(new Date(value), 'mm:ss')
        }
        onPositionChanged: slider.value = player.position
    }

    Item {
        x: 0
        y: 0
        width: 920
        height: 1080
        clip: true

        Item {
            id: infopanel
            x: 30
            y: 100
            height :400
            width : 920-30

            ColumnLayout {
                anchors.fill: parent
                Label {
                    id: title
                    font.pixelSize: 48
                    color: '#ffffffff'
                    Layout.alignment: Layout.right
                    text: "Title:   " + (player.metaData.title ? player.metaData.title : 'No Data')
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }
                Label {
                    id: artist
                    font.pixelSize: 48
                    color: '#ffffffff'
                    Layout.alignment: Layout.right
                    text: "Artist:  " + (player.metaData.contributingArtist ? player.metaData.contributingArtist : 'No Data')
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }
                Label {
                    id: audiocodec
                    font.pixelSize: 38
                    color: '#ffffffff'
                    Layout.alignment: Layout.right
                    text: "Codec:   " + (player.metaData.audioCodec ? player.metaData.audioCodec : 'No Data')
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }
                Label {
                    id: audiobitrate
                    font.pixelSize: 38
                    color: '#ffffffff'
                    Layout.alignment: Layout.right
                    text: "BitRate:  " + (player.metaData.audioBitRate ? (player.metaData.audioBitRate + 'bps') : 'No Data')
                    horizontalAlignment: Label.AlignHCenter
                    verticalAlignment: Label.AlignVCenter
                }
            }

        }

        Item {
            x: 0
            y: 100+512
            height :300
            width : 920
            Rectangle {
                anchors.fill: parent
                color: '#444444'
                //opacity: 0.75
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: root.width * 0.02
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Row {
                        spacing: 20
                        ToggleButton {
                            id: random
                            offImage: './images/AGL_MediaPlayer_Shuffle_Inactive.svg'
                            onImage: './images/AGL_MediaPlayer_Shuffle_Active.svg'
                        }
                        ToggleButton {
                            id: loop
                            offImage: './images/AGL_MediaPlayer_Loop_Inactive.svg'
                            onImage: './images/AGL_MediaPlayer_Loop_Active.svg'
                        }
                    }
                }
                Slider {
                    id: slider
                    Layout.fillWidth: true
                    to: player.duration
                    Label {
                        id: position
                        anchors.left: parent.left
                        anchors.bottom: parent.top
                        font.pixelSize: 32
                        text: player.time2str(player.position)
                    }
                    Label {
                        id: duration
                        anchors.right: parent.right
                        anchors.bottom: parent.top
                        font.pixelSize: 32
                        text: player.time2str(player.duration)
                    }
                    onPressedChanged: player.seek(value)
                }
                RowLayout {
                    Layout.fillHeight: true
                    Item { Layout.fillWidth: true }
                    ImageButton {
                        offImage: './images/AGL_MediaPlayer_BackArrow.svg'
                        onClicked: playlist.previous()
                    }
                    ImageButton {
                        id: play
                        offImage: './images/AGL_MediaPlayer_Player_Play.svg'
                        onClicked: player.play()
                        states: [
                            State {
                                when: player.playbackState === MediaPlayer.PlayingState
                                PropertyChanges {
                                    target: play
                                    offImage: './images/AGL_MediaPlayer_Player_Pause.svg'
                                    onClicked: player.pause()
                                }
                            }
                        ]
                    }
                    ImageButton {
                        offImage: './images/AGL_MediaPlayer_ForwardArrow.svg'
                        onClicked: playlist.next()
                    }

                    Item { Layout.fillWidth: true }
                }
            }
        }
    }

    Item {
        x: 920
        y: 0
        width: 1000
        height: 1080
        ListView {
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            clip: true
            header: Label {
                x: 50
                text: 'PLAYLIST'
                opacity: 0.5
            }
            model: PlaylistWithMetadata {
                source: playlist
            }
            currentIndex: playlist.currentIndex

            delegate: MouseArea {
                id: delegate
                width: ListView.view.width
                height: ListView.view.height / 4
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.rightMargin: 50
                    Image {
                        source: model.coverArt
                        fillMode: Image.PreserveAspectFit
                        Layout.preferredWidth: delegate.height
                        Layout.preferredHeight: delegate.height
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Label {
                            Layout.fillWidth: true
                            text: model.title
                            color: '#66FF99'
                            font.pixelSize: 48
                        }
                        Label {
                            Layout.fillWidth: true
                            text: model.artist
                            color: '#66FF99'
                            font.pixelSize: 32
                        }
                    }
                    Label {
                        text: player.time2str(model.duration)
                        color: '#66FF99'
                        font.pixelSize: 32
                    }
                }
                onClicked: {
                    playlist.currentIndex = model.index
                    player.play()
                }
            }

            highlight: Rectangle {
                color: 'white'
                opacity: 0.25
            }
        }
    }

    Playlist {
        id: playlist
        playbackMode: random.checked ? Playlist.Random : loop.checked ? Playlist.Loop : Playlist.Sequential

        Component.onCompleted: {
            playlist.addItems(mediaFiles)
        }
    }
}
