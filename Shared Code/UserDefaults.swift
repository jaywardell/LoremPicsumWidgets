//
//  UserDefaults.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/18/25.
//

import Foundation

@MainActor
extension UserDefaults {
    static let usingAppGroup = UserDefaults(suiteName: .appGroupName)
}

extension String {
    static var appGroupName: String { "group.lorempicsumwidgets" }
    static var imagesCacheName: String { "images" }
}
