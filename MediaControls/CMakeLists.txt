qt_add_library(MediaControls STATIC)

target_link_libraries(MediaControls PRIVATE Qt6::Quick)

qt_add_qml_module(MediaControls
    URI "MediaControls"
    OUTPUT_DIRECTORY MediaControls
    QML_FILES
        "AudioControl.qml"
        "PlaybackSeekControl.qml"
        "PlaybackControl.qml"
        "CustomSlider.qml"
        "CustomButton.qml"
    RESOURCES
        "../icons/Rate_Icon_Dark.svg"
        "../icons/Loop_Icon_Dark.svg"
        "../icons/Play_Icon.svg"
        "../icons/Previous_Icon_Dark.svg"
        "../icons/Next_Icon_Dark.svg"
        "../icons/Volume_Icon_Dark.svg"
        "../icons/Playlist_Icon_Dark.svg"
        "../icons/Settings_Icon_Dark.svg"
        "../icons/FullScreen_Icon_Dark.svg"
        "../icons/Stop_Icon.svg"
        "../icons/Loop_Playlist.svg"
        "../icons/Single_Loop.svg"
        "../icons/Playlist_Active.svg"
        "../icons/Add_file_Dark.svg"
        "../icons/Movie_Icon_Dark.svg"
        "../icons/Music_Icon_Dark.svg"
        "../icons/Music_Active.svg"
        "../icons/Movie_Active.svg"
        "../icons/Shuffle_Icon_Dark.svg"
        "../icons/Shuffle_Active.svg"
        "../icons/Default_CoverArt.svg"
        "../icons/Cancel_Button.svg"
        "../icons/Load_Button.svg"
        "../icons/Shadow.png"
        "../icons/Warning_Icon.svg"
        "../icons/Menu_Icon_Dark.svg"
        "../icons/Mute_Icon_Dark.svg"
        "../icons/Error.svg"

)
