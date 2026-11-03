import Quickshell
import QtQuick
import "./bar"
import "./menu"

Scope {
    // Single-instance popup menu (not per-screen).
    Menu {
        id: appMenu
    }
    // One top bar per screen; Quickshell injects each Screen into Bar.modelData.
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
