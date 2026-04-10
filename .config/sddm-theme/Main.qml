import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "black"

    // Background Image
    Image {
        id: background
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        smooth: true
    }

    // Blur Effect for Background (Stronger)
    FastBlur {
        id: blurEffect
        anchors.fill: background
        source: background
        radius: 80
        cached: true
    }

    // Darker Overlay for better contrast
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.5
    }

    // Main Login Container
    Item {
        id: mainContainer
        anchors.centerIn: parent
        width: 450
        height: 600
        opacity: 0

        // Entry Animation
        NumberAnimation {
            target: mainContainer
            property: "opacity"
            from: 0
            to: 1
            duration: 1200
            easing.type: Easing.OutCubic
            running: true
        }

        NumberAnimation {
            target: mainContainer
            property: "y"
            from: root.height / 2 + 100
            to: root.height / 2 - 300
            duration: 1000
            easing.type: Easing.OutBack
            running: true
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 30

            // User Avatar (Large Circle with Image)
            Item {
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    id: avatarMask
                    anchors.fill: parent
                    radius: 80
                    color: "white"
                    visible: false
                }

                Image {
                    id: avatarImage
                    anchors.fill: parent
                    source: "assets/avatar.png"
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: false
                }

                OpacityMask {
                    anchors.fill: avatarMask
                    source: avatarImage
                    maskSource: avatarMask
                }

                // Border/Glow for Avatar
                Rectangle {
                    anchors.fill: parent
                    radius: 80
                    color: "transparent"
                    border.width: 3
                    border.color: Qt.rgba(1, 1, 1, 0.4)
                }

                // Fallback letter if image fails to load
                Text {
                    anchors.centerIn: parent
                    text: userModel.lastUser.charAt(0).toUpperCase()
                    color: "white"
                    font.family: config.font
                    font.pointSize: 48
                    font.bold: true
                    visible: avatarImage.status != Image.Ready
                }

                DropShadow {
                    anchors.fill: avatarMask
                    radius: 20
                    samples: 17
                    color: "black"
                    source: avatarMask
                    z: -1
                }
            }

            // Username
            Text {
                text: userModel.lastUser
                color: "white"
                font.family: config.font
                font.pointSize: 28
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
            }

            // Password Input (Pill Style)
            TextField {
                id: password
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                placeholderText: "Password"
                echoMode: TextInput.Password
                font.family: config.font
                font.pointSize: 14
                color: "white"
                horizontalAlignment: TextInput.AlignHCenter
                focus: true
                passwordCharacter: "•"

                // Typing Animation (Pulse Border on Input)
                SequentialAnimation {
                    id: pulseAnim
                    NumberAnimation { target: passBorder; property: "opacity"; from: 0.3; to: 1.0; duration: 150; easing.type: Easing.OutQuad }
                    NumberAnimation { target: passBorder; property: "opacity"; from: 1.0; to: 0.3; duration: 250; easing.type: Easing.InQuad }
                }

                onTextChanged: {
                    if (text.length > 0) pulseAnim.restart()
                }
                
                background: Rectangle {
                    id: passBorder
                    color: password.activeFocus ? Qt.rgba(1, 1, 1, 0.2) : Qt.rgba(1, 1, 1, 0.1)
                    radius: 30
                    border.width: 2
                    border.color: password.activeFocus ? "white" : Qt.rgba(1, 1, 1, 0.3)
                    opacity: 0.3 // Default opacity for the animation
                    
                    Behavior on color { ColorAnimation { duration: 200 } }
                    Behavior on border.color { ColorAnimation { duration: 200 } }
                }

                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(userModel.lastUser, password.text, sessionModel.lastIndex)
                    }
                }
            }

            // Login Status / Hint
            Text {
                id: statusLabel
                text: "Press Enter to Login"
                color: "white"
                font.family: config.font
                font.pointSize: 10
                opacity: 0.6
                Layout.alignment: Qt.AlignHCenter
            }

            Item { Layout.fillHeight: true }

            // Bottom Buttons (Power)
            RowLayout {
                Layout.fillWidth: true
                spacing: 40

                Button {
                    text: "Shutdown"
                    font.family: config.font
                    flat: true
                    contentItem: Text {
                        text: parent.text
                        color: parent.hovered ? "white" : Qt.rgba(1, 1, 1, 0.6)
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                    }
                    onClicked: sddm.powerOff()
                }

                Item { Layout.fillWidth: true }

                Button {
                    text: "Reboot"
                    font.family: config.font
                    flat: true
                    contentItem: Text {
                        text: parent.text
                        color: parent.hovered ? "white" : Qt.rgba(1, 1, 1, 0.6)
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                    }
                    onClicked: sddm.reboot()
                }
            }
        }
    }
}
