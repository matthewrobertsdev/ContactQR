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
			CLKComplicationDescriptor(identifier: "complication", displayName: "QR Code", supportedFamilies: [.circularSmall, .modularSmall, .utilitarianSmall, .extraLarge, .graphicCorner,
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
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
		var template: CLKComplicationTemplate?
		switch complication.family {
		case .circularSmall:
			template=CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Circular") ?? UIImage()))
		case .modularSmall:
			template=CLKComplicationTemplateModularSmallSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Modular") ?? UIImage()))
		case .utilitarianSmall:
			template=CLKComplicationTemplateUtilitarianSmallSquare(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Utilitaraian") ?? UIImage()))
		case .extraLarge:
			template=CLKComplicationTemplateExtraLargeSimpleImage(imageProvider: CLKImageProvider(onePieceImage: UIImage(named: "Extra Large") ?? UIImage()))
		case .graphicCorner:
			template=CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Graphic Corner") ?? UIImage()))
		case .graphicCircular:
			template=CLKComplicationTemplateGraphicCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Graphic Circular") ?? UIImage()))
		case .graphicExtraLarge:
			template=CLKComplicationTemplateGraphicExtraLargeCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "Graphic Extra Large") ?? UIImage()))
		default:
			break
		}
        // Call the handler with the current timeline entry
		if let completedTemplate=template {
			handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: completedTemplate))
		} else {
			handler(nil)
		}
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
