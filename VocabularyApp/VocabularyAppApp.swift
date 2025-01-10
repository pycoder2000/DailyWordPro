//
//  VocabularyAppApp.swift
//  VocabularyApp
//
//  Created by Parth Desai on 1/10/25.
//

import SwiftUI

@main
struct VocabularyApp: App {
    @State private var isMenuOpen = true // Track whether the menu is open

    var body: some Scene {
        MenuBarExtra("GRE Word", systemImage: "book", isInserted: $isMenuOpen) {
            ContentView()
                .onDisappear {
                    isMenuOpen = true // Reopen the menu after disappearing
                }
        }
    }
}