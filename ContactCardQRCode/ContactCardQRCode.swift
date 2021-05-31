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
import CoreData
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		SimpleEntry(date: Date(), qrCode: nil, color: nil)
    }
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
					 completion: @escaping (SimpleEntry) -> Void) {
		let entry=createEntryFromConfiguration(configuration: configuration)
        completion(entry)
    }
    func getTimeline(for configuration: ConfigurationIntent, in context: Context,
					 completion: @escaping (Timeline<SimpleEntry>) -> Void) {
		let entry=createEntryFromConfiguration(configuration: configuration)
		let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
	func createEntryFromConfiguration(configuration: ConfigurationIntent) -> SimpleEntry {
		var qrCode: UIImage?
		var color: UIColor?
		if let uuid=configuration.parameter?.identifier {
			let container=loadPersistentContainer()
			let managedObjectContext=container.viewContext
			let fetchRequest = NSFetchRequest<ContactCardMO>(entityName: ContactCardMO.entityName)
				do {
					// Execute Fetch Request
					let contactCards = try managedObjectContext.fetch(fetchRequest)
					if let contactCardMO=contactCards.first(where: { (contactCardMO) -> Bool in
						return uuid==contactCardMO.objectID.uriRepresentation().absoluteString
					}) {
						let model=DisplayQRModel()
						let colorModel=ColorModel()
						model.setUp(contactCard: contactCardMO)
						color=colorModel.getColorsDictionary()[contactCardMO.color] ?? UIColor.label
						qrCode=model.makeQRCode()
						print("Should have made qr code for widget")
					}
				} catch {
					print("Unable to fetch contact cards")
				}
		}
		return SimpleEntry(date: Date(), qrCode: qrCode, color: color)
	}

}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let qrCode: UIImage?
	let color: UIColor?
}

struct ContactCardQRCodeEntryView: View {
	@Environment(\.colorScheme) var colorScheme
    var entry: Provider.Entry

	@ViewBuilder
    var body: some View {
		if entry.qrCode == nil {
			Text("Edit widget to choose a contact card from the app for which to display a QR code.").padding()
		} else if entry.color==UIColor.label {
			Image(uiImage: colorScheme == .dark ? getTintedForeground(image: entry.qrCode ?? UIImage(), color: UIColor.white):
				getTintedForeground(image: entry.qrCode ?? UIImage(), color:
						UIColor.black)).resizable().aspectRatio(contentMode: .fit).padding()
		} else {
			Image(uiImage: getTintedForeground(image: entry.qrCode ?? UIImage(),
				color: entry.color ?? UIColor.label)).resizable().aspectRatio(contentMode: .fit).padding()
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
		.description("Display a QR Code for a Contact Card").supportedFamilies([.systemSmall, .systemLarge])
	}
}

struct ContactCardQRCodePreviews: PreviewProvider {
    static var previews: some View {
		ContactCardQRCodeEntryView(entry: SimpleEntry(date: Date(), qrCode: nil, color: nil))
			.previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
