//
//  ComplicationController.swift
//  ContactCardsWatch Extension
//
//  Created by Matt Roberts on 4/11/21.
//  Copyright © 2021 Matt Roberts. All rights reserved.
//
import ClockKit
class ComplicationController: NSObject, CLKComplicationDataSource {
    // MARK: - Complication Configuration
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
			CLKComplicationDescriptor(identifier: "complication", displayName: "QR Code", supportedFamilies: [.circularSmall, .modularSmall, .extraLarge,
																											  .graphicCircular, .graphicExtraLarge])
            // Multiple complication support can be added here with more descriptors
        ]
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }
    // MARK: - Timeline Configuration
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
		handler(Date().addingTimeInterval(24.0 * 60.0 * 60.0))
    }
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }
    // MARK: - Timeline Population
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
		if let completedTemplate=getComplicationTemplate(complication: complication) {
			handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: completedTemplate))
		} else {
			handler(nil)
		}
    }
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
		if let completedTemplate=getComplicationTemplate(complication: complication) {
			let fiveMinutes = 5.0 * 60.0
				let twentyFourHours = 24.0 * 60.0 * 60.0
				
				// Create an array to hold the timeline entries.
				var entries = [CLKComplicationTimelineEntry]()
				
				// Calculate the start and end dates.
				var current = date.addingTimeInterval(fiveMinutes)
				let endDate = date.addingTimeInterval(twentyFourHours)
				
				// Create a timeline entry for every five minutes from the starting time.
				// Stop once you reach the limit or the end date.
				while (current.compare(endDate) == .orderedAscending) && (entries.count < limit) {
					entries.append(CLKComplicationTimelineEntry(date: current, complicationTemplate: completedTemplate))
					current = current.addingTimeInterval(fiveMinutes)
				}
				
				handler(entries)
		} else {
			handler(nil)
		}
    }
    // MARK: - Sample Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
		if let completedTemplate=getComplicationTemplate(complication: complication) {
			handler(completedTemplate)
		} else {
			handler(nil)
		}
    }
	func getComplicationTemplate(complication: CLKComplication) -> CLKComplicationTemplate? {
		switch complication.family {
		case .circularSmall:
			return CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Circular") ?? UIImage()))
		case .modularSmall:
			return
				CLKComplicationTemplateModularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Modular") ?? UIImage()))
		case .utilitarianSmall:
			return CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Utilitarian") ?? UIImage()))
		case .extraLarge:
			return CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "ExtraLarge") ?? UIImage()))
			/*
		case .graphicCorner:
			return CLKComplicationTemplateGraphicCornerCircularImage(imageProvider:
																CLKFullColorImageProvider(fullColorImage: UIImage(named: "GraphicCorner") ?? UIImage(), tintedImageProvider:
																							CLKImageProvider(onePieceImage: UIImage(named: "GraphicCornerTinted") ?? UIImage(),
																											 twoPieceImageBackground: UIImage(), twoPieceImageForeground: UIImage(named: "GraphicCornerTinted") ?? UIImage())))
*/
		case .graphicCircular:
			return CLKComplicationTemplateGraphicCircularImage(imageProvider:
																CLKFullColorImageProvider(fullColorImage: UIImage(named: "GraphicCircular") ?? UIImage(), tintedImageProvider:
																							CLKImageProvider(onePieceImage: UIImage(named: "GraphicCircularTinted") ?? UIImage(),
																											 twoPieceImageBackground: UIImage(), twoPieceImageForeground: UIImage(named: "GraphicCircularTinted") ?? UIImage())))
		case .graphicExtraLarge:
			return CLKComplicationTemplateGraphicExtraLargeCircularImage(imageProvider:
																CLKFullColorImageProvider(fullColorImage: UIImage(named: "GraphicExtraLarge") ?? UIImage(), tintedImageProvider:
																							CLKImageProvider(onePieceImage: UIImage(named: "GraphicExtraLargeTinted") ?? UIImage())))
		default:
			return nil
		}
	}
}
