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
#include "settingmanager.h"
#include <QVariant>
#include <QFile>
#include <QJsonDocument>

SettingManager::SettingManager(QQuickItem *parent):
    QQuickItem(parent)
{
    load();
}

SettingManager::~SettingManager()
{
}

void SettingManager::setValue(QString name, QVariant value)
{
    switch (value.type()) {
    case QMetaType::Bool:
        m_json[name] = value.toBool();
        break;
    case QMetaType::Double:
    case QMetaType::Int:
        m_json[name] = value.toDouble();
        break;
    default:
        m_json[name] = value.toString();
        break;
    }
}

QVariant SettingManager::getValue(QString name)
{
    QVariant value;
    switch (m_json[name].type()) {
    case QJsonValue::Bool:
        value = m_json[name].toBool();
        break;
    case QJsonValue::Double:
        value = m_json[name].toDouble();
        break;
    case QJsonValue::Null:
    case QJsonValue::Undefined:
        value.clear();
    default:
        value = m_json[name].toString();
        break;
    }
    return value;
}

bool SettingManager::save()
{
    QFile saveFile(QStringLiteral("jsontest01.json"));
    if(!saveFile.open(QIODevice::WriteOnly)){
        qWarning("Couldn't open save file.");
        return false;
    }
    QJsonDocument saveDoc(m_json);
    saveFile.write(saveDoc.toJson());
    return true;
}

bool SettingManager::load()
{
    QFile loadFile(QStringLiteral("jsontest01.json"));
    if(!loadFile.open(QIODevice::ReadOnly)){
        qWarning("Couldn't open setting file.");
        return false;
    }
    QByteArray saveData = loadFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));
    m_json = loadDoc.object();
    return true;
}

