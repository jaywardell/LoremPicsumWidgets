//
//  LoremPicsumWidgetsApp.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/18/25.
//

import SwiftUI

@main
struct LoremPicsumWidgetsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(SharedData())
        }
    }
}
