//
//  UserDefaults.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/18/25.
//

import Foundation

@MainActor
extension UserDefaults {
    static var appGroupName: String { "group.lorempicsumwidgets" }
    static let usingAppGroup = UserDefaults(suiteName: appGroupName)
}
