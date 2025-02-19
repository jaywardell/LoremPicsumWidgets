//
//  SharedData.swift
//  LoremPicsumWidgets
//
//  Created by Joseph Wardell on 2/19/25.
//

import Foundation
import UIKit
import CacheCow
import Observation

@Observable
final class SharedData {
    
    private(set) var cache: FileSystemBackedCache<URL, UIImage>!
    
    init() {
        Task.detached {
            await self.configure(name: .imagesCacheName, group: .appGroupName)
        }
    }
    
    private func configure(name: String, group: String) async {
        do {
            cache = try await FileSystemBackedCache.urlDirectoryCache(
                named: name,
                in: group,
                encode: { image in image.jpegData(compressionQuality: 1) },
                decode: { data in UIImage(data: data) })
        }
        catch {
            print("Error creating cache named \(name) with app group \(group): \(error.localizedDescription)")
        }
    }
    
}
