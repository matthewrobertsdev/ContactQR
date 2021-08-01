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
enum WidgetMode {
	case placeholder
	case contactQRCode
	case editMessage
	case empty
}
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
		createPreviewEntry()
    }
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context,
					 completion: @escaping (SimpleEntry) -> Void) {
		let entry=createPreviewEntry()
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
		var color: String?
		var widgetMode=WidgetMode.editMessage
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
						model.setUp(contactCard: contactCardMO)
						color=contactCardMO.color
						qrCode=model.makeQRCode()
						print("Should have made qr code for widget")
						widgetMode=WidgetMode.contactQRCode
					}
				} catch {
					print("Unable to fetch contact cards")
				}
		}
		return SimpleEntry(date: Date(), qrCode: qrCode, color: color, widgetMode: widgetMode)
	}
}
func createPreviewEntry() -> SimpleEntry {
	SimpleEntry(date: Date(), qrCode: ContactDataConverter.makeQRCode(string: "https://matthewrobertsdev.github.io/celeritasapps/#/"),
						  color: "Yellow", widgetMode: WidgetMode.placeholder)
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let qrCode: UIImage?
	let color: String?
	let widgetMode: WidgetMode
}

struct ContactCardQRCodeEntryView: View {
	@Environment(\.colorScheme) var colorScheme
    var entry: Provider.Entry
	@ViewBuilder
    var body: some View {
		if entry.widgetMode==WidgetMode.placeholder {
			Image(uiImage: getTintedForeground(image: entry.qrCode ?? UIImage(),
											   color: UIColor(named: "Yellow") ?? UIColor.systemYellow)).resizable().aspectRatio(contentMode: .fit).padding(7.5)
		} else if entry.widgetMode == WidgetMode.editMessage {
			Text("Edit widget to choose a contact card for a QR code.").padding()
		} else if entry.widgetMode==WidgetMode.contactQRCode && entry.color=="ContrastingColor" {
			Image(uiImage: colorScheme == .dark ? getTintedForeground(image: entry.qrCode ?? UIImage(), color: UIColor.white):
				getTintedForeground(image: entry.qrCode ?? UIImage(), color:
										UIColor.black)).resizable().aspectRatio(contentMode: .fit).padding(7.5)
		} else if entry.widgetMode==WidgetMode.contactQRCode {
			Image(uiImage:  getTintedForeground(image: entry.qrCode ?? UIImage(),
												color: UIColor(named: colorScheme == .dark ? "Light"+(entry.color ?? "") : "Dark"+(entry.color ?? "")) ?? UIColor.label)).resizable().aspectRatio(contentMode: .fit).padding(7.5)
		} else {
			Text("Error loading widget.  Sorry, it was a bug.  Please restart the device to refresh it with the system and fix it.").padding()
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
		Group {
		ContactCardQRCodeEntryView(entry: createPreviewEntry())
			.previewContext(
				WidgetPreviewContext(family: .systemSmall))
		ContactCardQRCodeEntryView(entry: createPreviewEntry())
			.previewContext(
				WidgetPreviewContext(family: .systemLarge))
		}
    }
}
