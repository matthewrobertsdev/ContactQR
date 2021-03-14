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
		SimpleEntry(date: Date(), qrCode: nil, color: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
		let entry=createEntryFromConfiguration(configuration: configuration)
        completion(entry)
    }
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {

		let entry=createEntryFromConfiguration(configuration: configuration)
		let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
	func createEntryFromConfiguration(configuration: ConfigurationIntent) -> SimpleEntry{
		print("Should be being configured")
		var qrCode: UIImage?
		if let uuid=configuration.parameter?.identifier {
			do {
				let contactCards=try ContactCardPersistencyManager.shared.getSavedContacts()
				if let contactCard=contactCards.first(where: { (card) in
					return card.uuidString==uuid
				}) {
					let model=DisplayQRModel()
					model.setUp(contactCard: contactCard)
					qrCode=model.makeQRCode()
					print("Should have made qr code for widget")
				}
			} catch {
				print("Error reading cards in timeline")
			}
		}
		return SimpleEntry(date: Date(), qrCode: qrCode, color: nil)
	}

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let qrCode: UIImage?
	let color: UIColor?
}

struct ContactCardQRCodeEntryView: View {
    var entry: Provider.Entry

	@ViewBuilder
    var body: some View {
		if entry.qrCode == nil {
			Text("Edit widget to choose a contact card from the app for which to display a QR code.").padding()
		} else {
			Image(uiImage: getTintedForeground(image: entry.qrCode ?? UIImage(), color: UIColor.systemOrange)).resizable().aspectRatio(contentMode: .fit).padding()
		}
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
		.description("Display a QR Code for a Contact Card").supportedFamilies([ .systemLarge])
	}
}

struct ContactCardQRCodePreviews: PreviewProvider {
    static var previews: some View {
		ContactCardQRCodeEntryView(entry: SimpleEntry(date: Date(), qrCode: nil, color: nil))
			.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
