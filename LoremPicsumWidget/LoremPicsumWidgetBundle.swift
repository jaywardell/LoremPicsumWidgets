//
//  LoremPicsumWidgetBundle.swift
//  LoremPicsumWidget
//
//  Created by Joseph Wardell on 2/18/25.
//

import WidgetKit
import SwiftUI

@main
struct LoremPicsumWidgetBundle: WidgetBundle {
    var body: some Widget {
        LoremPicsumWidget()
        LoremPicsumWidgetControl()
        LoremPicsumWidgetLiveActivity()
    }
}
