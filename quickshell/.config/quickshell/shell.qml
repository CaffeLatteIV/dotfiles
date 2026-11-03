import Quickshell
import QtQuick
import "./bar"
import "./menu"

Scope {
    // One top bar per screen; Quickshell injects each Screen into Bar.modelData.
    // (The app Menu is a pragma Singleton instantiated on first access.)
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
