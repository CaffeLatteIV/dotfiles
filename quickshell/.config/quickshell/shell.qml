import Quickshell
import QtQuick
import "./bar"
import "./menu"

Scope {
    Variants {
        model: Quickshell.screens
        Menu {
            id: appMenu
        }
        Bar {
            screen: modelData
        }
    }
}
