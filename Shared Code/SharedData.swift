//
//  SharedData.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/19/25.
//

import Foundation
import CacheCow
import Observation

@Observable
final class SharedData {
    
    private(set) var cache: FileSystemBackedCache<URL, Data>!
    
    init() {
        Task.detached {
            await self.configure(name: .imagesCacheName, group: .appGroupName)
        }
    }
    
    private func configure(name: String, group: String) async {
        do {
            cache = try await FileSystemBackedCache.urlDirectoryCache(named: name, in: group, encode: { $0 }, decode: { $0 })
        }
        catch {
            print("Error creating cache named \(name) with app group \(group): \(error.localizedDescription)")
        }
    }
    
}
