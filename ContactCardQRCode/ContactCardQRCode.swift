//
//  ContactCardQRCode.swift
//  ContactCardQRCode
//
//  Created by Matt Roberts on 3/6/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 1 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

		let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct ContactCardQRCodeEntryView : View {
    var entry: Provider.Entry

    var body: some View {
		Text("Edit widget to choose a contact card from the app for which to display a QR code.").padding()
		/*
		Image(systemName: "pencil").resizable().aspectRatio(contentMode: .fill).padding()
*/
    }
}

@main
struct ContactCardQRCode: Widget {
    let kind: String = "ContactCardQRCode"

	var body: some WidgetConfiguration {
		IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
			ContactCardQRCodeEntryView(entry: entry)
		}
		.configurationDisplayName("Contact Card QR Code")
		.description("Display a QR Code for a Contact Card").supportedFamilies([.systemLarge])
	}
}

struct ContactCardQRCodePreviews: PreviewProvider {
    static var previews: some View {
        ContactCardQRCodeEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
