import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import Qt.labs.folderlistmodel 2.1
import com.nobo66.qaudiorecorderplugin 1.0

ApplicationWindow {
    id:root
    title: qsTr("LLRecorder")
    width: 900
    height: 480

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }
    Column{
        id:colContentsRoot
        spacing: 10
        anchors.fill: parent
        anchors.margins: 10
        Row{
            Label{
                id:lbSaveFolder
                width: 150
                text:qsTr("save folder:")
            }
            TextField{
                id:tfSaveFolder
                width:colContentsRoot.width - lbSaveFolder.width - btSaveFolder.width
            }
            Button {
                id:btSaveFolder
                text: qsTr("Select Folder")
                action: openAction
            }
        }
        Row{
            Label{
                text:qsTr("file name:")
                width:lbSaveFolder.width
            }
            TextField{
                width:tfSaveFolder.width
            }
        }
        Row{
            Label{
                text:qsTr("album name(id3tag):")
                width:lbSaveFolder.width
            }
            TextField{
                width:tfSaveFolder.width
                text:qsTr("not supported")
                enabled: false
            }
        }
        Row{
            Label{
                text:qsTr("song name(id3tag):")
                width:lbSaveFolder.width
            }
            TextField{
                width:tfSaveFolder.width
                text:qsTr("not supported")
                enabled: false
            }
        }
        Label{
            text:qsTr("recorded files:")
        }
        TableView {
            width:colContentsRoot.width
            height: (colContentsRoot.height - (y-colContentsRoot.y) - bt_rec.height - colContentsRoot.spacing - colContentsRoot.anchors.bottomMargin)

            focus:true
            TableViewColumn{ role: "fileName"  ; title: "File" ; width: 300 }
            TableViewColumn{ role: "album" ; title: "Album" }
            model: folderModel
            Keys.onPressed: {
                console.log("key pressed")
            }
            Keys.onDeletePressed: {
                console.log("delete pressed")
            }
        }
        Row{
            spacing: 10
            Button{
                id:bt_rec
                width: 100
                height: 100
                action:recordAction
            }
            Button{
                width: bt_rec.width
                height: bt_rec.height
                action:stopAction
            }
        }
    }

    FolderListModel{
        id:folderModel
        folder:tfSaveFolder.text
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        selectFolder: true
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            tfSaveFolder.text = folder
        }
        onRejected: {
            console.log("Canceled")
        }
    }

    AudioRecorder{
        id:recorder
    }

    Action {
        id: openAction
        text: "&Open"
        shortcut: "Ctrl+O"
        onTriggered: fileDialog.open()
        tooltip: "Open an Image"
    }
    Action {
        id: recordAction
        text: "Record(F5)"
        shortcut: "F5"
        onTriggered: {
            console.log("record!!")
        }

        tooltip: "Start recording"
    }
    Action {
        id: stopAction
        text: "Stop(F6)"
        shortcut: "F6"
        onTriggered: {
            console.log("stop!!")
        }
        tooltip: "Stop recording"
    }

}
