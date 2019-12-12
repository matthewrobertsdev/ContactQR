//
//  ScanQRController.swift
//  ContactExchange
//
//  Created by Matt Roberts on 6/12/19.
//  Copyright © 2019 Matt Roberts. All rights reserved.
//

/*

Portions of the code for the video capture is a copy of software provided by Apple with this copyright notice:
Copyright © 2019 Apple Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in the
Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

*/
import UIKit
import AVFoundation
import ContactsUI
import Foundation
class GetQRController: NSObject, AVCaptureMetadataOutputObjectsDelegate {
	private var getQRViewController: GetQRViewController!
	//boolean for if the qr is a valid contact
	private var validContact=false
	//for AV input
	private let session = AVCaptureSession()
	//so code can be run not on the main thread
	private let sessionQueue = DispatchQueue(label: "session queue")
	//for AV output
	private var avPreviewLayer: AVCaptureVideoPreviewLayer!
	//the types the view will look for
	private let metaDataTypes=[AVMetadataObject.ObjectType.qr]
	//the view that will try to go aroung the QR code
	private let qrCodeFocusView=UIView()
	//the string from the qr code or an empty string
	private var qrString=""
	private var mainQueue=DispatchQueue.main
	private var contactToAdd: CNContact!
	private let addContactController=AddContactViewController()
	private let notifcationCenter=NotificationCenter.default
	private var videoCamera: AVCaptureDevice!
	init(getQRViewController: GetQRViewController) {
		super.init()
		self.getQRViewController=getQRViewController
		setUpCameraView()
	}
	/*
	func camera() {
		if UIImagePickerController.isSourceTypeAvailable(.camera){
			let myPickerController = UIImagePickerController()
			myPickerController.sourceType = .camera
			getQRViewController.present(myPickerController, animated: true, completion: nil)
		}
	}
*/
	func setUpCameraView() {
		//camera()
		let addContactNotifier = { () -> Void in
			NotificationCenter.default.post(name: .contactBannerTapped, object: self)
		}
		let dismissSavedBanner = { () -> Void in
			self.getQRViewController.savedBanner.isHidden=true
		}
		self.initializeAVPreviewLayer()
		self.addAVPreviewToScanView()
		if(ContactsPrivacy.check(viewController: getQRViewController, appName: Constants.APPNAME)){
			//create a layer that will show camera output
			//do{
			//try to get video camera and start AV session
			//start AV session--success
			sessionQueue.async {
				do {
					try self.videoCamera=self.getVideoCamera()
					try self.initializeAVSession(videoCamera: try self.getVideoCamera())
					self.session.startRunning()
					//add layer that shows camera output to scanView
					do {
						//try to add metadata output
						try self.addMetaDataOuput()
					} catch {
						//tell error
						print("Couldn't add metadata output: \(error)")
						return
					}
				} catch {
					//tell error
					print("Couldn't get video input: \(error)")
					//end configuring
					self.session.commitConfiguration()
					return
				}
			}
			setUpFocusRectangle()
			getQRViewController.saveBanner.isHidden=true
			getQRViewController.savedBanner.isHidden=true
			getQRViewController.saveBanner.setTapAction(tapAction: addContactNotifier)
			getQRViewController.savedBanner.setTapAction(tapAction: dismissSavedBanner)
			let contactTappedSelector=#selector(respondToContactBannerTap)
			notifcationCenter.addObserver(self, selector: contactTappedSelector, name: .contactBannerTapped, object: nil)
		}
	}
	func startSession() {
		sessionQueue.async {
			self.session.startRunning()
		}
	}
	func initializeAVPreviewLayer() {
		avPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
		avPreviewLayer.frame = getQRViewController.scanView.layer.bounds
		avPreviewLayer.videoGravity = .resizeAspectFill
	}
	func addAVPreviewToScanView() {
		let viewLayer: CALayer = getQRViewController.scanView.layer
		viewLayer.masksToBounds=true
		viewLayer.addSublayer(self.avPreviewLayer)
	}
	func addMetaDataOuput() throws {
		let metaDataOutput = AVCaptureMetadataOutput()
		if session.canAddOutput(metaDataOutput) {
			session.addOutput(metaDataOutput)
			metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metaDataOutput.metadataObjectTypes = metaDataTypes
		} else {
			throw VideoOutputError.outputAdditionFailure("Could not add metadata pouput to AV session")
		}
	}
	func getVideoCamera() throws -> AVCaptureDevice {
		//get a video camera or throw an error
		if let dualCamera = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
			return dualCamera
		} else if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
			return backCamera
		} else if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
			return frontCamera
		} else {
			//if there is no video camera, throw an error
			throw VideoInputError.noCamera("No Camera Error")
		}
	}
	func initializeAVSession(videoCamera: AVCaptureDevice) throws {
		//begin configuration--doesn't end until commitConfiguration is called
		session.beginConfiguration()
		session.sessionPreset = .high
		//check one last time that the app is authorized for video and throw an error if not authorized
		if AVCaptureDevice.authorizationStatus(for: .video)==AVAuthorizationStatus.authorized {
			//get input from the chosen video camera
			let videoCameraInput = try AVCaptureDeviceInput(device: videoCamera)
			//add AV input to session or throw an error
			if session.canAddInput(videoCameraInput) {
				//add the video input to the AV session
				session.addInput(videoCameraInput)
				//end configuring
				session.commitConfiguration()
			} else {
				//if the AV input couldn't be added to the AV session
				throw VideoInputError.inputAdditionFailure("Couldn't add AV input to AV session")
			}
		} else {
			//if somehow the program got here but the camera was not authorized for video
			throw VideoInputError.noAuthorization("Camera video usage was not authorized")
		}
	}
	func metadataOutput(_ output: AVCaptureMetadataOutput,
							didOutput metadataObjects: [AVMetadataObject],
							from connection: AVCaptureConnection) {
		guard let metaData=metadataObjects.first else {
			qrCodeFocusView.isHidden=true
			getQRViewController.saveBanner.isHidden=true
			return
		}
		let transformedMetaDataObj=avPreviewLayer.transformedMetadataObject(for: metaData)
		qrCodeFocusView.frame = transformedMetaDataObj!.bounds
		guard let qrCode=transformedMetaDataObj as? AVMetadataMachineReadableCodeObject else {
			return
		}
		guard let qrCodeString=qrCode.stringValue else {
			return
		}
		if qrString != qrCodeString {
			qrString=qrCodeString
			validContact=false
			do {
				let cnContactArray=try ContactDataConverter.createCNContactArray(vCardString: qrString)
				getQRViewController.saveBanner.messageLabel.text="Save to contacts"
				if cnContactArray.first==nil {
					throw DataConversionError.badVCard("It's not a v card")
				}
				validContact=true
				guard let contact=cnContactArray.first else {
					return
				}
				guard let saveContactBanner=getQRViewController.saveBanner else {
					return
				}
				saveContactBanner.detailLabel.text = ContactInfoManipulator.createPreviewString(cnContact: contact)
				getQRViewController.saveBanner.imageView.image=ContactDataConverter.makeQRCode(string: qrString)
				contactToAdd=cnContactArray.first!
				qrString=""
				qrCodeFocusView.isHidden=false
				getQRViewController.saveBanner.isHidden=false
			} catch {
				validContact=false
				getQRViewController.saveBanner.messageLabel.text="Not a Contact"
				getQRViewController.saveBanner.detailLabel.text="Code doesn't have a readbale contact."
				getQRViewController.saveBanner.imageView.image=UIImage()
			}
		} else {
			qrString=""
			qrCodeFocusView.isHidden=true
			getQRViewController.saveBanner.isHidden=true
			getQRViewController.saveBanner.imageView.image=UIImage()
		}
	}
	func setUpFocusRectangle() {
		qrCodeFocusView.layer.borderColor = UIColor.yellow.cgColor
		qrCodeFocusView.layer.borderWidth = 2
		qrCodeFocusView.backgroundColor=UIColor.clear
		getQRViewController.scanView.addSubview(qrCodeFocusView)
		getQRViewController.scanView.bringSubviewToFront(qrCodeFocusView)
		qrCodeFocusView.isHidden=true
	}
	@objc private func respondToContactBannerTap(notification: NSNotification) {
		/*
		if bad input, dismiss
		if good input, ask permission and add contact
		hide the notification when action is done
		*/
		if ContactsPrivacy.check(viewController: getQRViewController, appName: Constants.APPNAME) {
			if validContact {
				//addContactController.showUI(viewController: scanQRViewController, contact: contactToAdd, forQR: false)
				if let mutableContact = contactToAdd.mutableCopy() as? CNMutableContact {
					let store = CNContactStore()
					let saveRequest = CNSaveRequest()
					saveRequest.add(mutableContact, toContainerWithIdentifier:nil)
					do {
						try store.execute(saveRequest)
					} catch {
						return
					}
					let previewString=ContactInfoManipulator.createPreviewString(cnContact: contactToAdd)
					getQRViewController.savedBanner.detailLabel.text = previewString
					getQRViewController.savedBanner.isHidden=false
					if #available(iOS 13.0, *) {
						let waitTime=DispatchTime.now().advanced(by: DispatchTimeInterval.milliseconds(1000))
						DispatchQueue.main.asyncAfter(deadline: waitTime) {
							self.getQRViewController.savedBanner.isHidden=true
						}
					} else {
						// Fallback on earlier versions
					}
				} else {
					return
				}
			}
			getQRViewController.saveBanner.isHidden=true
			qrCodeFocusView.isHidden=true
		}
	}
	func focusOnTap(tap: UITapGestureRecognizer) {
		let devicePoint = avPreviewLayer.captureDevicePointConverted(fromLayerPoint: tap.location(in: tap.view))
        focus(with: .autoFocus, exposureMode: .autoExpose, at: devicePoint, monitorSubjectAreaChange: true)
	}
	private func focus(with focusMode: AVCaptureDevice.FocusMode,
                       exposureMode: AVCaptureDevice.ExposureMode,
                       at devicePoint: CGPoint,
                       monitorSubjectAreaChange: Bool) {
        sessionQueue.async {
            do {
				try self.videoCamera.lockForConfiguration()
                /*
                 Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
                 Call set(Focus/Exposure)Mode() to apply the new point of interest.
                 */
				if self.videoCamera.isFocusPointOfInterestSupported && self.videoCamera.isFocusModeSupported(focusMode) {
					self.videoCamera.focusPointOfInterest = devicePoint
					self.videoCamera.focusMode = focusMode
                }
				if self.videoCamera.isExposurePointOfInterestSupported && self.videoCamera.isExposureModeSupported(exposureMode) {
					self.videoCamera.exposurePointOfInterest = devicePoint
					self.videoCamera.exposureMode = exposureMode
                }
				self.videoCamera.isSubjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange
				self.videoCamera.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
            }
        }
    }
}
/*
Post this WHENEVER contact banner is tapped
*/
extension Notification.Name {
	//Reference as .contactChanged when type inference is possible
	static let contactBannerTapped=Notification.Name("contact-banner-tapped")
}
//some errors that can occur when working with the camera and AV sessions
enum VideoInputError: Error {
	case noCamera(String)
	case inputAdditionFailure(String)
	case noAuthorization(String)
}
enum VideoOutputError: Error {
	case outputAdditionFailure(String)
}
