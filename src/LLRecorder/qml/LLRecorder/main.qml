import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtMultimedia 5.0
import Qt.labs.folderlistmodel 2.1
import com.nobo66.qaudiorecorderplugin 1.0
import com.nobo66.filesystem 1.0

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
                text:fileDialog.folder
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
                id:tfSaveFile
                property int count:01
                width:tfSaveFolder.width
                text:"FileName"
                onTextChanged: {
                    count = 01
                }
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
            id:tblview
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
            Button{
                width: bt_rec.width
                height: bt_rec.height
                action:playAction
            }
            Button{
                width: bt_rec.width
                height: bt_rec.height
                action:deleteAction
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
        //暫定処理
        //ToDo:保存ファイルから取得する
        Component.onCompleted: {
            fileDialog.folder = "file:///Users/nobo66/Music/LLRecorder"
        }

    }

    AudioRecorder{
        id:recorder
        source:tfSaveFolder.text+"/"+tfSaveFile.text+"_"+tfSaveFile.count
        onFileExists:{
            console.log("fileExists")
            tfSaveFile.count++
            recorder.record()
        }
    }
    Audio{
        id:player
    }
    FileAccessor{
        id:fileAccessor
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
            console.log("[LLRecorder]record!!")
            recorder.record()
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
            tfSaveFile.count++
        }

        tooltip: "Start recording"
    }
    Action {
        id: stopAction
        text: "Stop(F6)"
        shortcut: "F6"
        onTriggered: {
            console.log("[LLRecorder]stop!!")
            recorder.stop()
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
        }
        tooltip: "Stop recording"
    }
    Action {
        id: playAction
        text: "Play(F7)"
        shortcut: "F7"
        onTriggered: {
            console.log("[LLRecorder]play!!")
            player.source = folderModel.get(tblview.currentRow, "filePath")
            player.play()
        }
        tooltip: "Play selected file"
    }
    Action {
        id: deleteAction
        text: "Delete(F8)"
        shortcut: "F8"
        onTriggered: {
            fileAccessor.remove(folderModel.get(tblview.currentRow, "filePath"))
            tfSaveFile.count = 1
        }
        tooltip: "Delete selected file"
    }

}
