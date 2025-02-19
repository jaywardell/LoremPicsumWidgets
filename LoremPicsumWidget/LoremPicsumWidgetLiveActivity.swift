//
//  LoremPicsumWidgetLiveActivity.swift
//  LoremPicsumWidget
//
//  Created by Joseph Wardell on 2/18/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LoremPicsumWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LoremPicsumWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LoremPicsumWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LoremPicsumWidgetAttributes {
    fileprivate static var preview: LoremPicsumWidgetAttributes {
        LoremPicsumWidgetAttributes(name: "World")
    }
}

extension LoremPicsumWidgetAttributes.ContentState {
    fileprivate static var smiley: LoremPicsumWidgetAttributes.ContentState {
        LoremPicsumWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LoremPicsumWidgetAttributes.ContentState {
         LoremPicsumWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LoremPicsumWidgetAttributes.preview) {
   LoremPicsumWidgetLiveActivity()
} contentStates: {
    LoremPicsumWidgetAttributes.ContentState.smiley
    LoremPicsumWidgetAttributes.ContentState.starEyes
}
