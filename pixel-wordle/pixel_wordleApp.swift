//
//  pixel_wordleApp.swift
//  pixel-wordle
//
//  Created by Nhân Nguyễn on 1/26/25.
//

import SwiftUI
import Foundation

@main
struct pixel_wordleApp: App {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
    }
}
