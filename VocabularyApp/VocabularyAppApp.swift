//
//  VocabularyAppApp.swift
//  VocabularyApp
//
//  Created by Parth Desai on 1/10/25.
//

import SwiftUI

@main
struct VocabularyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var eventMonitor: EventMonitor?
    var contentView: ContentView?

    func applicationDidFinishLaunching(_ notification: Notification) {
        contentView = ContentView()

        popover = NSPopover()
        popover?.contentSize = NSSize(width: 360, height: 0)
        popover?.behavior = .transient

        let hostingController = NSHostingController(rootView: contentView!)
        hostingController.view.setFrameSize(NSSize(width: 360, height: 1))

        hostingController.view.autoresizingMask = [.height]

        popover?.contentViewController = hostingController

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "book", accessibilityDescription: "Daily Word Pro")
            button.action = #selector(togglePopover(_:))
        }

        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover?.isShown == true {
                strongSelf.closePopover(event)
            }
        }

        // Load a new word when the app is opened
        loadNewWordIfNeeded()
    }

    @objc func togglePopover(_ sender: Any?) {
        if let popover = popover {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
                // Load a new word every time the popover is shown
                contentView?.loadRandomWord()
            }
        }
    }

    func showPopover(_ sender: Any?) {
        if let button = statusItem?.button {
            popover?.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            eventMonitor?.start()
        }
    }

    func closePopover(_ sender: Any?) {
        popover?.performClose(sender)
        eventMonitor?.stop()
    }

    func loadNewWordIfNeeded() {
        let lastLoadedDateKey = "lastLoadedDate"
        let userDefaults = UserDefaults.standard

        if let lastLoadedDate = userDefaults.object(forKey: lastLoadedDateKey) as? Date {
            if !Calendar.current.isDateInToday(lastLoadedDate) {
                contentView?.loadRandomWord()
                userDefaults.set(Date(), forKey: lastLoadedDateKey)
            }
        } else {
            contentView?.loadRandomWord()
            userDefaults.set(Date(), forKey: lastLoadedDateKey)
        }
    }
}

class EventMonitor {
    private var monitor: Any?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void

    init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
        self.mask = mask
        self.handler = handler
    }

    deinit {
        stop()
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler)
    }

    func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}