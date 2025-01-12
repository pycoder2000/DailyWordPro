import SwiftUI
import AppKit

class CustomWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }
}

class CustomWindowController: NSWindowController, NSWindowDelegate {
    convenience init(contentView: NSView) {
        let window = CustomWindow(
            contentRect: NSRect(x: 0, y: 0, width: 360, height: 400),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered, defer: false)
        window.contentView = contentView
        self.init(window: window)
        window.delegate = self
    }

    func windowWillClose(_ notification: Notification) {
    }
}