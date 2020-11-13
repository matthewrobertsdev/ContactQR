//
//  TintImages.swift
//  Contact QR
//
//  Created by Matt Roberts on 10/17/20.
//  Copyright © 2020 Matt Roberts. All rights reserved.
//

import UIKit
func getTintedForeground(image: UIImage, color: UIColor) -> UIImage {
			UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)

			let context = UIGraphicsGetCurrentContext()!
			context.translateBy(x: 0, y: image.size.height)
			context.scaleBy(x: 1.0, y: -1.0)
			context.setBlendMode(.normal)

			let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height) as CGRect
	guard let ciImage=image.ciImage else {
				print("Failed to make ciImage")
				return UIImage()
			}
			let ciContext = CIContext(options: nil)
			guard let cgImage=ciContext.createCGImage(ciImage, from: ciImage.extent) else {
				print("Failed to make cgImage")
				return UIImage()
			}
			context.clip(to: rect, mask: cgImage)
			color.setFill()
			context.fill(rect)

			let newImage = UIGraphicsGetImageFromCurrentImageContext()!
			UIGraphicsEndImageContext()

			return newImage
		}
