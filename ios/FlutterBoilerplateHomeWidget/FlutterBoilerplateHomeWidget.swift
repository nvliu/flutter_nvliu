//
//  FlutterBoilerplateHomeWidget.swift
//  FlutterBoilerplateHomeWidget
//
//  Created by Ying Wang on 2021/4/22.
//  Copyright © 2021 The Chromium Authors. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

private let widgetGroupId = "group.com.upcwangying.apps.flutter.boilerplate"

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> FlutterBoilerplateEntry {
        FlutterBoilerplateEntry(date: Date(), title: "Placeholder Title", message: "Placeholder Message", contributions: nil, configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (FlutterBoilerplateEntry) -> ()) {
        let data = UserDefaults.init(suiteName:widgetGroupId)
        let entry = FlutterBoilerplateEntry(date: Date(), title: data?.string(forKey: "title") ?? "No Title Set", message: data?.string(forKey: "message") ?? "No Message Set", contributions: data?.array(forKey: "contributions") as? [Contribution], configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(for: configuration, in: context) { (entry) in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct Contribution {
    let color: Color
    let count: Int
}

struct FlutterBoilerplateEntry: TimelineEntry {
    let date: Date
    let title: String
    let message: String
    let contributions: [Contribution]?
    let configuration: ConfigurationIntent
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< columns, id: \.self) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct FlutterBoilerplateHomeWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily
    let data = UserDefaults.init(suiteName:widgetGroupId)
    
    var body: some View {
        switch family {
        case .systemSmall: VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text(entry.title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text(entry.message)
                .font(.body)
                .widgetURL(URL(string: "flutterBoilerplateHomeWidget://message?message=\(entry.message)&homeWidget"))
        }
        )
        case .systemMedium: GridStack(rows: 4, columns: 4) { row, col in
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
        }
        default: VStack.init(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text(entry.title).bold().font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text(entry.message)
                .font(.body)
                .widgetURL(URL(string: "flutterBoilerplateHomeWidget://message?message=\(entry.message)&homeWidget"))
        }
        )
        }
    }
}

@main
struct FlutterBoilerplateHomeWidget: Widget {
    let kind: String = "GitterHomeWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            FlutterBoilerplateHomeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Flutter BoilerplateEntry")
        .description("Flutter BoilerplateEntry.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct GitterHomeWidget_Previews: PreviewProvider {
    static var previews: some View {
        FlutterBoilerplateHomeWidgetEntryView(entry: FlutterBoilerplateEntry(date: Date(), title: "Preview Title", message: "Preview Message", contributions: nil, configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
