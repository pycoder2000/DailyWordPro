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
    private var apiKey: String
    private var defaultSheetID: String

    override init() {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let config = NSDictionary(contentsOfFile: path),
           let apiKey = config["API_KEY"] as? String,
           let sheetID = config["SHEET_ID"] as? String {
            self.apiKey = apiKey
            self.defaultSheetID = sheetID
        } else {
            fatalError("API_KEY or SHEET_ID not found in Config.plist")
        }
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        loadContentView()

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

    func loadContentView() {
        contentView = ContentView(apiKey: apiKey, defaultSheetID: defaultSheetID)

        popover = NSPopover()
        popover?.contentSize = NSSize(width: 360, height: 0)
        popover?.behavior = .transient

        let hostingController = NSHostingController(rootView: contentView!)
        hostingController.view.setFrameSize(NSSize(width: 360, height: 1))

        hostingController.view.autoresizingMask = [.height]

        popover?.contentViewController = hostingController
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

    func reloadContentView() {
        loadContentView()
        if let popover = popover, popover.isShown {
            popover.contentViewController = NSHostingController(rootView: contentView!)
        }
        contentView?.loadRandomWord()
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