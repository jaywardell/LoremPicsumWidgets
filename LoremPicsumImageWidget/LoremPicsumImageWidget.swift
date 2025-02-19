//
//  LoremPicsumImageWidget.swift
//  LoremPicsumImageWidget
//
//  Created by Joseph Wardell on 2/18/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
}

struct LoremPicsumImageWidgetEntryView : View {
    var entry: Provider.Entry

    @AppStorage("imageURL", store: UserDefaults.usingAppGroup) var imageURL: String?
    @Environment(SharedData.self) var sharedData

    var body: some View {
        if let imageURL,
           let url = URL(string: imageURL),
           // TODO: there was a fatal error here when I ran the app a few times then ran the extension from the simulator
           // idky
           let imageData = sharedData.cache[url],
           let image = UIImage(data: imageData) {
            Image(uiImage: image)
        }
        else {
            Text("No Image Yet")
        }
    }
}

struct LoremPicsumImageWidget: Widget {
    let kind: String = "LoremPicsumImageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                LoremPicsumImageWidgetEntryView(entry: entry)
                    .environment(SharedData())
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                LoremPicsumImageWidgetEntryView(entry: entry)
                    .environment(SharedData())
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    LoremPicsumImageWidget()
} timeline: {
    SimpleEntry(date: .now, emoji: "😀")
    SimpleEntry(date: .now, emoji: "🤩")
}
