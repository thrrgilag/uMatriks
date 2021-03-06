import QtQuick 2.4
import Ubuntu.Components 1.3
import Matrix 1.0
import "components"


Rectangle {
    id: root

    property Connection currentConnection: null
    property var currentRoom: null

    function setRoom(room) {
        currentRoom = room
        messageModel.changeRoom(room)
        console.log("ChatRoom setting room: "+ room.name)
        room.markAllMessagesAsRead()
        chatView.positionViewAtIndex(room.notificationCount() - 1, ListView.Beginning)
    }

    function setConnection(conn) {
        currentConnection = conn
        messageModel.setConnection(conn)
    }

    function sendLine(text) {
        console.log("Sending: " + text)
        console.log("Room: " + currentRoom)
        console.log("Conn: " + currentConnection)
        if(!currentRoom || !currentConnection) {
            return
        }
        currentConnection.postMessage(currentRoom, "m.text", text)
        chatView.positionViewAtBeginning()
    }

    ListView {
        id: chatView
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        verticalLayoutDirection: ListView.BottomToTop
        spacing: units.gu(2)
        model: MessageEventModel { id: messageModel }

        delegate: ChatBubble {
            id: chatBubble
            width: parent.width
            room: currentRoom
        }

        onAtYBeginningChanged: {
            if(currentRoom && atYBeginning) currentRoom.getPreviousContent(50)
        }

        Scrollbar {
            id: scrollBar
            align: Qt.AlignTrailing
        }
    }
}
