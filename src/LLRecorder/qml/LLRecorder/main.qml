/****************************************************************************
** Copyright (c) 2014, LLRecorder Project
** All rights reserved.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**
** 1. Redistributions of source code must retain the above copyright notice,
** this list of conditions and the following disclaimer.
**
** 2. Redistributions in binary form must reproduce the above copyright notice,
** this list of conditions and the following disclaimer in the documentation and/or
** other materials provided with the distribution.
**
** 3. Neither the name of the copyright holder nor the names of its contributors
** may be used to endorse or promote products derived from this software without
** specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
** DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
** NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
** EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
****************************************************************************/
import QtQuick 2.1
import QtQuick.Controls 1.0
import QtQuick.Dialogs 1.0
import QtMultimedia 5.0
import Qt.labs.folderlistmodel 2.1
import Qt.labs.settings 1.0
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
            id:itFirst
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
                    TableViewColumn{ id:tvColumn1; role: "fileName"  ; title: qsTr("File") ; width: 300 }
                    TableViewColumn{ role: "album" ; title: qsTr("Album") }
                    model: folderModel
                    Keys.onPressed: {
                        //On Mac OS X, Qt.Key_Backspace seems to be asigned to delete key.
                        if((event.key === Qt.Key_Backspace) || (event.key === Qt.Key_Delete)){
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
                    id:taMemo
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
        title: qsTr("Please choose a file")
        selectFolder: true

        onAccepted: {
            tfSaveFolder.text = folder
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
        }
    }

    AudioRecorder{
        id:recorder
        source:tfSaveFolder.text+"/"+tfSaveFile.text+"_"+tfSaveFile.count
        onFileExists:{
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
    //SettingManager should be replased to Settings
    SettingManager{
        id:settingMgr
        Component.onCompleted: {
            var value = settingMgr.getValue("column1_width")
            if(value !== ""){
                itFirst.width = value
            }
        }
        Component.onDestruction: {
            settingMgr.setValue("column1_width", itFirst.width)
            settingMgr.save()
        }
    }
    Settings{
        id:setting01
        property alias saveFolder: tfSaveFolder.text
        property alias saveFile: tfSaveFile.text
        property alias window_width: root.width
        property alias window_height: root.height
        property alias window_x: root.x
        property alias window_y: root.y
        //the result of itFirst.width(contentRoot.width*0.7) seems to be assigned every time instead of saved data.
//        property alias column1_width: itFirst.width
        property alias memo: taMemo.text
        property alias tvColumn1_width: tvColumn1.width
    }


    Action {
        id: openAction
        text: qsTr("Select Folder")
        shortcut: "Ctrl+O"
        onTriggered: fileDialog.open()
        tooltip: qsTr("Select save folder")
    }
    Action {
        id: recordAction
        text: qsTr("Record(F2)")
        shortcut: "F2"
        onTriggered: {
            recorder.record()
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
            tfSaveFile.count++
        }

        tooltip: qsTr("Start recording")
    }
    Action {
        id: stopAction
        text: qsTr("Stop(F3)")
        shortcut: "F3"
        onTriggered: {
            recorder.stop()
            player.stop()
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
        }
        tooltip: qsTr("Stop recording")
    }
    Action {
        id: playAction
        text: qsTr("Play(F4)")
        shortcut: "F4"
        onTriggered: {
            player.source = folderModel.get(tblview.currentRow, "filePath")
            player.play()
        }
        tooltip: qsTr("Play selected file")
    }
    Action {
        id: deleteAction
        text: qsTr("Delete\n(Ctrl+d)")
        shortcut: "Ctrl+d"
        onTriggered: {
            fileAccessor.remove(folderModel.get(tblview.currentRow, "filePath"))
            tfSaveFile.count = 1
            //update TableView
            folderModel.folder = ""
            folderModel.folder = tfSaveFolder.text
        }
        tooltip: qsTr("Delete selected file")
    }
    Action {
        id: toggleSizeAction
        text: qsTr("Toggle Size\n(F6)")
        shortcut: "F6"
        onTriggered: {
            var tempHeight = root.height
            var tempWidth = root.width
            root.height = root.previousHeight
            root.width = root.previousWidth
            root.previousHeight = tempHeight
            root.previousWidth = tempWidth
        }
        tooltip: qsTr("Toggle Window Size")
    }

}
