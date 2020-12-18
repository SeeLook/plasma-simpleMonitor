/**
 * Copyright 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 *
 * This file is part of plasma-simpleMonitor.
 *
 * plasma-simpleMonitor is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or any later version.
 *
 * plasma-simpleMonitor is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with plasma-simpleMonitor.  If not, see <http://www.gnu.org/licenses/>.
 **/

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4
import org.kde.plasma.core 2.0 as PlasmaCore

import "../../code/code.js" as Code

Item {
    id: root

    Layout.fillHeight: true
    Layout.fillWidth: true

    implicitHeight: settingsLayout.implicitHeight
    implicitWidth: settingsLayout.implicitWidth

    Layout.minimumWidth: implicitWidth
    Layout.minimumHeight: implicitHeight
    Layout.preferredWidth: implicitWidth
    Layout.preferredHeight: implicitHeight

    property int cfg_bgColor
    property alias cfg_logo: logoComboBox.currentIndex
    property alias cfg_showSwap: showSwapCheckBox.checked
    property alias cfg_showUptime: showUptimeCheckBox.checked
    property int cfg_tempUnit
    property alias cfg_cpuHighTemp: cpuHighTempSpinBox.value
    property alias cfg_cpuCritTemp: cpuCritTempSpinBox.value
    property alias cfg_cpuMaxVisible: cpuMaxVisibleSpinBox.value

    QtObject {
        id: d

        property string osId: "tux"

        Component.onCompleted: {
            Code.getDistroInfo(function(arrayResult) {
                osId = arrayResult["id"];
            }, this)
        }
    }

    onCfg_bgColorChanged: {
        switch (cfg_bgColor) {
            default: case 0: bgColorTypeGroup.checkedButton = standardBgColor; break;
            case 1: bgColorTypeGroup.checkedButton = crystalBgColor; break;
            case 2: bgColorTypeGroup.checkedButton = translucentBgColor; break;
        }
    }

    onCfg_tempUnitChanged: {
        switch (cfg_tempUnit) {
            default: case 0: tempUnitTypeGroup.checkedButton = celsiusTemp; break;
            case 1: tempUnitTypeGroup.checkedButton = fahrenheitTemp; break;
        }
    }

    Component.onCompleted: {
        cfg_bgColorChanged();
        cfg_tempUnitChanged();
    }

    ButtonGroup {
        id: bgColorTypeGroup
    }

    ButtonGroup {
        id: tempUnitTypeGroup
    }

    ColumnLayout {
        id: settingsLayout
        anchors.fill: parent

        GroupBox {
            title: i18n("Parts settings:")
            Layout.fillWidth: true

            GridLayout {
                columns: 2

                Label {
                    text: i18n("Logo:")
                    Layout.alignment: Qt.AlignRight
                }

                ComboBox {
                    id: logoComboBox
                    model: ["Default", "Tux", "Slackware", "Ubuntu", "Kubuntu", "OpenSUSE", "Manjaro", "Arch", "Fedora"]
                }

                Rectangle {

                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignHCenter

                    implicitHeight: logoImage.height + 10
                    implicitWidth:  logoImage.width + 10

                    color: "transparent"
                    border { width: 1; color: theme.buttonTextColor }
                    radius: 2

                    Image {
                        id: logoImage

                        anchors.centerIn: parent

                        source: "../" + Code.getStandardLogo(logoComboBox.currentIndex, d.osId)
                        sourceSize.height: 100
                    }
                }

                Label {
                    text: i18n("Background color:")
                    Layout.alignment: Qt.AlignRight
                    Layout.rowSpan: 3
                }

                RadioButton {
                    id: standardBgColor
                    ButtonGroup.group: bgColorTypeGroup
                    text: i18n("Standard")
                    onCheckedChanged: if (checked) cfg_bgColor = 0;
                }

                RadioButton {
                    id: crystalBgColor
                    ButtonGroup.group: bgColorTypeGroup
                    text: i18n("Crystal")
                    onCheckedChanged: if (checked) cfg_bgColor = 1;
                }

                RadioButton {
                    id: translucentBgColor
                    ButtonGroup.group: bgColorTypeGroup
                    text: i18n("Translucent")
                    onCheckedChanged: if (checked) cfg_bgColor = 2;
                }

                Label {
                    text: i18n("Show:")
                    Layout.alignment: Qt.AlignRight
                    Layout.rowSpan: 2
                }

                CheckBox {
                    id: showSwapCheckBox
                    text: i18n("Swap")
                }

                CheckBox {
                    id: showUptimeCheckBox
                    text: i18n("Uptime")
                }
            }
        }

        GroupBox {
            title: i18n("Temp settings:")
            Layout.fillWidth: true

            GridLayout {
                columns: 2
                rowSpacing: 2

                Label {
                    Layout.columnSpan: 2
                    text: i18n("<i>(You can use the <strong>sensors</strong> command to place the appropriate values ​​for this section.)</i>")
                    color: theme.highlightColor
                    wrapMode: Text.WordWrap
                }

                Label {
                    text: i18n("Temperature units:")
                    Layout.alignment: Qt.AlignRight
                    Layout.rowSpan: 2
                }

                RadioButton {
                    id: celsiusTemp
                    ButtonGroup.group: tempUnitTypeGroup
                    text: i18n("Celsius °C")
                    onCheckedChanged: if (checked) cfg_tempUnit = 0;
                }

                RadioButton {
                    id: fahrenheitTemp
                    ButtonGroup.group: tempUnitTypeGroup
                    text: i18n("Fahrenheit °F")
                    onCheckedChanged: if (checked) cfg_tempUnit = 1;
                }

                Label {
                    text: i18n("CPU High Temperature:")
                    Layout.alignment: Qt.AlignRight
                }

                SpinBox {
                    id: cpuHighTempSpinBox
                }

                Label {
                    text: i18n("CPU Critical Temperature:")
                    Layout.alignment: Qt.AlignRight
                }

                SpinBox {
                    id: cpuCritTempSpinBox
                    to: 150
                }

                Label {
                    text: i18n("Visible CPU cores")
                    Layout.alignment: Qt.AlignRight
                }

                SpinBox {
                    id: cpuMaxVisibleSpinBox
                    to: 128
                }
            }
        }
    }
}
