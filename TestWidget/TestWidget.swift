import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), imageUrl: URL(string: "https://cataas.com/cat")!)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), imageUrl: URL(string: "https://cataas.com/cat")!)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for _ in 0 ..< 5 {
            if let imageUrl = URL(string: "https://cataas.com/cat") {
                entries.append(SimpleEntry(date: currentDate, imageUrl: imageUrl))
            }
        }

        let nextUpdate = Calendar.current.date(byAdding: .second, value: 30, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let imageUrl: URL
}

struct WidgetEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        let data = try? Data(contentsOf: entry.imageUrl)
        let img = NSImage(data: data!)
        Image(nsImage: img!)
            .aspectRatio(contentMode: .fit)
        .containerBackground(for: .widget) {
            Color.white
        }
    }
}

struct CatWidget: Widget {
    let kind: String = "CatWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Cat Widget")
        .description("OMG A CAT")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}
