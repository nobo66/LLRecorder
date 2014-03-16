import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtMultimedia 5.0
import Qt.labs.folderlistmodel 2.1
import com.nobo66.qaudiorecorderplugin 1.0
import com.nobo66.filesystem 1.0
import com.nobo66.settingmanager 1.0

ApplicationWindow {
    id:root
    property real previousWidth:100
    property real previousHeight:0
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
    SplitView{
        id:contentRoot
        anchors.fill: parent
        Item{
            width: contentRoot.width*0.7
            height: contentRoot.height
            Column{
                id:colFirst
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
                        width:colFirst.width - lbSaveFolder.width - btSaveFolder.width
                    }
                    Button {
                        id:btSaveFolder
                        width: 150
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
                    ComboBox {
                        id:cbCodec
                        width: btSaveFolder.width
                        model: recorder.supportedCodecs
                        onCurrentIndexChanged: {
                            recorder.codec = currentIndex
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
                    width:colFirst.width
                    height: (colFirst.height - (y-colFirst.y) - bt_rec.height - colFirst.spacing - colFirst.anchors.bottomMargin)

                    focus:true
                    TableViewColumn{ role: "fileName"  ; title: "File" ; width: 300 }
                    TableViewColumn{ role: "album" ; title: "Album" }
                    model: folderModel
                    Keys.onPressed: {
                        console.log("key pressed.event.key="+event.key)
                        //On Mac OS X, Qt.Key_Backspace seems to be asigned to delete key.
                        if((event.key === Qt.Key_Backspace) || (event.key === Qt.Key_Delete)){
                            console.log("delete pressed")
                            deleteAction.trigger()
                        }
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
                    Button{
                        width: bt_rec.width
                        height: bt_rec.height
                        action:toggleSizeAction
                    }
                }
            }
        }
        Item{
            width: contentRoot.width*0.3
            height: contentRoot.height
            Column{
                id:colSecond
                anchors.fill: parent
                anchors.margins: 10
                //            spacing: 10
                Label{
                    id:lbMemo
                    text:qsTr("memo for reading:")
                }
                TextArea{
                    width: colSecond.width - colSecond.spacing
                    height: colSecond.height - colSecond.spacing - lbMemo.height
                }
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
        source:tfSaveFolder.text+"/"+tfSaveFile.text+"_"+tfSaveFile.count
        onFileExists:{
            console.log("fileExists")
            tfSaveFile.count++
            recorder.record()
        }
    }
    Audio{
        id:player
        onStopped: {
            player.source = " "
        }
    }
    FileAccessor{
        id:fileAccessor
    }
    SettingManager{
        id:settingMgr
        Component.onCompleted: {
            var value = settingMgr.getValue("saveFolder")
            if(value !== ""){
                tfSaveFolder.text = value
            }
            value = settingMgr.getValue("saveFile")
            if(value !== ""){
                tfSaveFile.text = value
            }
            value = settingMgr.getValue("window_width")
            if(value !== ""){
                root.width = value
            }
            value = settingMgr.getValue("window_height")
            if(value !== ""){
                root.height = value
            }
            value = settingMgr.getValue("window_x")
            if(value !== ""){
                root.x = value
            }
            value = settingMgr.getValue("window_y")
            if(value !== ""){
                root.y = value
            }
        }
        Component.onDestruction: {
            settingMgr.setValue("saveFolder", tfSaveFolder.text)
            settingMgr.setValue("saveFile", tfSaveFile.text)
            settingMgr.setValue("window_width", root.width)
            settingMgr.setValue("window_height", root.height)
            settingMgr.setValue("window_x", root.x)
            settingMgr.setValue("window_y", root.y)
            settingMgr.save()
        }
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
        text: "Record(F2)"
        shortcut: "F2"
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
        text: "Stop(F3)"
        shortcut: "F3"
        onTriggered: {
            console.log("[LLRecorder]stop record and play!!")
            recorder.stop()
            player.stop()
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
        }
        tooltip: "Stop recording"
    }
    Action {
        id: playAction
        text: "Play(F4)"
        shortcut: "F4"
        onTriggered: {
            console.log("[LLRecorder]play!!")
            player.source = folderModel.get(tblview.currentRow, "filePath")
            player.play()
        }
        tooltip: "Play selected file"
    }
    Action {
        id: deleteAction
        text: "Delete\n(Ctrl+d)"
        shortcut: "Ctrl+d"
        onTriggered: {
            fileAccessor.remove(folderModel.get(tblview.currentRow, "filePath"))
            tfSaveFile.count = 1
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
        }
        tooltip: "Delete selected file"
    }
    Action {
        id: toggleSizeAction
        text: "Toggle Size\n(F6)"
        shortcut: "F6"
        onTriggered: {
            var tempHeight = root.height
            var tempWidth = root.width
            root.height = root.previousHeight
            root.width = root.previousWidth
            root.previousHeight = tempHeight
            root.previousWidth = tempWidth
        }
        tooltip: "Toggle Window Size"
    }

}
